/*
 * Nom: SessionData.java
 * Package: fr.bluewhale.proxypb.session
 * Date: 15 juin 2004
 * Auteur: Administrateur
 */
package fr.bluewhale.session;

/**
 * Description : ... Branche $Name:  $. Date de création : 15 juin 2004
 * Données de Session
 * @author Administrateur
 * @version $Revision: 1.1 $
 *
 */
public class SessionData {
	/**
	 * Prefix de l'application
	 */
	private String prefix;
	/**
	 * Identifiant unique de la session courante
	 */
	private String sessionId;
	/**
	 * caracteristiques de la connexion courante
	 */
	private PowerBuilderConnection currentConnection;
	/**
	 * caracteristiques du serveur Powerbuilder courant
	 */
	private PBServer currentServer;

	
	/**
	 * indique s'il s'agit d'une session de maintance ou une session standard
	 */
	private boolean maintenance = false;
/**
 * page courant en cours de traitement 
 */
	private String pageName;
	/**
	 * indique s'il s'agit d'une session de maintance ou une session standard
	 * @return
	 */
	public boolean isMaintenance() {
		return maintenance;
	}

	/**
	 * Indique si le mode maintenance est active
	 * @param b
	 */
	public void setMaintenance(boolean b) {
		maintenance = b;
	}


	/**
	 * @param prefix
	 */
	public void setPrefix(String newPrefix) {
		prefix = newPrefix; 
		
	}

	/**
	 * @return
	 */
	public String getPrefix() {
		return prefix;
	}


	/**
	 * @return
	 */
	public String getSessionId() {
		return sessionId;
	}

	/**
	 * @param string
	 */
	public void setSessionId(String string) {
		sessionId = string;
	}

	/**
	 * @return
	 */
	public PowerBuilderConnection getCurrentConnection() {
		return currentConnection;
	}

	/**
	 * @param connection
	 */
	public void setCurrentConnection(PowerBuilderConnection connection) {
		currentConnection = connection;
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
	public void setCurrentServer(PBServer server) {
		currentServer = server;
	}

	public String getPageName() {
		return pageName;
	}

	public void setPageName(String pageName) {
		this.pageName = pageName;
	}

}
