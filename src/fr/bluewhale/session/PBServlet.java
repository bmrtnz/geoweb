package fr.bluewhale.session;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.*; 
import javax.servlet.http.*;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;
import org.apache.commons.io.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;


/**
 * Servlet du serveur proxy web-power Builder
 */
public class PBServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Instance du Logger de log4j pour cette classe
	 */
	protected static Logger logger = Logger.getLogger(PBServlet.class);
	
	/**
	 * Serveur PowerBuilder courant
	 */
	private PBServer currentServer ;
	
	/**
	 * Liste des serveurs disponibles 
	 */
	private HashMap serverList = new HashMap();

	/**
	 *  Initialisation de la servlet
	 * prend en charge l'initialisation de :
	 * - log4j
	 *
	 *@param  config                ServletConfig
	 *@exception  ServletException
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		try {
			// configuration de Log4j
			initLog4j();
			
			// initialisation de la liste des serveurs
			// On lit le fichier PBBusiness.properties 
			// qui contient la liste des serveurs PB
			
			initServerList();
			

			// pour l'instant le serveur courant est le seul
			// d�clar� dans le fichier des propri�t�s	
			/*		
			String server =
				ResourceProxy.getBusinessProperty(
					ProxyPbConstants.POWERBUIILDER_SERVER,true);
			String portNumber =
				ResourceProxy.getBusinessProperty(ProxyPbConstants.SOCKET_PORT,true);
				
				setCurrentServer(new PBServer(server,portNumber));
*/
			
		}
			catch (IOException e) {
			logger.fatal("FIN de l'initialisation du syst�me de log", e);
			}
		
		logger.info("Fin d'initialisation de PBServlet pour GEOWEB");
	}
	/**
	 *  Initialisation de la liste des serveurs disponibles 
	 * cette liste est stocke dans l'attribut de servlet
	 * serverList qui est une HasMap
	 */
	private void initServerList() {
			
		String servers = ResourceProxy.getBusinessProperty(ProxyPbConstants.SERVER_LIST,true);
		
		// la String servers est de la forme ip1:port1;ip2;port2
		
		StringTokenizer tokenPointVirgule = new StringTokenizer(servers,";");
		int position = 1 ;
		while (tokenPointVirgule.hasMoreTokens()) {
			  String token = tokenPointVirgule.nextToken();
			  logger.info("un serveur " + token);
			  PBServer aServer = new PBServer(token);
			  aServer.setPosition(position);
			  getServerList().put(new Integer(aServer.getPosition()),aServer);
			  position ++;
		  }

		
	}
	/**
	 * Get method : appelle la methode doPost
	 *@param  request               the HTTPServletRequest
	 *@param  response              the HTTPServletResponse
	 *@exception  ServletException
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.info("Requete de type Get, redirigee vers doPost");

		doPost(request, response);
	}
	/**
	 *  Analyse de la requete Http
	 *
	 *@param  request               HttpServletRequest
	 *@param  response              HttpServletResponse
	 *@exception  ServletException
	 *@exception  IOException
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		logger.info("Requete de type Post");
		
		Hashtable parameters = new Hashtable();
		
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		if(isMultipart) {
			System.out.println("multipart request");
			 parameters = handleFileUpload(request,response);
		}
		else  {
		ServletHelper.printRequest(request);
		}
		


		/**
		 * Appel de la fonction servant uniquement � des tests unitaires
		 * de requetes de differents types
		 * s'il y a eu un cas de test unitaire, on sort de la servlet
		 * **************************************
		 */
		boolean testUnitaire = testsUnitaires(request,response);
		if(testUnitaire)
			return;
		
		/*** Requete � ignorer   ***/
		if(request.getParameter("ignoreRequest") != null) {
			logger.info("Requete ignoreRequest");
  		return;
		}
		

		
		/*** Traitement des requetes directes sans passer par le serveur bw  ***/
		if(request.getParameter("direct") != null) {
			logger.info("Requete directe � la servlet");
			String fichier = null;
			if((fichier = request.getParameter("fichierpdf")) != null) {	
			traitementFichier(request,response,fichier,"pdf");
			} else if ((fichier = request.getParameter("fichierjpg")) != null) {	
			traitementFichier(request,response,fichier,"jpg");
			}
			logger.debug("Requete directe � la servlet");
		/* rien d'autre ne ne passe */
  		return;
		}
		
		// Recuperation des infos du client
		logger.info("Addresse IP du client : " + request.getRemoteAddr() ); 
