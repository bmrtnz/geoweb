<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="grille_choix_articles"/>
	</xsl:template>

	<xsl:template match="grille_choix_articles">
		<rows>
		  <page><xsl:value-of select="@page"/></page>
		  <total><xsl:value-of select="@total"/></total>
		  <records><xsl:value-of select="@records"/></records>
		  <type><xsl:value-of select="@type"></xsl:value-of></type>
		  <onglet><xsl:value-of select="@onglet"></xsl:value-of></onglet>
		  <grille><xsl:value-of select="@grille"></xsl:value-of></grille>
		  <ordref><xsl:value-of select="@ordref"></xsl:value-of></ordref>
		  
			<!--  pas de balise target pour cette grille -->
			<xsl:apply-templates />
		</rows>
	</xsl:template>
	
	<xsl:template match="row">
		<row>
		<!--  id du row qui est la clé unique -->
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>

			<!--   ref article -->
			<cell>
				<xsl:value-of select="cell[@id = 'refart']"/>
			</cell>

			<!--  description article-->
			<cell>
				<xsl:value-of select="cell[@id = 'desc']"/>
			</cell>		
			<!--  nombre colis-->
			<cell>
				<xsl:value-of select="cell[@id = 'nbcol']"/>
			</cell>	
			<!--  poids brut-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsbrut']"/>
			</cell>	
			<!--  poids net-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsnet']"/>
			</cell>	
			<!--  code arbo-->
			<cell>
				<xsl:value-of select="cell[@id = 'codearbo']"/>
			</cell>	
			<!--  tare-->
			<cell>
				<xsl:value-of select="cell[@id = 'tare']"/>
			</cell>							
			<!--  poids net unité-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsnetunit']"/>
			</cell>	
			<!--  poids brut unité-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsbrutunit']"/>
			</cell>	
			<!--  reference traceabilité -->
			<cell>
				<xsl:value-of select="cell[@id = 'reftraca']"/>
			</cell>	
			<!--  reference traceabilité ligne -->
			<cell>
				<xsl:value-of select="cell[@id = 'reftracaligne']"/>
			</cell>	
			<!--  Actions sur articles -->
			<cell><![CDATA[<img onclick="geoGridAjouterArticles('geoGridChoixArticles',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/plus.gif" />]]></cell>	
		</row>
	</xsl:template>
	
</xsl:stylesheet>
