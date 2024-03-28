/*
 * Nom: PowerBuilderResult.java
 * Package: fr.bluewhale.proxypb.session
 * Date: 17 juin 2004
 * Auteur: Administrateur
 */
package fr.bluewhale.session;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.util.StringTokenizer;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
//Java
import java.io.File;
import java.io.OutputStream;

//JAXP
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Source;
import javax.xml.transform.Result;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.sax.SAXResult;
import org.apache.fop.apps.*;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import fr.bluewhale.commun.util.FOTransformer;
import fr.bluewhale.entity.DocumentRoutage;

/**
 * @author Administrateur
 *
 * Lancement des transformations HTML ou PDF
 */
/**
 * Description : ... Branche $Name:  $. Date de création : 17 juin 2004
 * @author Administrateur
 * @version $Revision: 1.1 $
 *
 */
public class PowerBuilderResult {
	/**
	 * Instance du Logger de log4j pour cette classe
	 */
	protected static Logger logger = Logger.getLogger(PowerBuilderResult.class);

	/**
	 * @param data
	 */
	public PowerBuilderResult(byte[] data) {			
		setFlux(data);
		setType(ProxyPbConstants.BLOB);
	}
	
	/** Constructeur dans le cas d'un flux xml
	 * 10 premiers octets : longueur totale de ce qui suit ces 10 octets
	 * octets 11 et 12 : longueur du nom de la feuille xsl
	 * octets 13 et suivants : nom de la feuille xsl
	 * octets suivant le nom de la feuille xsl : le flux xml
	 * @param data
	 * 
	 */
	public PowerBuilderResult(byte[]data, char type) {
		setType(type);
		if(type == ProxyPbConstants.XMLFOFLUX) {
			// le flux contient l'équivalent d'un fichier XML
			// qui sera analysé ensuite
			setFlux(data);	
		} else {
		/* le flux contient le nom d'une feuille XSL */
		/* mise a jour du nom de page correspondant a la feuille xsl */
		/* la longueur du nom se trouve dans les octets 0 et 1 */
		String lenXslName = new String(data,0,2);
		int lenXslNameInt = Integer.parseInt(lenXslName);
		
		/* lecture du nom de la feuille dans les octets 2 à n */
		String xslSheet = new String(data,2,lenXslNameInt);
		xslSheet = xslSheet + ".xsl";
		
		setPageName(xslSheet);
		
		/* mise a jour du flux avec la partie contenant le flux xml */
		int offsetFlux = 2 + lenXslNameInt;
		int longueurFlux = data.length - (offsetFlux);
		byte [] localFlux = new byte[longueurFlux];
		
		/* copie du xml */
		System.arraycopy(data, offsetFlux, localFlux, 0, longueurFlux);
		
		setFlux(localFlux);
		}
	}

	/**
	 * @param typeOfPage
	 * @param pageName
	 */
	public PowerBuilderResult(char newTypeOfPage, String newPageName) {
		
		setType(newTypeOfPage);
		setPageName(newPageName);
		flux=null;
	}
	
	public PowerBuilderResult(String fileNames,char type) {
		/* pageName will contain a list of file names for further transformation */
		setPageName(fileNames);
		setType(type);
	}

	/**
	 * type du resultat 1 = html 2 = pdf 3 = doc 4 = jsp
	 */
	private char type ; 
	/**
	 * tableau pour recevoir un resultat sous forme de char
	 */
	private char [] data ;
	/**
	 * tableau d'octet pour recevoir un flux
	 */
	private byte [] flux ;
	/**
	 * nom de la page correspondant au resultat
	 */
	private String pageName;

	/**
	 * @return
	 */
	public char[] getData() {
		return data;
	}

	/**
	 * @return
	 */
	public String getPageName() {
		return pageName;
	}

	/**
	 * @return
	 */
	public char getType() {
		return type;
	}

	/**
	 * @param cs
	 */
	public void setData(char[] cs) {
		data = cs;
	}

	/**
	 * @param string
	 */
	public void setPageName(String string) {
		pageName = string;
	}

	/**
	 * @param c
	 */
	public void setType(char c) {
		type = c;
	}

