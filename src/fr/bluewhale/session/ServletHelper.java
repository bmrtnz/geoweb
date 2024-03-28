package fr.bluewhale.session;

import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;


/**
 *  Helper pour le management d'un session
 *
 *
 *@author     L.Malais
 *@created    Ocotobre 2002
 */
// AR 26/10/05 ajout fonction download

public class ServletHelper {
    protected static Logger logger = Logger.getLogger(ServletHelper.class);

    /**
     *  Chargement statique de la navigation (appel automatique àa la premiere
     *  utilisation de la classe)
     */
    static {
 
    }

    /**
     *  Transforms a HttpServletRequest into a Hashtable. Selects only
     *  parameters containing the descriptor delimiter.
     *  It's possible to have several values for the same parameters
     * Transforme une HttpServletRequest en une HashTable.
     * Il est possible d'avoir plusieurs valeurs pour le meme parametre
     *
     *@param  req  Description of the Parameter
     *@return      Hashtable
     */
    public static Hashtable toHashtable(HttpServletRequest req) {
        Hashtable table = new Hashtable();
        Enumeration params = req.getParameterNames();

        while (params.hasMoreElements()) {
            String paramName = (String) params.nextElement();
            String[] paramValues = req.getParameterValues(paramName);

            if (paramValues.length == 1) {
                table.put(paramName, paramValues[0]);
            } else {
                table.put(paramName, paramValues);
            }
        }
        
        
        //recupere aussi les attributs
        params = req.getAttributeNames();
	
		while (params.hasMoreElements()) {
           String paramName = (String) params.nextElement();
               
           table.put(paramName, req.getAttribute(paramName));        
         
        }
        return table;
    }
    
    

    /**
     *  Imprime tous les parametres d'une HttpRequest
     *
     *@param  req  HttpRequest , the request to print
     */
    public static void printRequest(HttpServletRequest req) {
        Enumeration params = req.getParameterNames();

	String parametersString = "";
        while (params.hasMoreElements()) {
            String paramName = (String) params.nextElement();
            String[] paramValues = req.getParameterValues(paramName);
	    
            for (int i = 0; i < paramValues.length; i++) {

				// ne pas tracer le mot de passe
//                if (paramName.indexOf("Password") != -1) {
				if (paramName.indexOf("pwd_0") != -1) {
                    // logger.debug(paramName + "=\"" + paramValues[i] + "\"");
                } else {
                    parametersString += "\n" + paramName + "=\"" + paramValues[i] + "\"";
                }
            }
        }
 //   logger.info("\n-------------------------------Print Request -----------------------------");
	logger.info (parametersString);
    }

    /**
     * Renvoie d'une jsp
     * @param servlet la servlet qui doit renvoyer la jsp
     * @param request la requette àenvoyer à la jsp
     * @param response la reponse utilisé par la jsp
     * @param jspUrl l'url de la jsp (relative par rapport à la WebApp)
     */
    public static void forwardJSP(HttpServlet servlet,
        HttpServletRequest request, HttpServletResponse response, String jspUrl) {
        try {
        	// ne pas rajouter le context dans le cas on on utilise forward ? a surveiller
        	// servlet.getServletContext().getContextPath()+
            ServletHelper.logger.info("ServletHelper:forwardJSP(jsp=" + jspUrl + ")");
            servlet.getServletContext().getRequestDispatcher(jspUrl).forward(request,
                response);
        } catch (Throwable t) {
            ServletHelper.logger.fatal("ServletHelper:forwardJSP(jsp=" +
            		servlet.getServletContext().getContextPath()+  jspUrl, t);
        }
    }

	/**
	 * Renvoie un fichier à télécharger (déclenche download dialog)
	 * @param response la reponse retourné avec la page HTML
	 * @param pageUrl l'url de la page HTML (relative par rapport à la WebApp)
	 */
	public static void forwardDownload(HttpServletResponse response, String pageUrl) {
		try {
			ServletHelper.logger.info("ServletHelper:forwardDownload(page=" +
				pageUrl + ")");
			response.setContentType("application/x-download");
			response.setHeader("Content-Disposition", "attachment; filename=" + pageUrl);
			response.sendRedirect(pageUrl);
		} catch (Throwable t) {
			ServletHelper.logger.fatal("ServletHelper:forwardownload(page=" +
				pageUrl + ")", t);
		}
	}

