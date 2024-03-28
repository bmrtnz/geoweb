<?xml version="1.0" encoding="UTF-8"?>
<!-- picklist avec accordeons standard -->
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
			<div style="visibility:hidden" id="bulle">
				<xsl:text>&#xA;</xsl:text>
			</div>
		<xsl:apply-templates select="menu" />
			<div id="contenuPickListe">

				<!--  il peut y avoir des boutons en debut de liste -->
				<xsl:apply-templates select="boutons"/>
				
				<!--  on affiche le titre -->
				<xsl:apply-templates select="header/titre"/>

				<!--  on cree l'accordeon et on appelle les autres templates pour gerer les sections -->
				<div id="geoListeAccordeon">
					<xsl:apply-templates select="section"/>
				</div>
				
			</div>
		</div>
	</xsl:template>
	
		<xsl:template match="titre">
				<div class="mytitcol">
					<xsl:value-of select="." />
				</div>
		</xsl:template>

		<!--  template de tete de section de l'accordeon-->
		<xsl:template match="section"> 
		<!--  on traite la tete de section -->
		<h3><a href="#"><xsl:value-of select="@lib"/></a></h3>
		
		<!--  on appelle les autres template qui vont traiter le contenu -->
		<div>
			<xsl:apply-templates select="detail"/>
	</div>
		</xsl:template>
		
		<xsl:template match="detail">
			<xsl:apply-templates />
		</xsl:template>
		
		<xsl:template match="link">
				       <xsl:choose>
				          <xsl:when test="@target='pdf'">
				          <!-- si le lien fait appel à du PDF, c'est un appel direct sans appel AJAX -->
				          <!--  la target du lien doit etre l'iframe -->
				          		<div>
								<a target="geoIframe">
								    <xsl:attribute name="href"><xsl:value-of select="@url" /></xsl:attribute>
									<xsl:attribute name="class">a_<xsl:value-of select="../../statut" />
									</xsl:attribute>
									<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
									<xsl:attribute name="onclick">
									    geoPrepareIframe('geoIframe');
										geoUpdateContexte('<xsl:value-of select="@lib" />');
									</xsl:attribute>
									<xsl:value-of select="@lib" />
									<xsl:text>&#x20;</xsl:text>
									<xsl:value-of select="../../description" />
								</a>
								</div>
				              </xsl:when>
				          <xsl:otherwise>
         					 <!--  lien à gérer par un appel AJAX sur onclick -->

							<!-- pas d'attribut target -->
							<div>
								<a href="#">
									<xsl:attribute name="class">a_<xsl:value-of select="../../statut" />
									</xsl:attribute>
									<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
									<xsl:attribute name="onclick">
										hideElement(this,'<xsl:value-of select="@hide" />');
										geoUpdateContexte('<xsl:value-of select="@lib" />');
										geoRequete('<xsl:value-of select="@url" />')
									</xsl:attribute>
									<xsl:value-of select="@lib" />
									<xsl:text>&#x20;</xsl:text>
									<xsl:value-of select="../../description" />
								</a>
								</div>
				     		</xsl:otherwise>
				        </xsl:choose>	
		</xsl:template>
		
		<xsl:template match="contexte">
		<!--  consommation du contexte -->
		</xsl:template>
		
</xsl:stylesheet>