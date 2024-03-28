<?xml version="1.0" encoding="UTF-8"?>
<!-- picklist standard -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<!--  on declare une target vide pour le milieu -->
			<!--  la zone sera donc vidée à l'affichage de la picklist -->
			<div class="geoTarget" id="geoColonneMilieu">
			</div>
			<xsl:apply-templates />
			<div id="geoBack" class="geoTarget">
				<a onclick="geoRestoreHistory()" href="#" >Retour</a>
			</div>
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
	<div style="visibility:hidden" id="bulle">
		<xsl:text>&#xA;</xsl:text>
	</div>
	<xsl:apply-templates select="menu" />
	<div id="contenuPickListe">
		<xsl:for-each select="header/titre">
			<div class="mytitcol">
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>
		<xsl:for-each select="boutons/bouton">
			<a>
				<!-- rajout du / devant l'url -->
				<xsl:attribute name="href">/<xsl:value-of
					select="@url" /></xsl:attribute>
				<img style="cursor:hand" border="0">
					<xsl:attribute name="src"> images/<xsl:value-of
						select="@lib" />-on.gif </xsl:attribute>
					<xsl:attribute name="onmouseover"> this.src='images/<xsl:value-of
						select="@lib" />.gif';window.status='';return true </xsl:attribute>
					<xsl:attribute name="onmouseout"> this.src='images/<xsl:value-of
						select="@lib" />-on.gif' </xsl:attribute>
				</img>
			</a>
		</xsl:for-each>
		<table cellspacing="0" cellpadding="0" border="0" bordercolor="blue">
			<xsl:for-each select="lignes/detail">
				<tr class="myrow">
					<xsl:for-each select="link">
					<td valign="top" width="10%">
				       <xsl:choose>
				          <xsl:when test="@target='pdf'">
				          <!-- si le lien fait appel à du PDF, c'est un appel direct sans appel AJAX -->
				          <!--  la target du lien doit etre l'iframe -->
								<a target="geoIframe">
								    <xsl:attribute name="href"><xsl:value-of select="@url" /></xsl:attribute>
									<xsl:attribute name="class">a_<xsl:value-of select="../statut" />
									</xsl:attribute>
									<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
									<xsl:attribute name="onclick">
									    geoPrepareIframe(geoIframe);
										hideElement(this,'<xsl:value-of select="@hide" />');
										geoUpdateContexte('<xsl:value-of select="../contexte" />');
									</xsl:attribute>
									<xsl:value-of select="@lib" />
									<xsl:text>&#x20;</xsl:text>

								</a>
				              </xsl:when>
				          <xsl:otherwise>
         					 <!--  lien à gérer par un appel AJAX sur onclick -->
									<!-- pas d'attribut target -->
										<a href="#">
											<xsl:attribute name="class">a_<xsl:value-of select="../statut" />
											</xsl:attribute>
											<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
											<xsl:attribute name="onclick">
												hideElement(this,'<xsl:value-of select="@hide" />');
												geoUpdateContexte('<xsl:value-of select="../contexte" />');
												geoRequete('<xsl:value-of select="@url" />')
											</xsl:attribute>
											<xsl:value-of select="@lib" />
											<xsl:text>&#x20;</xsl:text>
										</a>
				     		</xsl:otherwise>
				        </xsl:choose>	
					</td>		
					<td class="value">
					<xsl:value-of select="../description"/>
					</td>		
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
	</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>