    /**
     * Renvoie une page HTML statique
     * @param response la reponse retourné avec la page HTML
     * @param pageUrl l'url de la page HTML (relative par rapport à la WebApp)
     */
    public static void forwardHTML(HttpServlet servlet,HttpServletResponse response, String pageUrl) {
        try {
            ServletHelper.logger.info("ServletHelper:forwardHTML(page=" +
            		servlet.getServletContext().getContextPath()+  pageUrl + ")");
            response.setContentType("text/html");
            response.sendRedirect(servlet.getServletContext().getContextPath()+  pageUrl);
        } catch (Throwable t) {
            ServletHelper.logger.fatal("ServletHelper:forwardHTML(page=" +
            		servlet.getServletContext().getContextPath()+ pageUrl + ")", t);
        }
    }

    /**
     * Renvoie une erreur HTTP (voir les constantes d'erreur dans HttpServletResponse)
     * @param response la réponse à retourner
     * @param errorCode le code d'erreur que l'on renvoie.
     */
    private static void forwardHttpError(HttpServletResponse response,
        int errorCode) {
        try {
            ServletHelper.logger.info("ServletHelper:forwardHttpError(err=" +
                errorCode + ")");
            response.sendError(errorCode,
                ResourceProxy.getErrorMessage("SDM_001"));
        } catch (Throwable t) {
            ServletHelper.logger.fatal("ServletHelper:forwardHttpError err = " +
                errorCode, t);
        }
    }

    /**
     * Renvoie un tableau de byte comme réponse (ex un fichier)
     * @param la réponse la réponse à retourner
     * @param contentType le type MIME du fichier à retounrner
     * @param dataToSend le contenu du fichier.
     * @param typeDuFlux 
     */
    public  static void forwardStream(HttpServletResponse response, byte[] dataToSend, String typeDuFlux) {
        try {
			response.setContentType("text/" + typeDuFlux);
			response.setHeader("Cache-Control", "no-cache");
			/*response.getWriter().write(
					"<root>" +
						"<target id='geoEnPied'>" +
							"<label> Hello En pied </label> " +
						"</target>" +
						" <target id='geoColonneMilieu'>" +
							"<span> Hello Milieu </span> " +
						"</target>" +
					"</root>");*/
            ServletHelper.logger.info("ServletHelper:forwardStream XML  type : text/" + typeDuFlux);

            ServletOutputStream sos = response.getOutputStream();
            sos.write(dataToSend);
            sos.close();
        } catch (Throwable t) {
            ServletHelper.logger.fatal("ServletHelper:forwardStream", t);
        }
    }



	/**
	 * @param request
	 * @param string
	 */
	public static void addErrorMessage(HttpServletRequest request, String string) {
		request.getSession().setAttribute("Message",string);
		
	}
	/**
	 * @param requestLength
	 * transformer un entier en chaine et completer avec des 0
	 * pour obtenir N caracteres
	 * @return
	 */
	public  static String padd(int value) {

		
		String valueString = new Integer(value).toString();
		
		int lenToAdd  = ProxyPbConstants.PADD_STRING.length() - valueString.length();	
		
		String result = ProxyPbConstants.PADD_STRING.substring(0,lenToAdd) + valueString ;
		
		return result;
	}


    /**
     * Renvoie un tableau de byte correspondant à un contenu de type PDF
     * @param la réponse la réponse à retourner
     * @param contentType le type MIME du fichier à retounrner
     * @param dataToSend le contenu du fichier.
     */
	public static void forwardStreamPDF(HttpServletResponse response,
			byte[] flux) {
	       try {
	            ServletHelper.logger.info("ServletHelper:forwardStreamPDF");
	            response.setContentType("application/pdf");
	            response.setContentLength(flux.length);
	            ServletHelper.logger.info("longueur de flux : " + flux.length);

	            ServletOutputStream sos = response.getOutputStream();
	            sos.write(flux);
	            sos.flush();
	            sos.close();
	        } catch (Throwable t) {
	            ServletHelper.logger.fatal("ServletHelper:forwardStream", t);
	        }
	}

    /**
     * Renvoie un tableau de byte correspondant à un contenu de type JPG
     * @param la réponse la réponse à retourner
     * @param contentType le type MIME du fichier à retounrner
     * @param dataToSend le contenu du fichier.
     */
	public static void forwardStreamIMG(HttpServletResponse response,
			byte[] flux) {
	       try {
	            ServletHelper.logger.info("ServletHelper:forwardStreamIMG");
	            response.setContentType("image/jpg");
	            response.setContentLength(flux.length);
	            ServletHelper.logger.info("longueur de flux : " + flux.length);

	            ServletOutputStream sos = response.getOutputStream();
	            sos.write(flux);
	            sos.flush();
	            sos.close();
	        } catch (Throwable t) {
	            ServletHelper.logger.fatal("ServletHelper:forwardStream", t);
	        }
	}


}
