/*
 * Nom: ProxyPbConstants.java
 * Package: fr.bluewhale.proxypb.session
 * Date: 15 juin 2004
 * Auteur: Administrateur
 */
package fr.bluewhale.session;

/**
 * Description : ... Branche $Name:  $. Date de création : 15 juin 2004
 * @author Administrateur
 * @version $Revision: 1.2 $
 *
 */
public class ProxyPbConstants {

	
	
	public static String SERVER_LIST  = "pbServers" ;
	public static String  PADD_STRING = "0000000000" ;
	/**
	 * Premier octet des messages socket indiquant le type de message
	 */
	public static char BLOB = 'B';
	public static char FILE = 'F';	
	public static char XML = 'X';
	public static char DOWNLOAD = 'D';
    /* message contenant le nom d'un fichier xml, de la feuille de style xsl */
	/* et le nom du fichier de sortie */
	public static char XML_XSL_OUT = 'A';
	/* constantes indiquant qu'on traite une generation de pdf avec FO */
	/* soit depuis un fichier xml, soit depuis un flux xml */
	public static char XMLFO = 'P';
	public static char XMLFOFLUX = 'Y';
	
	/* generation multiple de PDF avec FO */
	/* a partir d'un fichier xml contenant la liste des sous fichiers à transformer */
	public static char MULTIXMLFO = 'Q';
	
	
	/* correspondance avec type de sortie souhaitée
	 * (plus utilisé à partir de XMLFO, car c'était redondant)
	 */
	public static char  TYPE_HTML = '1';
	public static char  TYPE_PDF = '2';
	public static char TYPE_WORD = '3';
	public static char TYPE_JSP = '4';
	public static char TYPE_BW = '5';
	public static char TYPE_XML = '6';
	public static char TYPE_XML_XSL_OUT = '7';
	
	public static String FILE_CONF_LOG4J = "confLog4jFile";
	/* PROPERTIES */
	public static String ERROR_FILE_NAME = "PBMessages";
	public static String BUSINESS_FILE_NAME ="PBBusiness";
	public static String PATH = "path";
	// public static String PAGE_MAX_SIZE = "pageMaxSize";
	
	//	parametres de connexion power builder
	public static String POWERBUIILDER_SERVER = "powerBuilderServer";
	public static String SOCKET_PORT = "socketPort";
	
	public static String PB_CONTROLLER = "pbController";
	public static String PB_WATCHER = "watchSession";
	public static String ERROR_PAGE = "/html/erreur.html";
	public static String DEFAULT_PAGE = "html/accueil.html";
	public static String PAGE_SUFFIX = "dynamicPage";

	
	
	// Parametres Http
	public static String HTTP_MAINTENANCE = "httpMaintenance";
	
	
	// parametres du serveur Http
	/**
	 *  http protocol
	 */
	public final static String WEB_PROTOCOL = "http://";
	/**
	 *  https protocol
	 */
	public final static String WEB_SSL_PROTOCOL = "https://";

	/**
	 *  Default port number
	 */
	public final static int WEB_DEFAULT_PORT_NUMBER = 8080;
	/**
	 *  Web default timeout
	 */
	public final static int WEB_DEFAULT_TIMEOUT = 3600;
	/**
	 *  Default secure port number
	 */
	public final static int WEB_DEFAULT_SSL_PORT_NUMBER = 8888;
	public static final String REQUETE_EN_COURS = "/html/requeteEnCours.html";
	
	/**
	 * page d'accueil
	 */
	
	public static String FIRST_PAGE = "/html/accueil.html";
	
	/**
	 * page d'accueil
	 */
	
	public static String RECONNECT_PAGE = "/html/reconnect.html";

	/**
	 * commande de login
	 */
	
	public static String LOGIN_COMMAND = "ask_login";
	
	/**
	 * parametre commande PB
	 */
	
	public static String PB_COMMAND = "httpPBCommand";
	/**
	 * commande de connection
	*/	
	public static String CONNECTION_COMMAND = "connexion";

}
