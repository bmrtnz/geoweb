<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/table.xsl" />
	<xsl:include href="composant/context.xsl" />
	<xsl:include href="composant/texte.xsl" />
	<xsl:include href="composant/boutonsjs.xsl" />


	
	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="grille_controle_qualite"/>
	</xsl:template>

	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates/>
		</div>
		<!--  pas de back pour cette fenetre -->
		<div id="geoBack" class="geoTarget">
		</div>
	</xsl:template>

	<xsl:template match="grille_controle_qualite">
		<rows>
		  <page><xsl:value-of select="@page"/></page>
		  <total><xsl:value-of select="@total"/></total>
		  <records><xsl:value-of select="@records"/></records>
		  <type><xsl:value-of select="@type"></xsl:value-of></type>
		  <onglet><xsl:value-of select="@onglet"></xsl:value-of></onglet>
		  <grille><xsl:value-of select="@grille"></xsl:value-of></grille>
		  
		  <!--  gestion de l'entete de grille et d'autres cibles HTML -->
		  <!--  on force le traitement des elements qui sont sous la balise <target> -->
		  <!--  à cet endroit ces elements ne gênent pas la structure attendue pour la grille -->
		  <!--  ils seront exploités dans la fonction geoGridManageReponse pour etre injectes -->
		  <!--  dans le div dont l'id est celui la balise <target> -->

		  	<xsl:apply-templates select="/root/target"/>
			<xsl:apply-templates />
		</rows>
	</xsl:template>
	
	<xsl:template match="row">
		<row>
		<!--  id du row qui est la clé unique -->
		<xsl:attribute name="id"><xsl:value-of select="@ordref"/></xsl:attribute>

			<!--  Ligne -->
			<cell>
				<xsl:value-of select="cell[@id = 'ligne']"/>
			</cell>
			<!--  Article -->
			<cell>
				<xsl:value-of select="cell[@id = 'article_desc']"/>
			</cell>
			<!--  Controleur -->
			<cell>
				<xsl:value-of select="cell[@id = 'controleur']"/>
			</cell>			
			<!--  Ref -->
			<cell>
				<xsl:value-of select="cell[@id = 'ref_controle']"/>
			</cell>
			<!--  Actions (accueille les boutons d'actions )-->
			<cell>
			<![CDATA[
					<a href="]]><xsl:value-of select="cell[@id = 'url']"/><![CDATA[" target="geoIframe">
					<img onclick="geoPrepareIframe('geoIframe')" class="geoImageAction" src="images/zoom.gif" /></a>]]>
			</cell>		
											
		</row>
	</xsl:template>
	
</xsl:stylesheet>