//		logger.info("Hostname du client : " + request.getRemoteHost() );
//		logger.info("User du client : " + request.getRemoteUser() );
		
		/* gestion du resultat de la requete */
		PowerBuilderResult result = null ;
		//si on n'est pas dans le cas d'une requet multipart 
		// on recupere les parametres de fa�on standard
		if(!isMultipart) {
			parameters = ServletHelper.toHashtable(request);
		}
		try {
			ApplicationController controller = null;
			// recherche de la session, si elle n'existait pas encore, elle est cr��e
			HttpSession session = request.getSession(true);
			if (session == null || session.isNew()) {
				// session = request.getSession(true);
				logger.info("|SESSION| .......... Nouvelle session" ); 
				controller = beginNewSession(request, parameters, session.getId(),choosePBServer());
				session.setAttribute(ProxyPbConstants.PB_WATCHER,new SessionTimer(controller));
				/* pour resoudre les probl�me de cache c�t� browser : */
				/* description du cas : le browser est lanc� par le client */
				/* avec l'url de la servlet. � cause du cache, la requ�te n'est pas du tout */
				/* transmise vers la servlet. Par contre, la page d'accueil envoie la requete "ask_login" */
				/* il faut donc traiter ce cas : nouvelle session identifi�e, avec d�j� le param�tre */
				/* ask_login present. La page est en fait d�j� affich�e, il faut juste */
				/* faire en sorte que la requete soit transmise a serveur PB */
				if(parameters.containsValue("ask_login")) {
					logger.info("Nouvelle session  avec ask_login" );
					result = null ; /* de sorte que le traitement de la requete se poursuive voir plus bas commentaire avec ask_login */
				} else {
				  result = whichPageToDisplayFirst(request);
				}				

			} else { // session existante, on recupere le contexte
				
				// si la requete est vide (cas d'un refresh par exemple 
				// on reinitialise la session et on r�affiche la page d'accueil
				Enumeration params = request.getParameterNames();
				if(!params.hasMoreElements() && !isMultipart) {
					logger.info("Session existante : " + session + " Requete vide => ignor�e retour page d'accueil" ); 
					result = new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.FIRST_PAGE);
//					clearDataSession(session) ;
//					controller = beginNewSession(request, parameters, session.getId(),choosePBServer());
//					session.setAttribute(ProxyPbConstants.PB_WATCHER,new SessionTimer(controller));
					ServletHelper.forwardJSP(this,request,response,"/" + result.getPageName());
					return;
				}
				// session existante, on recupere le contexte
				controller = (ApplicationController) session.getAttribute(ProxyPbConstants.PB_CONTROLLER);
				logger.info("|SESSION| .......... Session existante" ); 
				// ce cas peut se produire apres un dysfonctionnement de l'application
				if (controller == null) {
					controller = beginNewSession(request, parameters, session.getId(),choosePBServer());
					session.setAttribute(ProxyPbConstants.PB_WATCHER,new SessionTimer(controller));
					result = whichPageToDisplayFirst(request);
				} else {
					if(controller.isProcessingRequest()) {
						// une requete est en cours, donc on ne fait rien
						logger.info("|SESSION|REQUETE deja en cours, requete courante bloqu�e" );
						// ServletHelper.forwardHTML(this,response,ProxyPbConstants.REQUETE_EN_COURS);
						return;
					} else {
						// on indique d'une requete est en cours de traitement
						controller.setProcessingRequest(true);
					}
					
				}
				
			}
			/*
			if(request.getParameter("streamMode") != null ) {
				PowerBuilderResult result = controller.processRequest(request,response,parameters);

			} else {
				*/
				/* si pas la premiere connexion */
				if(result == null) {
					// TODO Filtrer la requete de Login si elle n'est pas securisee
					// filterLoginRequest
					result = controller.processRequest(request,parameters);
				} 

				// en fin de traitement, le controller de session est remis
				// a jour comme attribut de session
				session.setAttribute(ProxyPbConstants.PB_CONTROLLER, controller);
				
				
				if (result.isHtml()) { 
					//ServletHelper.forwardHTML(response,result.getPageName());
					ServletHelper.forwardJSP(this,request,response,"/" + result.getPageName());
					logger.info("isHtml Id Session = " + session.getId());
					
				} else if (result.isStream()) {
					//ServletHelper.forwardHTML(response,result.getPageName());
					ServletHelper.forwardStream(response,result.getFlux(),"html");
					logger.info("isStream Id Session = " + session.getId());
					
				} else if (result.isJsp()){
					ServletHelper.forwardJSP(this,request,response,result.getPageName());
					logger.info("isJsp Id Session = " + session.getId());
					
				} else if (result.isXmlXslOut()){
					logger.info("FICHIER XML + FEUILLE XSL OUT ");
					// the result is a XML File : it should be transformed
					// using the embedded xsl file name to the embedded result file */
					int check = result.transformXmlXslOut(controller.getSessionData().getPrefix());
					if(check == 0){
					controller.getSessionData().setPageName(result.getPageName());
					} else {
						// TODO erreur
					}
					
					// ServletHelper.forwardDownload(response,result.getPageName());
					// on passe par la page JSP qui va ouvrir le fichier de resultat
					// tout en gerant le message d'attente
					logger.info("download jsp page = " + result.getPageName() );
					ServletHelper.forwardJSP(this,request,response,"/jsp/download.jsp");
									
					logger.info("isXml Id Session = " + session.getId());
				} 
				
				else if (result.isXml()&& !result.isFlux()){
					
					// the result is a XML File : it should be transformed
					// using an xsl sheet into an html page
					result.transform(controller.getSessionData().getPrefix());
					ServletHelper.forwardJSP(this,request,response,result.getPageName());
					
					//ServletHelper.forwardJSP(this,request,response,"/tmpxml/test_0571820001.html");
									
					logger.info("isXml Id Session = " + session.getId());
					
				}else if (result.isXml() && result.isFlux()){
					
					// the result is a XML File : it should be transformed
					// using an xsl sheet into an html page
					// remarque : s'il n'y pas de feuille de style
					// il n'y a pas de transformation
					// on renvoie directement le flux XML, typ� XML
					String typeDuFlux = result.transformFlux(controller.getSessionData().getPrefix());
					ServletHelper.forwardStream(response,result.getFlux(),typeDuFlux);
					logger.info("isXml Flux Id Session = " + session.getId());
					
				} else if (result.isPdf()){
					result.setPageName("/jsp/openpdf.jsp?file=" + result.getPageName());
					ServletHelper.forwardJSP(this,request,response,result.getPageName());
					logger.info("isPdf Id Session = " + session.getId());
					
				} else if(result.isXmlFo()) { // cas XMLFO, le xml est sous forme de fichier pour transfo vers fichier pdf
					result.transformXSL_FO_PDF(controller.getSessionData().getPrefix());
					result.setPageName("/jsp/openpdf.jsp?file=" + result.getPageName());
					ServletHelper.forwardJSP(this,request,response,result.getPageName());
					logger.info("isXmlFo Flux Id Session = " + session.getId());
					
				} else if (result.isMultiXmlFo()) { // cas MULTIXMLFO il y a plusieurs fichiers xml � transformer en pdf et � concat�ner)
					result.transformXSL_FO_PDF_multiple(controller.getSessionData().getPrefix());
					result.setPageName("/jsp/openpdf.jsp?file=" + result.getPageName());
					ServletHelper.forwardJSP(this,request,response,result.getPageName());
					logger.info("isMultiXmlFo Flux Id Session = " + session.getId());
					
						
				}else if(result.isXmlFoFlux()) { // cas XMLFOFLUX, le xml est sous forme de flux pour transfo vers flux pdf
					result.transformXSL_FO_PDF_Flux(controller.getSessionData().getPrefix());
					ServletHelper.forwardStreamPDF(response,result.getFlux());
					logger.info("isXmlFoFlux Flux Id Session = " + session.getId());
					
				}	

				/* cas d'un fichier de type quelconque a telecharger */
				else if(result.isDownload()) {
					controller.getSessionData().setPageName(result.getPageName());
					// ServletHelper.forwardDownload(response,result.getPageName());
					// on passe par la page JSP qui va ouvrir le fichier de resultat
					// tout en gerant le message d'attente
					ServletHelper.forwardJSP(this,request,response,"/jsp/download.jsp");
				}			
