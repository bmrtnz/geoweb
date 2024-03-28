/**
 *  Cette classe implemente le HttpSessionBindingListener 
 * ce qui permet de faire des traitements lorsqu'un timeout de session
 * est declenché ou lorsque la session est invalidée.
 *
 *@author     L.Malais
 *@created     Février 2004
 */
package fr.bluewhale.session;

import java.io.IOException;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

import org.apache.log4j.Logger;

/**
 * @author Administrateur
 *
 * To change the template for this generated type comment go to
 * Window>Preferences>Java>Code Generation>Code and Comments
 */
public class SessionTimer implements HttpSessionBindingListener {
	ApplicationController controller = null;
	/**
	 * Instance du Logger de log4j pour cette classe
	 */
	protected static Logger logger = Logger.getLogger(SessionTimer.class);
	/**
	 * 
	 */
	public SessionTimer(ApplicationController newController) {
		super();
		setController(newController);
	}

	/**
	 * Detection du timeout de session
	 * fermeture de la connexion courante avec le serveur
	 *
	 *@param  event  Event associated with the object
	 */
	public void valueBound(HttpSessionBindingEvent event) {

		logger.info("SessionTimer : valueBound .......");
	}

	/**
	 *  This method is called when the object SessionTimer
	 *  is bound out the session. It occurs when a timeout is sent by the
	 *  server. 
	 *  This methode is used to unbind IDL object when a user is disconnected
	 *@param  event  Event associated with the object
	 */
	public void valueUnbound(javax.servlet.http.HttpSessionBindingEvent event) {
		logger.info("Fin de session detectée.");

		// closeConnectionRequest();
		close();
	}

	/**
	 * 
	 */
	private synchronized void close() {
		try {
			controller.getSessionData().getCurrentConnection().closeConnection();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		logger.info("close socket puis  attente 1 seconde" );
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}		
	}

	/**
	 * @return
	 */
	public ApplicationController getController() {
		return controller;
	}

	/**
	 * @param controller
	 */
	public void setController(ApplicationController controller) {
		this.controller = controller;
	}



/**
 * envoi d'une requete de fermeture de connexion
 * methode synchronisée pour eviter les envois simultanés
 * avec une attente de 1 seconde
 */
private synchronized void closeConnectionRequest() {
	String powerBuilderRequest = "SessionId=" + controller.getSessionData().getSessionId();
	powerBuilderRequest = powerBuilderRequest + "&httpPBCommand=ask_close";
	
	
	int requestLength = powerBuilderRequest.length();
		
	String usefulMessageLength = ServletHelper.padd(requestLength);
		
	String message = ProxyPbConstants.BLOB + usefulMessageLength + powerBuilderRequest ;
	logger.info("closeConnectionRequest " +  message );
	// transmission de la requete courante
	controller.getSessionData().getCurrentConnection().write(message);
	
	logger.info("closeConnectionRequest attente 1 seconde" );
	try {
		Thread.sleep(1000);
	} catch (InterruptedException e) {
		e.printStackTrace();
	}

}

}
