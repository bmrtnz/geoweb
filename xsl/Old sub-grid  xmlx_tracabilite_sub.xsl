<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="rows"/>
	</xsl:template>

	<xsl:template match="rows">
		<rows>
			<xsl:apply-templates />
		</rows>
	</xsl:template>
	
	<xsl:template match="row">
		<row>
		<!--  id du row qui est la clé unique -->
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
		
			<xsl:if test='@cloture = "N"'>
			<!--  Actions sur articles -->
			<cell><![CDATA[<img width="12" height="12" onclick="geoGridDeleteRowChoixArticles('geoGridChoixArticles',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>			
			</xsl:if>

			<xsl:if test='@cloture = "O"'>
			<!-- Ordre cloturé donc pas d'action possible -->
			<cell></cell>			
			</xsl:if>
			
			<!--   ref article -->
			<cell>
				<xsl:value-of select="cell[@id = 'artref']"/>
			</cell>

			<!--  description article-->
			<cell>
				<xsl:value-of select="cell[@id = 'artdesc']"/>
			</cell>		
			<!--  nombre colis-->
			<cell>
				<xsl:value-of select="cell[@id = 'nbcolis']"/>
			</cell>	
			<!--  poids brut-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsbrut']"/>
			</cell>	
			<!--  poids net-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsnet']"/>
			</cell>		
			<!--  poids net-->
			<cell>
				<xsl:value-of select="cell[@id = 'arbocode']"/>
			</cell>		
		</row>
	</xsl:template>
	
</xsl:stylesheet>