//				 tous les autres cas passent par download (un peu gonfl�)
				else {
						logger.info("result is a file");			
						ServletHelper.forwardDownload(response,result.getPageName());
						
						
				}
			
			// on indique que la requete courante est trait�e.
			controller.setProcessingRequest(false);
			logger.info("Hello, Requete traitee, PBServlet. Id Session = " + session.getId());

			
		} catch (Exception e) {
			logger.error("Exception in servlet !", e);
			HttpSession session = request.getSession(true);
			session.setAttribute("Exception", e);
				ServletHelper.forwardJSP(this,request,response,ProxyPbConstants.ERROR_PAGE);

		}
	}

	/** traitement de l'upload d'un fichier */
	private Hashtable handleFileUpload(HttpServletRequest request, HttpServletResponse response) {
		Hashtable table = new Hashtable();
		//		 Create a factory for disk-based file items
		DiskFileItemFactory factory = new DiskFileItemFactory();
		factory.setSizeThreshold(1024*1000);
	

//		 Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);
		upload.setFileSizeMax(1024*1000); // max 1M
		upload.setSizeMax(1024*1000);

//		 Parse the request
		try {
			List  items = upload.parseRequest(request);
//			 Process the uploaded items
			Iterator iter = items.iterator();
			while (iter.hasNext()) {
			    FileItem item = (FileItem) iter.next();

			    if (item.isFormField()) {
					
					String name = item.getFieldName();
				    String value = item.getString();
			        table.put(name, value);
			    } else {
			    	String userFileName = item.getName();
			    	table.put("user_file",userFileName);
			    	String prefix = getServletContext().getRealPath("/");
			    	String fileName= userFileName + "_" + System.currentTimeMillis();
			    	String fullFileName = prefix + "tmpfiles/" + fileName;
			    	File uploadedFile = new File(fullFileName);
				    try {
						item.write(uploadedFile);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}	
					table.put("file",fileName);
			    }
			}
		} catch (FileSizeLimitExceededException e) {
			logger.error("Taille maximum autoris�e d�pass�e");
			
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return table;
	}


	/**
	 * Determine la page a afficher en premier
	 * Si le parametre httpPBCommand est  present 
	 * et qu'il ne s'agit pas de la commande de login
	 * on affiche la page de demande de reconnection
	 * @param request
	 * @return
	 */
	private PowerBuilderResult whichPageToDisplayFirst(HttpServletRequest request) {
		PowerBuilderResult result = null;
		String commandParameter = request.getParameter(ProxyPbConstants.PB_COMMAND);
		if(commandParameter != null && !commandParameter.equals(ProxyPbConstants.LOGIN_COMMAND)) {
			result = new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.RECONNECT_PAGE);
		} else {
			result = new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.FIRST_PAGE);
		}
		 
		return result;
	}
	/**
	 * Choix du serveur a utiliser
	 * le serveur courant (dernier attribu�)
	 * est memoris� dans l'attribut de servlet
	 * cuurentServer. 
	 * On s'attribue le serveur suivant (position courante + 1)
	 * ou le premier serveur si le serveur courant �tait le dernier
	 * de la liste

	 */
	private PBServer choosePBServer() {
		int position = 1 ;
		
		// si il y a deja un serveur courant
		// on calcule la position du nouveau 
		// sinon on prend le premier serveur
		if(getCurrentServer() != null) {
			position = getCurrentServer().getPosition();
			
			if(position == getServerList().size()) {
				// on revient au premier serveur
				position = 1;
			} else {
				// on prend le serveur suivant
				position = position + 1;
			}		
		
		}
		PBServer newServer = (PBServer)getServerList().get(new Integer(position));
		setCurrentServer(newServer);
		return newServer;
		
	}
	/**
	 * Demarrage d'une nouvelle session :
	 * creation d'une instance de ApplicationController
	 * ouverture de la connexion powerbuilder
	 * activation du mode "maintenance" si 
	 * le parametre de maintenance est present dans la requete
	 * Method beginNewSession.
	 * @param parameters
	 * @return HttpSession
	 */
	private ApplicationController beginNewSession(HttpServletRequest request, Hashtable parameters, String sessionId,PBServer currentServer)  {
		String prefix = getServletContext().getRealPath("/");
		ApplicationController controller = new ApplicationController();
		controller.setProcessingRequest(true);
		controller.getSessionData().setPrefix(prefix);
		controller.getSessionData().setCurrentServer(currentServer);	
		controller.getSessionData().setSessionId(sessionId);

		
        controller.openConnection();
		
		
		// determiner s'il s'agit d'une session de maintenance
		if (parameters.get(ProxyPbConstants.HTTP_MAINTENANCE) != null) {
			controller.getSessionData().setMaintenance(true);
		}
		return controller;
	}
	/**
	 *  Supprime les attributs de session
	 *
	 *@param  session  current HttpSession
	 */
	private void clearDataSession(HttpSession session) {
		session.removeAttribute(ProxyPbConstants.PB_CONTROLLER);
	}
	/**
	 * Method initLog4j. Cherche le nom du fichier de trace dans les ressources
	 * generales et utilise le PropertyConfigurator pour la configuration de Log4j
	 */
	private void initLog4j() throws IOException {
		// Configuration de Log4j
		String log4fFileConf = ResourceProxy.getBusinessProperty(ProxyPbConstants.FILE_CONF_LOG4J,true);
		String prefix = getServletContext().getRealPath("/");
		String path = ResourceProxy.getBusinessProperty(ProxyPbConstants.PATH,true);
		PropertyConfigurator.configure(new File(prefix + path + "Config/" + log4fFileConf).getCanonicalPath());
	}
	/**
	 * Liberation de la servlet 
	 * @see javax.servlet.Servlet#destroy()
	 */
	public void destroy() {
		super.destroy();
	}
	/**
	 * @return
	 */
	public PBServer getCurrentServer() {
		return currentServer;
	}

	/**
	 * @param server
	 */
	public synchronized void  setCurrentServer(PBServer server) {
		logger.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!! changement du serveur courant -> position = " + server.getPosition() + " Server=" + server.getIp() + ":" + server.getPort());
		currentServer = server;
	}



	/**
	 * @return
	 */
	public HashMap getServerList() {
		return serverList;
	}

	/**
	 * @param map
	 */
	public void setServerList(HashMap map) {
		serverList = map;
	}
	
	/**
	 * Code servant uniquement � des tests unitaires pour tester des requetes de differents types
	 * **************************************
	 */

	private boolean testsUnitaires(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		
		if(ResourceProxy.getBusinessProperty("testunitaire").equals("true")) {
			
			String commande = request.getParameter("httpPBCommand");
			
			if(commande != null) {
			
		if(commande.equals("ask_login")) {
//				response.getWriter().write(
//						"<root>" +
//							"<target id='geoLogin'>" +
//								"<span> Login </span> " +
//							"</target>" +
//						"</root>");
			String page = "html/test/login.html";
			File f = new File(getServletContext().getRealPath("/") + page);
			String contenu = Tools.getFileContents(f);
			response.getWriter().write(contenu);
			}
		else if(commande.equals("connexion")) {
			String page = "html/test/expeditions.html";
			File f = new File(getServletContext().getRealPath("/") + page);
			String contenu = Tools.getFileContents(f);
			response.getWriter().write(contenu);
			}
		else if(commande.equals("detailordrefourni")) {
			String page = "html/test/ordre_resume_chep.html";
			File f = new File(getServletContext().getRealPath("/") + page);
			String contenu = Tools.getFileContents(f);
			response.getWriter().write(contenu);
			}

		else if( commande.equals("ask_traca_sub")) {		
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(
				"<root>" +
				"<rows> <row><cell>A</cell> <cell>B</cell><cell>C</cell><cell>D</cell></row></rows>"
					+	
				"</root>");

		}
		else {
			response.getWriter().write(
					"<root>" +
						"<target id='geoColonneMilieu'>" +
							"<span> Commande inconnue </span> " +
						"</target>" +
					"</root>"); 
		}
			
			
		} else {
			/* page d'accueil */
			PowerBuilderResult result = new PowerBuilderResult(ProxyPbConstants.TYPE_HTML,ProxyPbConstants.FIRST_PAGE);
			ServletHelper.forwardJSP(this,request,response,"/" + result.getPageName());
	
		}
			
		return true;
			
		}
		
		
		if(request.getParameter("reponseAjax") != null) {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(
					"<root>" +
						"<target id='geoEnPied'>" +
							"<label> Hello En pied </label> " +
						"</target>" +
						" <target id='geoColonneMilieu'>" +
							"<span> Hello Milieu </span> " +
						"</target>" +
					"</root>");
			return true;
		}
		
		if(request.getParameter("essaiAjax") != null) {
            this.getServletContext().getRequestDispatcher("/html/accueil.html").forward(request,
                    response);
			// ServletHelper.forwardHTML(this,response,"/html/accueil.html");
			return true;
		}
		if(request.getParameter("essaiAjaxOnglet") != null) {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(
					"<root>" +
					/*
					"<target id='geoAction'>" +
							"<h3><a href='#'> Actions </a></h3>" +
								"<div>" +
									"<div><a href='#'>Changer date</a></div>" +
									"<div><a href='#'>Afficher ordre</a></div>" +
								"</div>" +
						"</target>" +
						*/
						"<target id='geoColonneGauche'>" +
							"<label> Colonne gauche "+ request.getParameter("onglet") + 
							"</label> " +
						"</target>" +
						" <target id='geoColonneMilieu'>" +
							"<span> Hello Colonne Milieu " + request.getParameter("onglet") + 
							"</span> " +
						"</target>" +
						" <target id='geoEnPied'>" +
						"<span> Hello En Pied " + request.getParameter("onglet") + 
						"</span> " +
					"</target>" +
					"</root>");
			return true;
		}

		if(request.getParameter("essaiAjaxBouton") != null) {
			response.setContentType("text/html");
			response.setHeader("Cache-Control", "no-cache");
			response.getWriter().write(
					"<root>" +
					/*
					"<target id='geoAction'>" +
					"<h3><a href='#'> Actions </a></h3>" +
						"<div>" +
							"<div><a href='#'>Changer date</a></div>" +
							"<div><a href='#'>Afficher ordre</a></div>" +
						"</div>" +
						
				"</target>" +*/
						"<target id='geoColonneGauche'>" +
							"<label> Colonne gauche "+ request.getParameter("bouton") + 
							"</label> " +
						"</target>" +
						" <target id='geoColonneMilieu'>" +
							"<span> Hello Colonne Milieu " + request.getParameter("bouton") + 
							"</span> " +
						"</target>" +
						" <target id='geoEnPied'>" +
						"<span> Hello En Pied " + request.getParameter("bouton") + 
						"</span> " +
					"</target>" +
					"</root>");
			return true;
		}
		
		if(request.getParameter("essaihtml") != null) {
			ServletHelper.forwardJSP(this,request,response,"/jsp/openhtml.jsp?file=essai.html");
			return true;
		}
		if(request.getParameter("essaixml") != null) {
			PowerBuilderResult res = new PowerBuilderResult('F',"/page.xml");
			res.transform(getServletContext().getRealPath("/"));
			ServletHelper.forwardJSP(this,request,response,res.getPageName());
			return true;
		}
		
		if(request.getParameter("essaixmlfo") != null) {
			PowerBuilderResult res = new PowerBuilderResult('P',"/tmpxml/doc_141059.xml");
			res.transformXSL_FO_PDF(getServletContext().getRealPath("/"));
			res.setPageName("/jsp/openpdf.jsp?file=" + res.getPageName());
			ServletHelper.forwardJSP(this,request,response,res.getPageName());
			return true ;
		}
		if(request.getParameter("essaixmlfoflux") != null) {
			PowerBuilderResult res = new PowerBuilderResult('P',"C:/bluewhale/docserveur/docpost/doc_141059.xml");
			res.transformXSL_FO_PDF_Flux(getServletContext().getRealPath("/"));
			ServletHelper.forwardStreamPDF(response,res.getFlux());
			return true;
		}

	
		if(request.getParameter("essaijsp") != null) {
			ServletHelper.forwardJSP(this,request,response,"/jsp/openhtml.jsp?file=essai.jsp");
			return true;
		}
		if(request.getParameter("essaixmlflux") != null) {
			String data = "07feuille<XML>contenu</XML>";
			
			PowerBuilderResult res = new PowerBuilderResult(data.getBytes(),ProxyPbConstants.TYPE_XML);
			res.transformFlux(getServletContext().getRealPath("/"));
			ServletHelper.forwardStream(response,res.getFlux(),"html");
			return true;
		}
		if(request.getParameter("essaipurxmlflux") != null) {
			
			String data = "<root><inputs>" + 
			"<input id='geoTexte' ok='false'> </input>" + 			
					"</inputs><msgs><msg> Il y a une erreur </msg><msg> Il y a une autre erreur </msg></msgs></root>";
			response.setContentType("text/xml");
			response.setHeader("Cache-Control", "no-cache");
			logger.info("essaipurxmlflux " + data);
			response.getWriter().write(data);
			
			return true;
		}

		return false;	
	}
	/** Traitement de requetes directes. Ces requetes ne passent pas par le serveur
	 * Cas 1 : ouverture d'un fichier PDF en stream
	 * @param request
	 * @param response
	 */
	private void traitementFichier(HttpServletRequest request,
			HttpServletResponse response,String fichier,String type) {	
			  logger.info("ouverture directe de fichier PDF ou JPG " + fichier );
              byte [] contenuFichier = null ;
              byte [] localBuffer = new byte[32768];
              try {
           	   URL url = new URL(fichier);
           	   InputStream ins = url.openStream();
          		   ByteArrayOutputStream outPutData = new ByteArrayOutputStream();

           	   /* boucle de lecture */
          	   /* on lit par bloc de 32 Kb */
          		   
          		int longueurLue = 0 ;
          		do {

       			longueurLue = ins.read(localBuffer,0,32768);
       			if(longueurLue != -1) {
       			outPutData.write(localBuffer,0,longueurLue);		
       			logger.info("Lecture d'un paquet dans fichier PDF ou IMG. Longueur Donn�es byte lues = " + longueurLue );
       			} else
       			{
	        		logger.info("Fin du fichier");
       			}
       			
       		}  while (longueurLue != -1);
          		   	           		   
          		   /* fin boucle de lecture */
          		
          		   contenuFichier = outPutData.toByteArray();
          		   outPutData.close(); 	    
           	 }
           	 catch (MalformedURLException e) {
        			logger.error("MalformedURLException" + e.getMessage());
           	 }
           	 catch (IOException e) {
	         		logger.error("IOException" + e.getMessage());
           	 } 
           	 	if(type.equalsIgnoreCase("pdf")) {
           	 
    			ServletHelper.forwardStreamPDF(response,contenuFichier);
           	 	} else {
        			ServletHelper.forwardStreamIMG(response,contenuFichier);

           	 	}
		
	}
}
