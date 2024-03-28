/*
 * Nom: ApplicationController.java
 * Package: fr.bluewhale.proxypb.session
 * Date: 15 juin 2004
 * Auteur: Administrateur
 */
package fr.bluewhale.session;


import java.io.File;

import java.io.IOException;

import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.http.HttpServletRequest;


import org.apache.log4j.Logger;

/**
 * Description : ... Branche $Name:  $. Date de création : 15 juin 2004
 * @author Administrateur
 * @version $Revision: 1.1 $
 * 
 */
public class ApplicationController {
	/**
	 * Instance du Logger de log4j pour cette classe
	 */
	protected static Logger logger = Logger.getLogger(ApplicationController.class);
	
	/**
	 * flag indiquant qu'une requete est en cours de traitement
	 * ce flag permet de bloquer le traitement d'une deuxieme requete
	 */
	boolean isProcessingRequest = false;

	private HttpServletRequest currentRequest ;

	private SessionData sessionData = new SessionData();
	/**
	 * @return
	 */
	public SessionData getSessionData() {
		return sessionData;
	}

	/**
	 * @param data
	 */
	public void setSessionData(SessionData data) {
		sessionData = data;
	}

	/**
	 * Constructeur par defaut du controleur d'application
	 */
	public ApplicationController() {
		
	}

	/**
	 * Constructeur du controleur d'application
	 * initialisant une connectin PB
	 */
	public ApplicationController(boolean connection) {
		
		if(connection) {
			// ouverture d'une nouvelle connexion
			PowerBuilderConnection currentConnection = openConnection();
			
			// memorisation de la connection dans SessionData
			getSessionData().setCurrentConnection(currentConnection);		

		}
		
	}

	/**
	 * Traitement d'une requete : transformation des parametres
	 * Http en une String
	 * Ajout dans cette String du parametre d'identifiant de session
	 * Envoi au serveur de la requete
	 * Attente de la reponse
	 * @param request
	 * @param parameters
	 */
	public PowerBuilderResult  processRequest(HttpServletRequest request,Hashtable parameters){
		// on garde une reference sur la requete courante
		setCurrentRequest(request);
				
		if (!getSessionData().getCurrentConnection().isValid() ) {
			// pas de connexion 
			ServletHelper.addErrorMessage(getCurrentRequest(),"Pas de connexion valide avec le serveur");

			PowerBuilderResult result = new PowerBuilderResult(ProxyPbConstants.TYPE_JSP,ProxyPbConstants.ERROR_PAGE);
			return result;
		}
				

		
		String httpParameters = parameters.toString();
		
		Enumeration parameterList = parameters.keys();
		
		String powerBuilderRequest = "SessionId=" + getSessionData().getSessionId();
		
		while(parameterList.hasMoreElements()) {
			String key = (String) parameterList.nextElement();
			powerBuilderRequest = powerBuilderRequest + "&" + key + "=" + parameters.get(key);
			
		}
		powerBuilderRequest = addClientAddress(request.getRemoteAddr(),powerBuilderRequest);
	
		logger.info("Requete vers powerBuilder : " + powerBuilderRequest);
		int requestLength = powerBuilderRequest.length();
		logger.info("Longueur requete : " + powerBuilderRequest.length());
		
		String usefulMessageLength = ServletHelper.padd(requestLength);
		
		String message = ProxyPbConstants.BLOB + usefulMessageLength + powerBuilderRequest ;
		// transmission de la requete courante
		getSessionData().getCurrentConnection().write(message);
		
		// attente de la reponse
		try {
			byte [] data  = null ;
			// lecture des donnees
			data = getSessionData().getCurrentConnection().read();

			// analyse des données
			return(analyseData(data,data.length));
		} catch (IOException e) {
			logger.error("IOException en lecture de socket \n " + e.getMessage());
			ServletHelper.addErrorMessage(getCurrentRequest(),"Erreur de lecture sur le canal de communication");

			return new PowerBuilderResult(ProxyPbConstants.TYPE_JSP,ProxyPbConstants.ERROR_PAGE);

		} 
		
		
		/*
		String essaiPage = new String("1<html>\n <body> \n <H2> Page dynamique </h2> </body> </html>");

		try {
			return(analyseData(essaiPage.toCharArray(),essaiPage.length()));
		} catch (IOException e) {
			logger.error("IOException en lecture de socket : \n" + e.getMessage());
			return ProxyPbConstants.ERROR_PAGE;
		} 	
		*/	
		
	}


