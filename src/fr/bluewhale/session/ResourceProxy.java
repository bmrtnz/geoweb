package fr.bluewhale.session;

import java.util.Hashtable;
import java.util.MissingResourceException;
import java.util.ResourceBundle;


/**
 *  Classe utilitaire pour la lecture des fichiers de ressources. Les fichiers
 *  de ressources doivent etre presents dans le repertoire de demarrage du
 *  serveur d'application. Un nom de fichier de ressources est compose du
 *  prefixe Sdm + identifiant + .properties.
 *
 *@author     lmalais
 *@created    Octobre 2002
 */
public abstract class ResourceProxy {
    /**
     *  table des dictionnaires
     */
    private static Hashtable dictionaries = null;

    /**
     *  Chargement statique des dictionnaires (appel automatique àa la premiere
     *  utilisation de la classe)
     */
    static {
        load();
    }

    /**
     *  Retourne un message d'erreur du fichier ERROR_FILE_NAME
     *
     *@param  errorMessageId                identifiant du message
     *@return                               texte du message
     *@exception  MissingResourceException
     */
    public static String getErrorMessage(String errorMessageId)
        throws MissingResourceException {
        if (isValid()) {
            ResourceBundle dictionary = (ResourceBundle) dictionaries.get(ProxyPbConstants.ERROR_FILE_NAME);

            if (dictionary != null) {
                return dictionary.getString(errorMessageId);
            }
        }

        throw new MissingResourceException("Resource not found",
            "ResourceProxy", ProxyPbConstants.ERROR_FILE_NAME);
    }

    /**
     *  Effacement des dictionnaires
     */
    public static void invalidate() {
        dictionaries = null;
    }

    /**
     *  Retourne vrai si les dictionnaires sont disponibles
     *
     *@return    boolean
     */
    public static boolean isValid() {
        return dictionaries != null;
    }

    /**
     *  Chargement des fichiers de ressources
     *
     *@exception  MissingResourceException
     */
    private static void load() throws MissingResourceException {
        dictionaries = new Hashtable();

        ResourceBundle dictionary = ResourceBundle.getBundle(ProxyPbConstants.BUSINESS_FILE_NAME);

        dictionaries.put(ProxyPbConstants.BUSINESS_FILE_NAME, dictionary);
   }

    /**
     *  Rechargement des ressources
     */
    public static void reload() {
        load();
    }

    /**
     *  Recherche d'une propriete dans BUSINESS_FILE_NAME
     *
     *@param  property                      Identifiant de la propriete
     *@return                               Valeur de la propriete
     *@exception  MissingResourceException
     */
    public static String getBusinessProperty(String property)
        throws MissingResourceException {
        String file = null;

        file = ProxyPbConstants.BUSINESS_FILE_NAME;

        if (isValid()) {
            ResourceBundle dictionary = (ResourceBundle) dictionaries.get(file);

            if (dictionary != null) {
                return dictionary.getString(property);
            }
        }

        throw new MissingResourceException("Could not find resource " +
            property + " in file " + file, "ResourceProxy", file);
    }

 
    /**
     *  Recherche d'une propriete dans un fichier quelconque, généralisation de la
     *  méthode getBusinessProperty
     *
     *@param  file                          Identifiant du fichier d'origine
     *@param  property                      Identifiant de la propriete
     *@return                               Valeur de la propriete
     *@exception  MissingResourceException
     */
    public static String getProperty(String file, String property)
        throws MissingResourceException {
        if (isValid()) {
            ResourceBundle dictionary = (ResourceBundle) dictionaries.get(file);

            if (dictionary != null) {
                return dictionary.getString(property);
            } else {
                throw new MissingResourceException("Could not find resource " +
                    property + " in file " + file, "ResourceProxy", file);
            }
        } else {
            throw new MissingResourceException("Could not find file " + file,
                "ResourceProxy", file);
        }
    }
 
	/**
	 *  Recherche d'une propriete dans un dictionnaire quelconque, généralisation de la
	 *  méthode getBusinessProperty
	 *
	 *@param  file                          dictionnaire a utiliser 
	 *@param  property                      Identifiant de la propriete
	 *@return                               Valeur de la propriete
	 *@exception  MissingResourceException
	 */
	public static String getProperty(ResourceBundle dictionary, String property)
		throws MissingResourceException {
			return dictionary.getString(property);
		} 

	/**
	  *  Recherche d'une propriete dans BUSINESS_FILE_NAME
	  *
	  *@param  property                      Identifiant de la propriete
	  *@param reload rechargement du fichier
	  *@return                               Valeur de la propriete
	  *@exception  MissingResourceException
	  */
	 public static String getBusinessProperty(String property,boolean reload)
		 throws MissingResourceException {
		 String file = null;
		 ResourceBundle dictionary;

		 file = ProxyPbConstants.BUSINESS_FILE_NAME;
		 
		 // si le rechargement est demande ou n'a pas ete effectue
		 // on charge le fichier de ressources
		 if(reload || !isValid()) {
			 dictionary = ResourceBundle.getBundle(ProxyPbConstants.BUSINESS_FILE_NAME);
		 } else {
			dictionary = (ResourceBundle) dictionaries.get(file);
		 }
		if (dictionary != null) {
			return dictionary.getString(property);
		 }
		 

		 throw new MissingResourceException("Could not find resource " +
			 property + " in file " + file, "ResourceProxy", file);
	 }


}