	/**
	 * @return
	 */
	public boolean isHtml() {
		return (getType() == ProxyPbConstants.TYPE_HTML);
	}
	/**
	 * @return
	 */
	public boolean isJsp() {
		return (getType() == ProxyPbConstants.TYPE_JSP);
	}
	/**
	 * @return
	 */
	public boolean isStream() {
		return (getType() == ProxyPbConstants.BLOB);
	}
	/**
	 * @return
	 */
	public boolean isXmlXslOut() {
		return (getType() == ProxyPbConstants.TYPE_XML_XSL_OUT || getType() == ProxyPbConstants.XML_XSL_OUT);
	}
	public boolean isDownload() {
		
		return (getType() == ProxyPbConstants.DOWNLOAD);
	}
	
	/**
	 * @return
	 */
	public boolean isXmlFo() {
		return (getType() == ProxyPbConstants.XMLFO);
	}
	/**
	 * @return
	 */
	public boolean isMultiXmlFo() {
		return (getType() == ProxyPbConstants.MULTIXMLFO);
	}
	/**
	 * @return
	 */
	public boolean isFlux() {
		return (flux != null);
	}

	/**
	 * @return
	 */
	public byte[] getFlux() {
		return flux;
	}

	/**
	 * @param bs
	 */
	public void setFlux(byte[] bs) {
		flux = bs;
	}

	/**
	 * @return
	 */
	public boolean isPdf() {
		return (getType() == ProxyPbConstants.TYPE_PDF);
	}
	/**
	 * @return
	 */
	public boolean isBw() {
		return (getType() == ProxyPbConstants.TYPE_BW);
	}

	public boolean isXml() {
		return (getType() == ProxyPbConstants.TYPE_XML);
	}

	public boolean isXmlFoFlux() {
		return (getType() == ProxyPbConstants.XMLFOFLUX);
	}

	/****************************************  TRANSFORMATIONS HTML ******************************************/

