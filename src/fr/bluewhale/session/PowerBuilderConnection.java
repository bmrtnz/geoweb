/*
 * Nom: PowerBuilderConnection.java
 * Package: fr.bluewhale.proxypb.session
 * Date: 18 juin 2004
 * Auteur: Administrateur
 */
package fr.bluewhale.session;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;

import org.apache.log4j.Logger;

/**
 * Description : ... Branche $Name:  $. Date de création : 18 juin 2004
 * @author Administrateur
 * @version $Revision: 1.3 $
 *
 */
public class PowerBuilderConnection {
	/**
	 * Instance du Logger de log4j pour cette classe
	 */
	protected static Logger logger = Logger.getLogger(PowerBuilderConnection.class);

	
	Socket socket = null;
	
	private InputStream socketInputStream;

	/**
	 *  writer pour la socket associée à la session
	 */
	private PrintWriter socketOut = null;
	
	/**
	 * buffer pour les entrées sur la socket associée à la session
	 */
	private BufferedReader socketIn = null;

	/**
	 * @return
	 */
	public BufferedReader getSocketIn() {
		return socketIn;
	}

	/**
	 * @return
	 */
	public InputStream getSocketInputStream() {
		return socketInputStream;
	}

	/**
	 * @return
	 */
	public PrintWriter getSocketOut() {
		return socketOut;
	}

	/**
	 * @param reader
	 */
	public void setSocketIn(BufferedReader reader) {
		socketIn = reader;
	}

	/**
	 * @param stream
	 */
	public void setSocketInputStream(InputStream stream) {
		socketInputStream = stream;
	}

	/**
	 * @param writer
	 */
	public void setSocketOut(PrintWriter writer) {
		socketOut = writer;
	}

	/**
	 * 
	 */
	public Socket  openConnexion(String server, int portNumber)	{
		
		SystemMail oMail = new SystemMail();
		String strSmtp = ResourceProxy.getBusinessProperty("SmtpServer");
		String strFrom = ResourceProxy.getBusinessProperty("MailFrom");
		String strTo = ResourceProxy.getBusinessProperty("MailTo");
		String strAppName = ResourceProxy.getBusinessProperty("AppName");
		
		PrintWriter out = null;
		BufferedReader in = null;
		InputStream inStream = null;

		try {

			Socket sock  = new Socket(server, portNumber);
			int s = sock.getSendBufferSize();
			int r = sock.getReceiveBufferSize();
			setSocket(sock);
			out = new PrintWriter(sock.getOutputStream(), true);

			
			inStream = sock.getInputStream();
			in =
				new BufferedReader(
					new InputStreamReader(sock.getInputStream()));			
					
			this.setSocketIn(in);
			this.setSocketInputStream(inStream);
			this.setSocketOut(out);
			
			// lecture de la reponse serveur
			/*
			char [] data = new char[1000];
			int lenght = getSessionData().getSocketIn().read(data);
			
			if (data[0] == '1') {
				logger.info("Connexion OK") ;
			} else {
				logger.error("Connexion OK" + data.toString()) ;
			}
			*/
			
		} catch (UnknownHostException e) {
			logger.error("Machine " + server + "port : " + portNumber + " inconnu");
			if(strSmtp != "") oMail.Send(strFrom, strTo, strAppName + " ERROR", strSmtp, null, null, "Machine " + server + " port : " + portNumber + " inconnu");
		} catch (IOException e) {
			logger.error("IOException" + e.getMessage());
			if(strSmtp != "") oMail.Send(strFrom, strTo, strAppName + " ERROR", strSmtp, null, null, "Machine " + server + " port : " + portNumber + " inconnu<br>" + e.getMessage());
		}

	return getSocket();
	}