	/**
	 * Ajout de l'adresse du client seulement
	 * si la requete est la requete de connection
	 * @param powerBuilderRequest
	 */
	private String addClientAddress(String clientIP,String powerBuilderRequest) {
		if(powerBuilderRequest.indexOf(ProxyPbConstants.CONNECTION_COMMAND) != -1) {
			powerBuilderRequest = powerBuilderRequest + "&IPAddress=" + clientIP ;
		}
		return powerBuilderRequest;
		
	}

	/**
	 * ouverture d'une connexion
	 * le serveur et son port dans dans le PBServer courant
	 * @return
	 */
	public PowerBuilderConnection openConnection() {

		
		String server = getSessionData().getCurrentServer().getIp();
		int portNumber = getSessionData().getCurrentServer().getPort();
		PowerBuilderConnection currentConnection = new PowerBuilderConnection();
		currentConnection.openConnexion(server,portNumber);
		getSessionData().setCurrentConnection(currentConnection);
		
		return currentConnection;
	}




	/** Analyse des donnee envoye par PowerBuilder
	 * Octet 0 : type des donnees B = blob F = File
	 * 	 
	 * @param data
	 * @return page de resultat
	 */
	// Ar 26/10/05 c'est le bon analyseData (oublier les 2 autres plus loin)
	// autorise EXPLICITEMENT les fichiers autres que pdf (implicitement avant)
	// voir PBServlet.doPost pour l'utilisation du return
	public PowerBuilderResult  analyseData(byte[] data,int length) throws IOException {
		PowerBuilderResult result = null;
		  

	// si les données contiennent le nom d'un fichier
	//  determiner le type du fichier
	if (data[0] == ProxyPbConstants.FILE) {   // type F
		logger.info("type de données  FILE" + data);
		
		String dataString = new String(data);
		String fileName = dataString.substring(1,length);
		logger.info("File Name : " + fileName);
		
		// determiner le type du fichier 
		char fileType = readFileType(fileName);
		logger.info("fileType : " + fileType);
		
		boolean ready = true ; // indique si le fichier est pret
		// si c'est un fichier pdf il faut attendre qu'il soit pret
		if(fileType == ProxyPbConstants.TYPE_PDF) {
			 ready =  waitForFile(getSessionData().getPrefix()  + fileName);
		} else {
			ready = true;	// aucune attente pour n'importe quel autre fichier (pas seult .bw)
		}
		
		if (ready) {
			result = new PowerBuilderResult(fileType,fileName);
		} else {
			result = new PowerBuilderResult(ProxyPbConstants.TYPE_JSP,ProxyPbConstants.ERROR_PAGE);

		}
	}
		/* cas d'un fichier quelconque a downloader */
		else if (data[0] == ProxyPbConstants.DOWNLOAD) { // type D
			logger.info("type de données  DOWNLOAD" + data);
			
			String dataString = new String(data);
			String fileName = dataString.substring(1,length);
			logger.info("File Name : " + fileName);
			
			result = new PowerBuilderResult(ProxyPbConstants.DOWNLOAD,fileName);
		
	} else if (data[0] == ProxyPbConstants.BLOB) { // type B
		logger.info("type de données  BLOB" + data);
		byte [] dataDst = new byte[data.length - 1];

		// flux a renvoyer directement au client
		// il faut enlever le premier octet qui contient le type
		System.arraycopy(data,1,dataDst,0,data.length -1);
		
		result = new PowerBuilderResult(dataDst);
	}
	else if (data[0] == ProxyPbConstants.XML) {// type X
		logger.info("type de données  XML" + data);
		String test = new String(data);
		logger.warn("type de données  XML" + test);
		byte [] dataDst = new byte[data.length - 1];

		// flux a renvoyer directement au client
		// il faut enlever le premier octet qui contient le type
		System.arraycopy(data,1,dataDst,0,data.length -1);
		
		result = new PowerBuilderResult(dataDst,ProxyPbConstants.TYPE_XML);
			}
	else if (data[0] == ProxyPbConstants.XML_XSL_OUT) {// type A
		logger.info("type de données  FILE XML/XSL/OUT" + data);
		
		String dataString = new String(data);
		String fileNames = dataString.substring(1,length);
		logger.info("File Name : " + fileNames);
		result = new PowerBuilderResult(fileNames,ProxyPbConstants.XML_XSL_OUT);
	}
	else if (data[0] == ProxyPbConstants.XMLFO) {// type P
		logger.info("type de données  FILE XML FO" + data);
		
		// le nom  du fichier xml à transformer est passé dans la socket
		// pour transformation vers fichier PDF
		
		String dataString = new String(data);
		String fileNames = dataString.substring(1,length);
		logger.info("File Name : " + fileNames);
		result = new PowerBuilderResult(fileNames,ProxyPbConstants.XMLFO);
	}
	else if (data[0] == ProxyPbConstants.XMLFOFLUX) {// type Y
		logger.info("type de données  FILE XML FO VERS FLUX" + data);
		
		// le flux XML  à transformer est passé dans la socket
		// pour transformation vers flux
		String test = new String(data);
		logger.debug("type de données  XML pou FO" + test);		
		byte [] dataDst = new byte[data.length - 1];

		// flux xml à traiter
		// il faut enlever le premier octet qui contient le type
		System.arraycopy(data,1,dataDst,0,data.length -1);
		
		result = new PowerBuilderResult(dataDst,ProxyPbConstants.XMLFOFLUX);
	}
	else if (data[0] == ProxyPbConstants.MULTIXMLFO) {// type Q
		logger.info("type de données  MULTI FILE XML FO " + data);
		
		// le nom  du fichier xml contenant la liste des fichiers à transformer en PDF est passé dans la socket
		String dataString = new String(data);
		String fileNames = dataString.substring(1,length);
		logger.debug("File Name : " + fileNames);
		result = new PowerBuilderResult(fileNames,ProxyPbConstants.MULTIXMLFO);
	}
	else {
		// type de données inconnu
		logger.info("type de données inconnu " + data[0]);
		result = new PowerBuilderResult(ProxyPbConstants.TYPE_JSP,ProxyPbConstants.ERROR_PAGE);	
		ServletHelper.addErrorMessage(getCurrentRequest(),"type de données inconnu " + data[0]);
		
	}

	return result ;
	}