	/** tranformation xml xsl utilisant des fichiers
	 * le nom de la feuille de style xsl et de la page html resultat sont déduit du nom du fichier xml
	 * @param prefix
	 */
	public void transform(String prefix) {
		
		TransformerFactory tFactory = TransformerFactory.newInstance();

		try {
			// determine the xsl file name and the html file name from the xml file name
			String xslFileName = Tools.extractFileName(this.getPageName());
			
			//
			xslFileName = Tools.extractName(xslFileName, '_') + ".xsl";
			String htmlFileName = Tools.removeExtension(this.getPageName()) + ".html";
			
			Transformer transformer  = tFactory.newTransformer(new StreamSource(prefix + "/xsl/" + xslFileName));
			transformer.setParameter("urldocserver", ResourceProxy.getBusinessProperty("urldocserver"));
			transformer.setParameter("urlfacserver", ResourceProxy.getBusinessProperty("urlfacserver"));
			transformer.setParameter("urlimgserver", ResourceProxy.getBusinessProperty("urlimgserver"));


			FileOutputStream outPutTarget = new FileOutputStream(prefix + htmlFileName); 
			transformer.transform(new StreamSource(prefix + this.getPageName()),
					              new StreamResult(outPutTarget));
			outPutTarget.close();

			// on met a jour le nom de la page de resultat
			this.setPageName(htmlFileName);
			
			logger.info("Transformation FICHIER XML + XSL OK : " + prefix + "/xsl/" + xslFileName);
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			System.out.println("File not found");
			e.printStackTrace();
		} catch (TransformerException e) {
			System.out.println("Error during transformation");
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	/** tranformation xml xsl utilisant un fichier xsl
	 * et un flux xml
	 * le html  ou xml résultant est aussi un flux de bytes
	 * @param prefix
	 * @return type du flux xml ou html
	 */		
		public String  transformFlux(String prefix) {
			String typeFlux ="";
			
			TransformerFactory tFactory = TransformerFactory.newInstance();
			try {
				// pageName contient directement le nom de la feuille xsl
				String xslFileName = this.getPageName();
				
				// si la feuille de style est valide (nom ne contient pas "none" 
				// on opère la transformation du flux XML
				// sinon on laisse le flux XML tel qu'il est
				if (xslFileName.indexOf("none") == -1) {
					Transformer transformer  = tFactory.newTransformer(new StreamSource(prefix + "/xsl/" + xslFileName));
					transformer.setParameter("urldocserver", ResourceProxy.getBusinessProperty("urldocserver"));
					transformer.setParameter("urlfacserver", ResourceProxy.getBusinessProperty("urlfacserver"));
					transformer.setParameter("urlimgserver", ResourceProxy.getBusinessProperty("urlimgserver"));
					ByteArrayOutputStream output = new ByteArrayOutputStream();
					transformer.transform(new StreamSource(new ByteArrayInputStream(this.getFlux())),
							              new StreamResult(output));

					// on met à jour le flux en sortie
					this.setFlux(output.toByteArray());
					
					// on met à jour le flux en sortie
					/* le type de flux est normalement determiné par la feuille de style */
					/* mais pour certain browser, pour les retours AJAX, il est nécessaire de préciser le type de flux dans */
					/* l'entete de la reponse : on est donc obligé de distinguer ici les feuilles de style faites pour donner du HTML */
					/* et celles faites pour donner du XML */
					/* la distinction se fait grace à une convention de nommage des feuilles de style */
					 /* si le nom de la feuille de style contient xmlx alors le flux est de type XML sinon c'est du HTML*/
					if (xslFileName.indexOf("xmlx") == -1 ) {
						typeFlux = "html";
					} else {
						typeFlux = "xml";
					}
					
					
					logger.info("Transformation Flux XML + XSL OK " + xslFileName + " typeFlux= " + typeFlux+ "\n");
					logger.info("=====================================================================================\n");

					logger.debug("Transformation Flux XML + XSL output =  " + "\n" + output.toString());

					}
				else {
					System.out.println("Flux XML non transformé OK " + xslFileName );
					typeFlux = "xml";
				}
				

			} catch (TransformerConfigurationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}  catch (TransformerException e) {
				System.out.println("Error during transformation");
				e.printStackTrace();
			}
		return typeFlux;
	}

	/** Tranformation XML vers HTML
	 * L'attribut pageName contient le nom du fichier xml,  le nom de la feuille xsl à utiliser, 
	 * et le nom du fichier html résultant séparés par une virgule
	 * 
	 * @param prefix
	 */
	public int transformXmlXslOut(String prefix) {
		TransformerFactory tFactory = TransformerFactory.newInstance();
		try {
			// determine the xsl file name and the html file name from the xml file name
			String fileNames = this.getPageName();
			
			/* les noms des fichiers sont separes par des virgules */
			StringTokenizer token = new StringTokenizer(fileNames,",");
			String xmlFileName = token.nextToken();
			String xslFileName = token.nextToken();
			String outputFileName = "/tmpxml/" + token.nextToken();
			
			//xmlFileName = Tools.extractFileName(xmlFileName);
			
			Transformer transformer  = tFactory.newTransformer(new StreamSource(prefix + "/xsl/" + xslFileName));
			transformer.setParameter("urldocserver", ResourceProxy.getBusinessProperty("urldocserver"));
			transformer.setParameter("urlfacserver", ResourceProxy.getBusinessProperty("urlfacserver"));
			transformer.setParameter("urlimgserver", ResourceProxy.getBusinessProperty("urlimgserver"));
			FileOutputStream outPutTarget = new FileOutputStream(prefix +  outputFileName); 
			transformer.transform(new StreamSource(prefix + xmlFileName),
					              new StreamResult(outPutTarget));
			outPutTarget.close();

			// on met a jour le nom de la page de resultat
			this.setPageName(outputFileName);
			
			logger.info("Transformation XML + XSL OK : " + xmlFileName + "+" + xslFileName + " " + this.getPageName());
			logger.debug("Transformation Flux XML + XSL output =  " + "\n" + outPutTarget.toString());
			
			/* patch : suppression de la premiere ligne du fichier qui est vide */
			/*
			try {
				 
				File file = new File(prefix + this.getPageName());
				RandomAccessFile tools = new RandomAccessFile(file, "rw"); // read-write
				tools.readLine(); // goto second line
				long length = tools.length() - tools.getFilePointer(); // except first line
				byte[] nexts = new byte[(int) length];
				tools.readFully(nexts); // read the others
				tools.seek(0); // return to start
				tools.write(nexts); // insert just 1 line before
				tools.setLength(nexts.length); // truncate the last duplicated line
				tools.close(); // flush all
	 
			} catch (Exception error) {
				error.printStackTrace();
			}
			*/


		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return(-1);
		} catch (FileNotFoundException e) {
			System.out.println("File not found");
			e.printStackTrace();
			return(-1);
		} catch (TransformerException e) {
			System.out.println("Error during transformation");
			e.printStackTrace();
			return(-1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return(0);
		
	}
	
	
	/****************************************  TRANSFORMATIONS PDF ******************************************/
	
	
	/**
	 * 
	 * Transformation XSLFO via l'utilitaire du DOC SERVEUR, à partir d'un fichier xml, et d'une feuille de style xsl dont le
	 * nom est déduit du nom du fichier XML
	 * transformation vers un fichier PDF
	 * le fichier xml est dy type debutdunomdufichier_DDDDDD.xml; =>
	 * la feuille de style est : debutdunomdufichier.xsl
	 * @param prefix
	 */

	public void transformXSL_FO_PDF(String prefix) {

	fr.bluewhale.commun.util.FOTransformer foTransformer = new FOTransformer();
	logger.info("FOTransformer OK ");
	File xmlFile = new File(prefix + this.getPageName());
	DocumentRoutage docRoutage = new DocumentRoutage(xmlFile);
	logger.info("docRoutage OK ");
	String pdfFileName = null ;
	String rootDirectory = ResourceProxy.getBusinessProperty("rootdirectory");
	String xslfoDirectory = ResourceProxy.getBusinessProperty("xslfodirectory");
	String pdfDirectory = ResourceProxy.getBusinessProperty("pdfdirectory");
	String fopconfigfile = ResourceProxy.getBusinessProperty("fopconfigfile");
	try {
		logger.info("root directory : " + rootDirectory);
		
		if(docRoutage.getMultipledocuments().size() == 1) {
		pdfFileName = foTransformer.transformXSL_FO_PDF(rootDirectory,fopconfigfile,pdfDirectory,xslfoDirectory,docRoutage.getDocument());
		} else {
		pdfFileName = foTransformer.transformXSL_FO_PDF_multiple(rootDirectory, fopconfigfile, pdfDirectory, xslfoDirectory, xmlFile, docRoutage);
		}
	} catch (FOPException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (TransformerException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	// on met a jour le nom de la page de resultat
	this.setPageName("/tmppdf/" +  pdfFileName);
	
	}
	/**
	 * 
	 * Transformation XSLFO via l'utilitaire du DOC SERVEUR, à partir de plusieurs  fichiers xml, et d'une feuille de style xsl dont le
	 * nom donné dans chaque fichier xml 
	 * transformation vers plusieurs fichiers PDF qui sont ensuite concaténés
	 * les fichier xmls sont  dy type docs_nomdufichier_DDDDDD.xml; =>
	 * @param prefix
	 */
	public void transformXSL_FO_PDF_multiple(String prefix) {
		fr.bluewhale.commun.util.FOTransformer foTransformer = new FOTransformer();
		logger.info("FOTransformer OK ");
		File xmlFile = new File(prefix + this.getPageName());
		String xmlDirectory = ResourceProxy.getBusinessProperty("xmldirectory");
		DocumentRoutage docRoutage = new DocumentRoutage(xmlFile,xmlDirectory);
		logger.info("docRoutage multiple OK ");
		String pdfFileName = null ;
		String rootDirectory = ResourceProxy.getBusinessProperty("rootdirectory");
		String xslfoDirectory = ResourceProxy.getBusinessProperty("xslfodirectory");
		String pdfDirectory = ResourceProxy.getBusinessProperty("pdfdirectory");
		String fopconfigfile = ResourceProxy.getBusinessProperty("fopconfigfile");
		try {
			logger.info("root directory : " + rootDirectory);
			pdfFileName = foTransformer.transformXSL_FO_PDF_multiple(rootDirectory, fopconfigfile, pdfDirectory, xslfoDirectory, xmlFile, docRoutage);
		} catch (FOPException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (TransformerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// on met a jour le nom de la page de resultat
		this.setPageName("/tmppdf/" +  pdfFileName);		
		
	}	
	/**
	 * Transformation XSLFO, via l'utilitaire du DOC SERVEUR à partir d'un fichier xml, et d'une feuille de style xsl dont le
	 * nom est déduit du nom du fichier XML
	 * le fichier xml est dy type debutdunomdufichier_DDDDDD.xml; =>
	 * la feuille de style est : debutdunomdufichier.xsl
	 * transformation vers un flux directement renvoyé vers le client
	 * @param prefix
	 */

	public void transformXSL_FO_PDF_Flux(String prefix) {
		
	ByteArrayInputStream inputStream = new ByteArrayInputStream(this.getFlux());

	fr.bluewhale.commun.util.FOTransformer foTransformer = new FOTransformer();
	DocumentRoutage docRoutage = new DocumentRoutage(inputStream);
	String rootDirectory = ResourceProxy.getBusinessProperty("rootdirectory");
	String xslfoDirectory = ResourceProxy.getBusinessProperty("xslfodirectory");
	
	String fopfileconfig = ResourceProxy.getBusinessProperty("fopconfigfile");
	ByteArrayOutputStream output = null ;
	try {
		output = foTransformer.transformXSL_FO_PDF_Flux(rootDirectory,fopfileconfig,xslfoDirectory,
				inputStream, docRoutage);
	} catch (FOPException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (TransformerException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	// on met à jour le flux en sortie
	this.setFlux(output.toByteArray());
	
	}
	
	/** Transformation XSLFO à partir d'un flux XML reçu par socket
	 * le nom de la feuille de style a été lu dans le début du flux, le reste du flux étant
	 * les données XML à transformer
	 * le nom du fichier pdf de résultat est construit à partir du nom de la feuille de style
	 * @param prefix
	 */
	/*
	public void transformFluxXSL_FO_PDF(String prefix) {
		try {
			
			// pageName contient directement le nom de la feuille xsl
			String xslFileName = this.getPageName();
			
			String pdfFileName = Tools.removeExtension(xslFileName) + ".pdf";
			//
			 xslFileName = prefix + "/xsl/" + xslFileName;
			 String fullpdfFileName = prefix + "/tmppdf/" + pdfFileName;
			
            // configure fopFactory as desired pour avoir notammenet les bonnes polices de caractères
            FopFactory fopFactory = FopFactory.newInstance();
            try {
				fopFactory.setUserConfig(prefix + "/Config/fopfontconfig.xml");
			} catch (SAXException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}

            FOUserAgent foUserAgent = fopFactory.newFOUserAgent();
            // configure foUserAgent as desired

            
            // Setup output
            OutputStream out = new java.io.FileOutputStream(fullpdfFileName);
            out = new java.io.BufferedOutputStream(out);

            try {
                // Construct fop with desired output format
                Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, foUserAgent, out);
    
                // Setup XSLT
                TransformerFactory factory = TransformerFactory.newInstance();
                Transformer transformer = factory.newTransformer(new StreamSource(xslFileName));
                
                // Set the value of a <param> in the stylesheet
                transformer.setParameter("versionParam", "2.0");
            
                // flux xml devant etre tansformé : 
                Source src = new StreamSource(new ByteArrayInputStream(this.getFlux()));
            
                // Resulting SAX events (the generated FO) must be piped through to FOP
                Result res = new SAXResult(fop.getDefaultHandler());
    
                // Start XSLT transformation and FOP processing
                transformer.transform(src, res);
            } catch (FOPException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
                out.close();
            }
			

			// on met a jour le nom de la page de resultat
			this.setPageName("/tmppdf/" + pdfFileName);
			
			System.out.println("Transformation FLUX XML + XSL FO OK");
		} catch (TransformerConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			System.out.println("File not found");
			e.printStackTrace();
		} catch (TransformerException e) {
			System.out.println("Error during transformation");
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
*/


}
