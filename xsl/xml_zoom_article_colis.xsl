<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xalan="http://xml.apache.org/xalan"  xmlns:bwtool="xalan://fr.bluewhale.xsltool.FileTool">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<!--  paramètres passés à la feuille de style : url des serveurs http de documents et d'images-->
	<xsl:param name="urldocserver" />
	<xsl:param name="urlimgserver" />
	<xsl:param name="urlfacserver" />
	<xsl:variable name="urlimglocal">http://maddog2/geo_imgweb/</xsl:variable>

	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
				<xsl:text>&#xA;</xsl:text>
				<div   style="visibility:hidden" id="bulle">
					<xsl:text>&#xA;</xsl:text>
				</div>
				<!-- y-a t'il présence d'une documentation pdf ? (balise facultative) -->
				<div class="desBoutons" nowrap='nowrap'>
					<xsl:for-each select="doc_article">
							<a id="geoDocumentationComplete" target="geoIframe">
								<xsl:attribute name="onclick">geoPrepareIframe('geoIframe',false);
								</xsl:attribute>					
						    <xsl:attribute name="href"><xsl:value-of select="$urlimgserver"/>/<xsl:value-of select="@art_ref"/>.pdf</xsl:attribute>
							&gt;&gt; Documentation complète &lt;&lt;
						   </a>
					</xsl:for-each>
				</div>
				
				<xsl:for-each select="lignes/detail">
					<table  cellspacing="5" style="border:1px solid gray; empty-cells:show">
						<tr class="mytitcol">
							<td>ref article</td>
							<td>espèce</td>
							<td>description brève</td>
							<td>consigné</td>
							<td>pré-pesé</td>
							<td>MDD</td>
							<td>modifié le</td>
							<td>OK ?</td>
						</tr>
						<tr class="myrowsmall">
							<td class="mytitcol">
								<xsl:value-of select="art_ref"/>
							</td>
							<td>
								<xsl:value-of select="esp_code"/>
							</td>
							<td>
								<xsl:value-of select="art_alpha"/>
							</td>
							<td STYLE="text-align:center">
								<xsl:value-of select="emb_consigne"/>
							</td>
							<td STYLE="text-align:center">
								<xsl:value-of select="col_prepese"/>
							</td>
							<td STYLE="text-align:center">
								<xsl:value-of select="mdd"/>
							</td>
							<td>
								<xsl:value-of select="mod_date"/>
							</td>
							<td STYLE="text-align:center">
								<xsl:value-of select="valide"/>
							</td>
						</tr>
					</table>
					<table cellspacing="5" style="border:1px solid gray; empty-cells:show">
						<tr class="mytitcol">
							<td>caractéristique</td>
							<td>code</td>
							<td>description technique</td>
							<td>description client</td>
						</tr>
						<tr class="myrowsmall">
							<td>variété</td>
							<td><xsl:value-of select="var_code"/></td>
							<td><xsl:value-of select="var_desc"/></td>
							<td><xsl:value-of select="var_desc"/></td>
						</tr>
						<tr class="myrowsmall">
							<td>type variété</td>
							<td><xsl:value-of select="typ_code"/></td>
							<td><xsl:value-of select="typ_desc"/></td>
						</tr>
						<tr class="myrowsmall">
							<td>mode de culture</td>
							<td><xsl:value-of select="mode_culture"/></td>
							<td><xsl:value-of select="mode_culture_desc"/></td>
						</tr>
						<tr class="myrowsmall">
							<td>origine</td>
							<td><xsl:value-of select="ori_code"/></td>
							<td><xsl:value-of select="ori_desc"/></td>
							<td><xsl:value-of select="ori_libvte"/></td>
						</tr>
						<tr class="myrowsmall">
							<td>calibre unifié</td>
							<td><xsl:value-of select="cun_code"/></td>
							<td><xsl:value-of select="cun_desc"/></td>
							<td></td>
						</tr>
						<tr class="myrowsmall">
							<td>calibre marquage</td>
							<td><xsl:value-of select="cam_code"/></td>
							<td><xsl:value-of select="cam_desc"/></td>
							<td><xsl:value-of select="cam_desc"/></td>
						</tr>
						<tr class="myrowsmall">
							<td>catégorie</td>
							<td><xsl:value-of select="cat_code"/></td>
							<td><xsl:value-of select="cat_desc"/></td>
							<td><xsl:value-of select="cat_libvte"/></td>
						</tr>
						<xsl:if test="clr_code!=''">
							<tr class="myrowsmall">
								<td>coloration</td>
								<td><xsl:value-of select="clr_code"/></td>
								<td><xsl:value-of select="clr_desc"/></td>
								<td><xsl:value-of select="clr_libvte"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="suc_code!=''">
							<tr class="myrowsmall">
								<td>sucre</td>
								<td><xsl:value-of select="suc_code"/></td>
								<td><xsl:value-of select="suc_desc"/></td>
								<td><xsl:value-of select="suc_libvte"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="pen_code!=''">
							<tr class="myrowsmall">
								<td>pénétro</td>
								<td><xsl:value-of select="pen_code"/></td>
								<td><xsl:value-of select="pen_desc"/></td>
								<td><xsl:value-of select="pen_libvte"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="etf_code!='' and etf_code!='-'">
							<xsl:call-template name="test_fichier">
								<xsl:with-param name="location">ETIFRU_<xsl:value-of select="esp_code"/>_<xsl:value-of select="etf_code"/></xsl:with-param>
								<xsl:with-param name="titre">stickeur</xsl:with-param>
								<xsl:with-param name="code" select="etf_code"/>
								<xsl:with-param name="desc" select="etf_desc"/>
								<xsl:with-param name="libvte" select="etf_libvte"/>
							</xsl:call-template>

							<xsl:if test="plu_code!=''">
							<tr class="myrowsmall">
								<td>PLU</td>
								<td><xsl:value-of select="plu_code"/></td>
								
							</tr>
						</xsl:if>
							
							
							
						</xsl:if>
						<xsl:if test="maq_code!=''">
							<tr class="myrowsmall">
								<td>marque</td>
								<td><xsl:value-of select="maq_code"/></td>
								<td><xsl:value-of select="maq_desc"/></td>
								<td><xsl:value-of select="maq_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="cir_code!=''">
							<tr class="myrowsmall">
								<td>cirage</td>
								<td>
									<xsl:value-of select="cir_code"/>
								</td>
								<td>
									<xsl:value-of select="cir_desc"/>
								</td>
								<td>
									<xsl:value-of select="cir_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="ran_code!=''">
							<tr class="myrowsmall">
								<td>rangement</td>
								<td>
									<xsl:value-of select="ran_code"/>
								</td>
								<td>
									<xsl:value-of select="ran_desc"/>
								</td>
								<td>
									<xsl:value-of select="ran_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="pde_cliart!=''">
							<tr class="myrowsmall">
								<td>ref. article client</td>
								<td></td>
								<td></td>
								<td>
									<xsl:value-of select="pde_cliart"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="ins_station!=''">
							<tr class="myrowsmall">
								<td>instructions particulières</td>
								<td></td>
								<td>
									<xsl:value-of select="ins_station"/>
								</td>
								<td></td>
							</tr>
						</xsl:if>
						<tr>
							<td class="mytitcol">code emballage</td>
							<td class="mytitcol">
								<xsl:value-of select="col_code"/>
							</td>
							<td class="myrowsmall">
								<xsl:value-of select="col_liblong"/>
							</td>
							<td class="myrowsmall">
								<xsl:value-of select="col_desc"/>
							</td>
						</tr>
						<xsl:if test="etc_code!='' and etc_code!='-'">
							<xsl:call-template name="test_fichier">
								<xsl:with-param name="location">ETICOL_<xsl:value-of select="esp_code"/>_<xsl:value-of select="etc_code"/></xsl:with-param>
								<xsl:with-param name="titre">étiquette client</xsl:with-param>
								<xsl:with-param name="code" select="etc_code"/>
								<xsl:with-param name="desc" select="etc_desc"/>
								<xsl:with-param name="libvte" select="etc_libvte"/>
							</xsl:call-template>
						</xsl:if>

						<tr class="myrowsmall">
							<td>emballeur / expéditeur</td>
							<td>
								<xsl:value-of select="ids_code"/>
							</td>
							<td>
								<xsl:value-of select="ids_desc"/>
							</td>
							<td>
								<xsl:value-of select="ids_libvte"/>
							</td>
						</tr>
						<xsl:if test="cos_code!=''">
							<tr class="myrowsmall">
								<td>conditionnement spécial</td>
								<td>
									<xsl:value-of select="cos_code"/>
								</td>
								<td>
									<xsl:value-of select="cos_desc"/>
								</td>
								<td>
									<xsl:value-of select="cos_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="alv_code!=''">
							<tr class="myrowsmall">
								<td>alvéoles</td>
								<td>
									<xsl:value-of select="alv_code"/>
								</td>
								<td>
									<xsl:value-of select="alv_desc"/>
								</td>
								<td>
									<xsl:value-of select="alv_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="etv_code!='' and etv_code!='-'">
							<xsl:call-template name="test_fichier">
								<xsl:with-param name="location">ETIEVT_<xsl:value-of select="esp_code"/>_<xsl:value-of select="etv_code"/></xsl:with-param>
								<xsl:with-param name="titre">étiquette événementielle</xsl:with-param>
								<xsl:with-param name="code" select="etv_code"/>
								<xsl:with-param name="desc" select="etv_desc"/>
								<xsl:with-param name="libvte" select="etv_libvte"/>
							</xsl:call-template>
						</xsl:if>

						<xsl:if test="pmb_code!=''">
							<tr class="myrowsmall">
								<td>Unité Consommateur (UC)</td>
								<td>
									<xsl:value-of select="pmb_code"/>
								</td>
								<td>
									<xsl:value-of select="pmb_desc"/>
								</td>
								<td>
									<xsl:value-of select="pmb_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="pmb_per_com!='0'">
							<tr class="myrowsmall">
								<td>nbre UC/colis</td>
								<td></td>
								<td>
									<xsl:value-of select="pmb_per_com"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="uc_pdnet_garanti!='0'">
							<tr class="myrowsmall">
								<td>poids mini garanti UC</td>
								<td></td>
								<td>
									<xsl:value-of select="uc_pdnet_garanti"/> Kilo
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="etp_code!='' and etp_code!='-'">
							<xsl:call-template name="test_fichier">
								<xsl:with-param name="location">ETIPMB_<xsl:value-of select="esp_code"/>_<xsl:value-of select="etp_code"/></xsl:with-param>
								<xsl:with-param name="titre">étiquette UC</xsl:with-param>
								<xsl:with-param name="code" select="etp_code"/>
								<xsl:with-param name="desc" select="etp_desc"/>
								<xsl:with-param name="libvte" select="etp_libvte"/>
							</xsl:call-template>
						</xsl:if>

						<xsl:if test="gtin_uc!=''">
							<tr class="myrowsmall">
								<td>gtin UC client</td>
								<td></td>
								<td>
									<xsl:value-of select="gtin_uc"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="gtin_uc_bw!=''">
							<tr class="myrowsmall">
								<td>gtin UC BW</td>
								<td></td>
								<td>
									<xsl:value-of select="gtin_uc_bw"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="gtin_colis!=''">
							<tr class="myrowsmall">
								<td>gtin colis client</td>
								<td></td>
								<td>
									<xsl:value-of select="gtin_colis"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="gtin_colis_bw!=''">
							<tr class="myrowsmall">
								<td>gtin colis BW</td>
								<td></td>
								<td>
									<xsl:value-of select="gtin_colis_bw"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="myrowsmall">
							<td>poids net</td>
							<td></td>
							<td>
								<xsl:value-of select="col_pdnet"/>
							</td>
						</tr>
						<tr class="myrowsmall">
							<td>tare</td>
							<td></td>
							<td>
								<xsl:value-of select="col_tare"/>
							</td>
						</tr>
						<xsl:if test="col_dim!=''">
							<tr class="myrowsmall">
								<td>dimensions</td>
								<td></td>
								<td>
									<xsl:value-of select="col_dim"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="col_xb!=''">
							<tr class="myrowsmall">
								<td>constitution palette</td>
								<td>100x120</td>
								<td>
									<xsl:value-of select="col_xh"/>
									couches de
									<xsl:value-of select="col_xb"/>
									colis
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="col_yb!=''">
							<tr class="myrowsmall">
								<td>constitution palette</td>
								<td>80x120</td>
								<td>
									<xsl:value-of select="col_yh"/>
									couches de
									<xsl:value-of select="col_yb"/>
									colis
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="col_zb!=''">
							<tr class="myrowsmall">
								<td>constitution palette</td>
								<td>60x80</td>
								<td>
									<xsl:value-of select="col_zh"/>
									couches de
									<xsl:value-of select="col_zb"/>
									colis
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="col_pump!=''">
							<tr class="myrowsmall">
								<td>PU emballage</td>
								<td></td>
								<td>
									<xsl:value-of select="col_pump"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="col_pumo!=''">
							<tr class="myrowsmall">
								<td>PU main d'oeuvre</td>
								<td></td>
								<td>
									<xsl:value-of select="col_pumo"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="gest_code!=''">
							<tr class="myrowsmall">
								<td>gestionnaire</td>
								<td>
									<xsl:value-of select="gest_code"/>
								</td>
								<td>
									<xsl:value-of select="gest_ref"/>
								</td>
							</tr>
						</xsl:if>
						<tr class="myrowsmall">
							<td>modifié</td>
							<td></td>
							<td>
								<xsl:value-of select="col_mod_date"/>
							</td>
						</tr>
						<tr class="myrowsmall">
							<td>valide ?</td>
							<td></td>
							<td>
								<xsl:value-of select="col_valide"/>
							</td>
						</tr>
					</table>
				</xsl:for-each>
		</div>
	</xsl:template>
	<!-- ci-desssous obsolete la fonction document() lit entièrement le fichier ce qui génère une erreur sur les jpg (incompatible UTF-8)
	dommage -->
	<xsl:template name="test_fichier">
		<xsl:param name="location"/>
		<xsl:param name="titre"/>
		<xsl:param name="code"/>
		<xsl:param name="desc"/>
		<xsl:param name="libvte"/>
		<xsl:variable name="fichier_pdf"><xsl:value-of select="$urlimglocal"/><xsl:value-of select="$location"/>.pdf</xsl:variable>
		<xsl:variable name="fichier_jpg"><xsl:value-of select="$urlimglocal"/><xsl:value-of select="$location"/>.jpg</xsl:variable>
		<xsl:variable name="test_pdf"><xsl:value-of select="bwtool:testURL($fichier_pdf)"></xsl:value-of></xsl:variable>
		<xsl:variable name="test_jpg"><xsl:value-of select="bwtool:testURL($fichier_jpg)"></xsl:value-of></xsl:variable>