	/**
	 * determiner le type du fichier a partir de son extension
	 * html, jsp, pdf
	 * @param fileName
	 * @return
	 */
	// AR 26/10/05 implémente type bw
	// AR 20/09/07 implémente type bw pou fichier .xpr
	private char readFileType(String fileName) {
		char type = ProxyPbConstants.TYPE_HTML ; // valeur par defaut
		String extension = Tools.readExtension(fileName);
		if(extension.equals("pdf")) {
			type = ProxyPbConstants.TYPE_PDF ;
		} else if (extension.equals("html")) {
			type = ProxyPbConstants.TYPE_HTML ;
		} else if (extension.equals("jsp")) {
					type = ProxyPbConstants.TYPE_JSP;
		} else if (extension.equals("doc")) {
							type = ProxyPbConstants.TYPE_WORD;
		} else if (extension.equals("bw")) {
							type = ProxyPbConstants.TYPE_BW;
		} else if (extension.equals("xpr")) {
			type = ProxyPbConstants.TYPE_BW;
	} else if (extension.equals("xml")) {
		type = ProxyPbConstants.TYPE_XML;
	}
		return type ;
	}

	/** attente pendant waitForFile secondes le associé
	 * au fichier principal soit pret
	 * Le nom de ce fichier est "Done" concatene au  nom du fichier principal
	 * waitForFile est une ressource dans le fichier PBBusiness.properties
	 * indiquant le temps maximal d'attente
	 * @param fileName nom du fichier
	 * @return true ou false indiquant que le fichier est pret
	 */
	private boolean waitForFile(String fileName) {
		// String beginning = Tools.removeExtension(fileName);
		// String testFileName = beginning + "pdfDone" + ".pdf";
		String testFileName = fileName;
		
		int waitTime = Integer.parseInt(ResourceProxy.getBusinessProperty("waitForFile",true));

		try {
		for(int i =0 ;i< waitTime ;i++) {
			File testFile = new File(testFileName);
			if(testFile.exists()) {
				// le fichier indiquant que la generation pdf est 
				// terminee existe
				logger.info("Fichier " + testFileName + "pret  au bout de " + i + " secondes ");
					return true;
				} else {
					logger.info("Fichier " + testFileName + " pas pret");
					Thread.sleep(500);
				}

		}
		ServletHelper.addErrorMessage(getCurrentRequest(),"Fichier " + fileName + " pas pret au bout de " + waitTime +" secondes");

		} catch (InterruptedException e) {
			logger.error("probleme dans l'attente fichier : " + e.getMessage());
			e.printStackTrace();
			return false;
		}
		return false;
	}

