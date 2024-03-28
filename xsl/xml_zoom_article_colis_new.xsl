<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
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
				<xsl:variable name="docu" select="'0'" />
				<!-- y-a t'il présence d'une documentation pdf ? (balise facultative) -->
				<div class="desBoutons" nowrap='nowrap'>
					<xsl:for-each select="doc_article">
							<a id="geoDocumentationComplete" target="geoIframe">
								<xsl:attribute name="onclick">geoAfficheMessage();geoPrepareIframe('geoIframe');
								</xsl:attribute>					
						    <xsl:attribute name="href">img/<xsl:value-of select="@art_ref"/>.pdf</xsl:attribute>
							&gt;&gt; Documentation complète &lt;&lt;
						   </a>
							<xsl:variable name="docu" select="'1'" />
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
							<td>
								<xsl:value-of select="var_code"/>
							</td>
							<td>
								<xsl:value-of select="var_desc"/>
							</td>
							<td>
								<xsl:value-of select="var_desc"/>
							</td>
						</tr>
						<tr class="myrowsmall">
							<td>origine</td>
							<td>
								<xsl:value-of select="ori_code"/>
							</td>
							<td>
								<xsl:value-of select="ori_desc"/>
							</td>
							<td>
								<xsl:value-of select="ori_libvte"/>
							</td>
						</tr>
						<tr class="myrowsmall">
							<td>calibre unifié</td>
							<td>
								<xsl:value-of select="cun_code"/>
							</td>
							<td>
								<xsl:value-of select="cun_desc"/>
							</td>
							<td></td>
						</tr>
						<tr class="myrowsmall">
							<td>calibre fournisseur</td>
							<td>
								<xsl:value-of select="caf_code"/>
							</td>
							<td>
								<xsl:value-of select="caf_desc"/>
							</td>
							<td></td>
						</tr>
						<tr class="myrowsmall">
							<td>calibre marquage</td>
							<td>
								<xsl:value-of select="cam_code"/>
							</td>
							<td>
								<xsl:value-of select="cam_desc"/>
							</td>
							<td>
								<xsl:value-of select="cam_desc"/>
							</td>
						</tr>
						<tr class="myrowsmall">
							<td>catégorie</td>
							<td>
								<xsl:value-of select="cat_code"/>
							</td>
							<td>
								<xsl:value-of select="cat_desc"/>
							</td>
							<td>
								<xsl:value-of select="cat_libvte"/>
							</td>
						</tr>
						<xsl:if test="clr_code!=''">
							<tr class="myrowsmall">
								<td>coloration</td>
								<td>
									<xsl:value-of select="clr_code"/>
								</td>
								<td>
									<xsl:value-of select="clr_desc"/>
								</td>
								<td>
									<xsl:value-of select="clr_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="suc_code!=''">
							<tr class="myrowsmall">
								<td>sucre</td>
								<td>
									<xsl:value-of select="suc_code"/>
								</td>
								<td>
									<xsl:value-of select="suc_desc"/>
								</td>
								<td>
									<xsl:value-of select="suc_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="pen_code!=''">
							<tr class="myrowsmall">
								<td>pénétro</td>
								<td>
									<xsl:value-of select="pen_code"/>
								</td>
								<td>
									<xsl:value-of select="pen_desc"/>
								</td>
								<td>
									<xsl:value-of select="pen_libvte"/>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="etf_code!=''">
						<xsl:variable name="fichier_image">../img/ETIFRU_<xsl:value-of select="esp_code"/>_<xsl:value-of select="etf_code"/>.jpg</xsl:variable>
						<xsl:variable name="test_fichier">boolean(document('<xsl:value-of select="$fichier_image"/>'))</xsl:variable>
						<tr class="myrowsmall">
						<xsl:choose>
							<xsl:when test="docu='0'">
									<td><a href="#">
										<xsl:attribute name="onclick">geoRequete('PBServlet?httpPBCommand=img_etifru&amp;ref=<xsl:value-of select="art_ref"/>')
										</xsl:attribute>
										stickeur
										</a>
									</td>
							</xsl:when>
							<xsl:otherwise>
								<td>stickeur</td>
							</xsl:otherwise>
						</xsl:choose>
							<td><xsl:value-of select="etf_code"/></td>
							<td><xsl:value-of select="etf_desc"/></td>
							<td><xsl:value-of select="etf_libvte"/></td>
						</tr>
						</xsl:if>
						<xsl:if test="maq_code!=''">
							<tr class="myrowsmall">
								<td>marque</td>
								<td>
									<xsl:value-of select="maq_code"/>
								</td>
								<td>
									<xsl:value-of select="maq_desc"/>
								</td>
								<td>
									<xsl:value-of select="maq_libvte"/>
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
						<xsl:if test="etc_code!=''">
						<tr class="myrowsmall">
						<xsl:choose>
							<xsl:when test="docu='0'">
								<td><a href="#">
										<xsl:attribute name="onclick">geoRequete('PBServlet?httpPBCommand=img_eticol&amp;ref=<xsl:value-of select="art_ref"/>')
										</xsl:attribute>
										étiquette client
									</a>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>étiquette client</td>
							</xsl:otherwise>
						</xsl:choose>
								<td><xsl:value-of select="etc_code"/>
								</td>
								<td>
									<xsl:value-of select="etc_desc"/>
								</td>
								<td>
									<xsl:value-of select="etc_libvte"/>
								</td>
							</tr>
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
						<xsl:if test="etv_code!=''">
							<tr class="myrowsmall">
						<xsl:choose>
							<xsl:when test="docu='0'">
								<td><a href="#">
									<xsl:attribute name="onclick">geoRequete('PBServlet?httpPBCommand=img_etievt&amp;ref=<xsl:value-of select="art_ref"/>')
									</xsl:attribute>
									étiquette événementielle
									</a>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>étiquette événementielle</td>
							</xsl:otherwise>
						</xsl:choose>
								<td><xsl:value-of select="etv_code"/>
								</td>
								<td>
									<xsl:value-of select="etv_desc"/>
								</td>
								<td>
									<xsl:value-of select="etv_libvte"/>
								</td>
							</tr>
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
						<xsl:if test="etp_code!=''">
							<tr class="myrowsmall">
						<xsl:choose>
							<xsl:when test="docu='0'">
								<td><a href="#">
									<xsl:attribute name="onclick">geoRequete('PBServlet?httpPBCommand=img_etipmb&amp;ref=<xsl:value-of select="art_ref"/>')
									</xsl:attribute>										
									étiquette UC</a>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td>étiquette UC</td>
							</xsl:otherwise>
						</xsl:choose>
								<td><xsl:value-of select="etp_code"/>
								</td>
								<td>
									<xsl:value-of select="etp_desc"/>
								</td>
								<td>
									<xsl:value-of select="etp_libvte"/>
								</td>
							</tr>
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
								<!--								<xsl:value-of select="col_mod_user"/>
								<xsl:text> </xsl:text> -->
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
</xsl:stylesheet>