<!--  code pour vérifier la validité des test de présence de fichier -->
		<!--  
		<div>
		PDF <xsl:value-of select="$fichier_pdf"/> <xsl:value-of select="$test_pdf"></xsl:value-of>
		JPG <xsl:value-of select="$fichier_jpg"/><xsl:value-of select="$test_jpg"></xsl:value-of>
		</div>  
		--> 
		
		<xsl:choose>
            <xsl:when test="$test_pdf='true'">
					<!-- on test en premier la présence d'un pdf (plus renseigné que le jpg) -->
				<tr class="myrowsmall">
					<td>
						<a target="geoIframe">
							<!-- <xsl:attribute name="href">PBServlet?direct=yes&amp;fichierpdf=<xsl:value-of select="$urlimgserver"/><xsl:value-of select="$location" />.pdf</xsl:attribute> -->
							<xsl:attribute name="href"><xsl:value-of select="$urlimgserver"/><xsl:value-of select="$location" />.pdf</xsl:attribute>
							<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
							<xsl:attribute name="onclick">geoPrepareIframe('geoIframe',false);</xsl:attribute>
							*<xsl:value-of select="$titre" />*
						</a>
					</td>
					<td><xsl:value-of select="$code" /></td>
					<td><xsl:value-of select="$desc" /></td>
					<td><xsl:value-of select="$libvte"/></td>
					
				</tr>
            </xsl:when>
            <xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$test_jpg='true'">
							<!-- on test ensuite la présence d'un jpg (moins renseigné que le pdf) -->
						<tr class="myrowsmall">
							<td>
								<a target="geoIframe">
									<!-- <xsl:attribute name="href">PBServlet?direct=yes&amp;fichierjpg=<xsl:value-of select="$urlimgserver"/><xsl:value-of select="$location" />.jpg</xsl:attribute> -->
									<xsl:attribute name="href"><xsl:value-of select="$urlimgserver"/><xsl:value-of select="$location" />.jpg</xsl:attribute>
									<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
									<xsl:attribute name="onclick">geoPrepareIframe('geoIframe',false);</xsl:attribute>
									*<xsl:value-of select="$titre" />*
								</a>
							</td>
							<td><xsl:value-of select="$code" /></td>
							<td><xsl:value-of select="$desc" /></td>
							<td><xsl:value-of select="$libvte"/></td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
							<!-- pas de pdf ni de jpg on se contente d'afficher sans href -->
						<tr class="myrowsmall">
						<!-- 
							<td><a target="geoIframe">
								<xsl:attribute name="href">PBServlet?direct=yes&amp;fichierpdf=<xsl:value-of select="$urlimgserver"/><xsl:value-of select="$location" />.pdf</xsl:attribute>
								<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
								<xsl:attribute name="onclick">
									geoPrepareIframe('geoIframe',false);
								</xsl:attribute>
								*<xsl:value-of select="$titre" />*
							</a></td>
						-->
							<td><xsl:value-of select="$titre"/></td>
							<td><xsl:value-of select="$code"/></td>
							<td><xsl:value-of select="$desc"/></td>
							<td><xsl:value-of select="$libvte"/></td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
</xsl:stylesheet>