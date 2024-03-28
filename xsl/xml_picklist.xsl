<?xml version="1.0" encoding="UTF-8"?>
<!-- picklist standard -->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:include href="composant/boutons.xsl" />
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<!--  on declare une target vide pour le milieu -->
			<!--  la zone sera donc vidée à l'affichage de la picklist -->
			<div class="geoTarget" id="geoColonneMilieu">
			</div>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>

	<div id="contenuPickListe">

		<!--  il peut y avoir des boutons en debut de liste -->
		<xsl:apply-templates select="boutons" />

		<!--  ensuite on met le titre principal  -->
		<xsl:for-each select="header/titre">
			<div class="mytitcol">
				<xsl:value-of select="." />
			</div>
		</xsl:for-each>
		
		<!--  viennent les lignes qui contiennent des détails (les liens actifs) ou des titres secondaires -->
		<xsl:apply-templates select="lignes"/>
		

		<!--  enfin on met l'image s'il y en a une -->
		<xsl:apply-templates select="image" />
	
	</div>
	
	</div>
		
	</xsl:template>
	
		<xsl:template match="lignes">

		<table cellspacing="0" cellpadding="0" border="0" bordercolor="blue" width="250">
		<xsl:apply-templates/>
		</table>
		</xsl:template>
		
		<xsl:template match="detail">
			<tr class="myrow">
				<xsl:for-each select="link">


					<xsl:choose>
						<xsl:when test="../statut_bw = 'modifie'">
							<td valign="top" width="1%">
								<img style="margin-top:0px;margin-left:0px" height="12" width="12" border="0" >
								<xsl:attribute name="src">images/error.gif</xsl:attribute>
								</img>				
							</td>
						</xsl:when>
						<xsl:otherwise>
							<td valign="top" width="1%">
							<!--  on affiche rien -->
							</td>
						</xsl:otherwise>
					</xsl:choose> 				
<!--				
		<xsl:if test="../statut_bw = 'modifie'">
				<td valign="top" width="1%">
					<img style="margin-top:0px;margin-left:0px" height="12" width="12" border="0" >
						<xsl:attribute name="src">images/error.gif</xsl:attribute>
					</img>				
				</td>
		</xsl:if>
				
		<xsl:if test="../statut_bw != 'modifie'">
				<td valign="top" width="1%">
				</td>
		</xsl:if>
-->				
				<td valign="top" width="25%">
			       <xsl:choose>
			          <xsl:when test="@target='pdf'">
			          <!-- si le lien fait appel à du PDF, c'est un appel direct sans appel AJAX -->
			          <!--  la target du lien doit etre l'iframe -->
							<a target="geoIframe">
							    <xsl:attribute name="href"><xsl:value-of select="@url" /></xsl:attribute>
								<xsl:attribute name="class">a_<xsl:value-of select="../statut_station" />
								</xsl:attribute>
								<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
								<xsl:attribute name="onclick">
								    geoPrepareIframe('geoIframe');
									geoUpdateContexte('<xsl:value-of select="../contexte" />');
								</xsl:attribute>
								<xsl:value-of select="@lib" />
								<xsl:text>&#x20;</xsl:text>
								<xsl:value-of select="../description" />
							</a>
			              </xsl:when>
			          <xsl:otherwise>
	       					 <!--  lien à gérer par un appel AJAX sur onclick -->
	
								<!-- pas d'attribut target -->
									<a href="#">
										<xsl:attribute name="class">a_<xsl:value-of select="../statut_station" />
										</xsl:attribute>
										<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
										<xsl:attribute name="onclick">
											geoChangeClasse(this,'<xsl:value-of select="../statut_station" />');
											hideElement(this,'<xsl:value-of select="@hide" />');
											geoUpdateContexte('<xsl:value-of select="../contexte" />');
											geoRequete('<xsl:value-of select="@url" />','<xsl:value-of select="@push" />')
										</xsl:attribute>
										<xsl:value-of select="@lib" />
										<xsl:text>&#x20;</xsl:text>
										<xsl:value-of select="../description" />
									</a>
	
	
			     		</xsl:otherwise>
			        </xsl:choose>	
			     </td>				
				</xsl:for-each>
			</tr>
	</xsl:template>
	
	<xsl:template match="titre">
	<tr>
	<td>
		<div class="mytitcol">
			<xsl:value-of select="." />
		</div>
	</td>
	</tr>
	</xsl:template>
		
	<xsl:template match="image">
		<img style="margin-top:50px;margin-left:20px" height="110" width="150" border="0" >
			<xsl:attribute name="src">images/<xsl:value-of select="." /> </xsl:attribute>
		</img>
	</xsl:template>
	
</xsl:stylesheet>