	/**
	 * @return
	 */
	public HttpServletRequest getCurrentRequest() {
		return currentRequest;
	}

	/**
	 * @param request
	 */
	public void setCurrentRequest(HttpServletRequest request) {
		currentRequest = request;
	}

	public boolean isProcessingRequest() {
		//return isProcessingRequest;
		return false;
	}

	public void setProcessingRequest(boolean isProcessingRequest) {
		//this.isProcessingRequest = isProcessingRequest;
		// on ne traite plus le cas des  requetes en cours
		this.isProcessingRequest = false;
	}
	


} /* fin de la classe */

/* code périmé */

	/**
	 * Traitement d'une requete : transformation des parametres
	 * Http en une String
	 * Ajout dans cette String du parametre d'identifiant de session
	 * Envoi au serveur de la requete
	 * Attente de la reponse
	 * @param request
	 * @param parameters
	 */
	/*
	public PowerBuilderResult  processRequestTestHtml(HttpServletRequest request,Hashtable parameters){

		String essaiPage = new String("1<html>\n <body> \n <H2> Page dynamique </h2> </body> </html>");

		try {
			return(analyseData(essaiPage.toCharArray(),essaiPage.length()));
		} catch (IOException e) {
			logger.error("IOException en lecture de socket : \n" + e.getMessage());
			return new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.ERROR_PAGE);
		} 	
		
	}
*/
	/** Analyse des donnee envoye par PowerBuilder
	 * @param data
	 * @deprecated
	 * @return page de resultat
	 */
	/*
	private PowerBuilderResult  analyseData(char[] data,int length) throws IOException {
		
		char typeOfPage = data[0];
		String  pageName ;
		PowerBuilderResult result = null;
		
		long time = new Date().getTime(); 
		if(typeOfPage == ProxyPbConstants.TYPE_HTML ) {
			pageName = "html/" + time + ProxyPbConstants.PAGE_SUFFIX + ".html" ;
			// creation du  fichier en sortie
		
			File newPage = new File(getSessionData().getPrefix() + "/" + pageName);
			newPage.createNewFile();

			FileWriter fileOut  = new  FileWriter(newPage);
			fileOut.write(data,1,length-1);
			fileOut.close();
			
			result = new PowerBuilderResult(typeOfPage,pageName);

		} else if (typeOfPage == ProxyPbConstants.TYPE_PDF) {
			pageName = "pdf/" + time + ProxyPbConstants.PAGE_SUFFIX + ".pdf" ;
			File newPage = new File(getSessionData().getPrefix() + "/" + pageName);
			newPage.createNewFile();

			FileWriter fileOut  = new  FileWriter(newPage);
			fileOut.write(data,1,length-1);
			fileOut.close();


			result = new PowerBuilderResult(typeOfPage,pageName);
			
			// on garde le tableau des données sauf le premier octet
			String extraction = new String(data);
			
			int maxSize = Integer.parseInt(ResourceProxy.getBusinessProperty(ProxyPbConstants.PAGE_MAX_SIZE));
			char [] dataOut  = new char[maxSize];

			extraction.getChars(1,extraction.length(),dataOut,0);		
			result.setData(dataOut);
			
		} else {
			logger.error("Type de page non pris en charge " + typeOfPage);
			result.setType(typeOfPage);
			result.setPageName(ProxyPbConstants.ERROR_PAGE);
					}


		return result;

	}
	*/

	/**
	 * @param request
	 * @param response
	 * @param parameters
	 * @return
	 */
	/*
	public PowerBuilderResult processRequest(HttpServletRequest request, HttpServletResponse response, Hashtable parameters) {
		PowerBuilderConnection currentConnection = openConnection();
		
	
		

		if (!currentConnection.isValid() ) {
			// pas de connexion 
			PowerBuilderResult result = new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.ERROR_PAGE);
			return result;
		}
		String sessionId = request.getSession().getId();
		
		getSessionData().setSessionId(sessionId);
		
		parameters.toString();
		
		String httpParameters = parameters.toString();
		
		String powerBuilderRequest = "SessionId=" + sessionId + "," + httpParameters;
	
		currentConnection.write(powerBuilderRequest);
		
		// attente de la reponse
		
		
		try {
						
			OutputStream output = response.getOutputStream();
			int octet;
			while((octet = currentConnection.getSocket().getInputStream().read())> -1) {
			
				output.write(octet);
			}
			
			output.flush();
			currentConnection.closeConnection();
			return null;
		} catch (IOException e) {
			logger.error("IOException en lecture de socket \n " + e.getMessage());
			return new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.ERROR_PAGE);
		} 
	}
*/

	/** Analyse des donnee envoye par PowerBuilder
	 * Octet 0 : type des donnees B = blob F = File
	 * @param data
	 * @return page de resultat
	 */
	/*
	private PowerBuilderResult  analyseData(byte[] data,int length) throws IOException {
		
		byte typeOfPage = data[0];
		String  pageName ;
		PowerBuilderResult result = null;
		
		long time = new Date().getTime(); 
		if(typeOfPage == ProxyPbConstants.TYPE_HTML ) {
			pageName = "temphtml/" + time + ProxyPbConstants.PAGE_SUFFIX + ".html" ;
			// creation du  fichier en sortie
		
			File newPage = new File(getSessionData().getPrefix() + "/" + pageName);
			newPage.createNewFile();

			FileOutputStream fileOut  = new  FileOutputStream(newPage);
			fileOut.write(data,1,length-1);
			fileOut.close();
			
			result = new PowerBuilderResult((char)typeOfPage,pageName);

		} else if (typeOfPage == ProxyPbConstants.TYPE_PDF) {
			pageName = "temppdf/" + time + ProxyPbConstants.PAGE_SUFFIX + ".pdf" ;
			File newPage = new File(getSessionData().getPrefix() + "/" + pageName);
			newPage.createNewFile();

			FileOutputStream fileOut  = new  FileOutputStream(newPage);
			fileOut.write(data,1,length-1);
			fileOut.close();


			result = new PowerBuilderResult((char)typeOfPage,pageName);

			
		}  else if (typeOfPage == ProxyPbConstants.TYPE_WORD) {
		pageName = "tempdoc/" + time + ProxyPbConstants.PAGE_SUFFIX + ".doc" ;
		File newPage = new File(getSessionData().getPrefix() + "/" + pageName);
		newPage.createNewFile();

		FileOutputStream fileOut  = new  FileOutputStream(newPage);
		fileOut.write(data,1,length-1);
		fileOut.close();


		result = new PowerBuilderResult((char)typeOfPage,pageName);

			
	}
		
		
		else {
			logger.error("Type de page non pris en charge " + typeOfPage);
			result.setType((char)typeOfPage);
			result.setPageName(ProxyPbConstants.ERROR_PAGE);
					}


		return result;

	}
	*/