	/**
	 *  Fermeture propre d'une connection avec le serveur
	 */
	public void closeConnection() throws IOException {
		
		this.getSocket().close();
		this.getSocketIn().close();
		this.getSocketOut().close();
		this.getSocketInputStream().close();
		
	}
	/**
	 * @return
	 */
	public Socket getSocket() {
		return socket;
	}

	/**
	 * @param socket
	 */
	public void setSocket(Socket socket) {
		this.socket = socket;
	}

	/**
	 * @return
	 */
	public boolean isValid() {
		return ( getSocket() != null && getSocketOut() != null);
	}

	/**
	 * @param powerBuilderRequest
	 */
	public void write(String request) {
		getSocketOut().println(request);
		getSocketOut().flush();
		
		
	}

	/** FONCTION NON UTILISEE
	 * @param data
	 * @return
	 */
	/*public int read(char[] data) throws IOException{
		
		int socketSize = Integer.parseInt(ResourceProxy.getBusinessProperty("socketSize"));
		char [] localData = new char [socketSize];
		byte [] localByte = new byte [socketSize];
		String finalString ="";
		int finalLength = 0;
		int length = 0;
		
		// on se met en lecture bloquante pour lire l'entete qui 
		// contient la taille des données à lire
		// cet entete est une string de 10 caractères.
		char  []header  = new char[10];
		
		int read =  getSocketIn().read(header,0,10);
		
		String headerAsString  = new String(header);
		
		int lengthToRead = Integer.parseInt(headerAsString);
		
		// on se met en lecture bloquante pour lire la totalité
		// cette lecture se fait par bloc de 2048 (taille des blocs)
		// envoyé par PowerBuilder
		
		logger.info("Taille des données int à lire : " + lengthToRead);
		
		
		while(finalLength < lengthToRead) {
			
			
			length = getSocketIn().read(localData,0,socketSize);	 
			String localString = new String(localData,0,length);
			finalString = finalString + localString ;
			finalLength = finalLength + length;
			
			
		}
		
		logger.info("données int reçues de longueur " + finalLength + " : \n data");
		finalString.getChars(0,finalString.length(),data,0);
		
		return finalLength ;
	}
*/

	/**
	 * @param data
	 * @return
	 */
	public byte [] read() throws IOException{
		int socketSize = Integer.parseInt(ResourceProxy.getBusinessProperty("socketSize"));

		byte [] data ;
		byte [] localByte = new byte [socketSize];
		int finalLength = 0;
		int length = 0;
		
		// on se met en lecture bloquante pour lire l'entete qui 
		// contient le type des donnes et la taille des données à lire
		// cet entete est une string de 11  caractères (1 caractere pour
		// le type et 10 caracteres pour la longueur)
		byte  []header  = new byte[11];
		
		int read  = getSocket().getInputStream().read(header,0,11);
			
		String headerAsString  = new String(header);
		
		// le type est le premier caractere
		/*char dataType = headerAsString.charAt(0);*/
		
		// la longueur est donnee par le reste de la chaine
		long lengthToRead = Long.parseLong(headerAsString.substring(1));
		
		// on se met en lecture bloquante pour lire la totalité
		// cette lecture se fait par bloc de 2048 (taille des blocs)
		// envoyé par PowerBuilder
		
		logger.info("Taille des données byte à lire : " + lengthToRead);
		
		ByteArrayOutputStream outPutData = new ByteArrayOutputStream();
		
		// ecriture du premier byte du header qui contient le type
		outPutData.write(header,0,1);
		
		while(finalLength < lengthToRead) {

			length = getSocket().getInputStream().read(localByte,0,socketSize);
			
			outPutData.write(localByte,0,length);	
			finalLength = finalLength + length ;	
			logger.info("Lecture d'un paquet . Données byte lues = " + length + "total = " + finalLength);
			
		}
		
		data = outPutData.toByteArray();
		
		outPutData.close();
		
		logger.info("données byte reçues de longueur " + data.length + " : \n data");
		
		// le premier byte des data contient le type
		return data;
			}

}
