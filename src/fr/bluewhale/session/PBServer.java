/*
 * Created on 12 août 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package fr.bluewhale.session;

import java.util.StringTokenizer;

/**
 * @author Administrateur
 *
 * Identification d'un serveur PowerBuilder
 */
public class PBServer {
	/** Extraction de l'IP et du numero de port d'un serveur
	 * depuis un token de la forme ip:port
	 * @param token
	 */
	public PBServer(String token) {
		
		StringTokenizer tokenDeuxPoints = new StringTokenizer(token,":");
		String ip = tokenDeuxPoints.nextToken();
		String port = tokenDeuxPoints.nextToken();
		setIp(ip);
		setPort(Integer.parseInt(port));	
	}


	/**
	 * adresse IP du serveur Power Builder
	 */
	private String ip ;
	/**
	 * Port d'écoute du serveur Power Builder
	 */
	private int port;
	
	/**
	 * position du serveur pour la gestion du revolving
	 */
	 int position = 1;

	/**
	 * 
	 * Initialisation du serveur avec son adresse IP 
	 * et son port d'écoute
	 * @param server
	 * @param portNumber
	 */
	public PBServer(String server, String portNumber) {
		
		setIp(server);
		setPort(Integer.parseInt(portNumber));
	}


	/**
	 * @return
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * @return
	 */
	public int getPort() {
		return port;
	}

	/**
	 * @param string
	 */
	public void setIp(String string) {
		ip = string;
	}


	/**
	 * @param i
	 */
	public void setPort(int i) {
		port = i;
	}

	/**
	 * @return
	 */
	public int getPosition() {
		return position;
	}

	/**
	 * @param i
	 */
	public void setPosition(int i) {
		position = i;
	}

}
