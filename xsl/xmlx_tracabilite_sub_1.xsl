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
			<!--   type ligne  -->
			<cell>
				<xsl:value-of select="@typeligne"/>
			</cell>
			<!--   ref traca -->
			<cell>
				<xsl:value-of select="cell[@id = 'raftraca']"/>
			</cell>
		
			<xsl:if test='@cloture = "N"'>
			<!--  Actions sur articles -->
			<cell><![CDATA[<img width="12" height="12" onclick="geoGridDeleteRowChoixArticles('geoGridChoixArticles',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>			
			</xsl:if>

			<xsl:if test='@cloture = "O"'>
			<!-- Ordre cloturé donc pas d'action possible -->
			<cell></cell>			
			</xsl:if>
			
			<!--  description article et palette-->
			<cell>
				<xsl:value-of select="cell[@id = 'desc']"/>
			</cell>		
			<!--  nombre colis ou palette au sol-->
			<cell>
				<xsl:value-of select="cell[@id = 'sol_colis']"/>
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
				<xsl:value-of select="cell[@id = 'arbo']"/>
			</cell>	
			<!--  articles-->
			<cell>
				<xsl:value-of select="cell[@id = 'articles']"/>
			</cell>		

			<xsl:if test='@typeligne = "detail_data"'>
			<!--  Actions sur articles -->
			<cell><![CDATA[<img width="12" height="12" onclick="geoGridAjouterArticles('geoGridChoixArticles',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="image/plus.gif" />]]></cell>			
			</xsl:if>

			<xsl:if test='@typeligne != "detail_data"'>
			<!-- Sinon pas d'action -->
			<cell></cell>			
			</xsl:if>

		</row>
	</xsl:template>
	
</xsl:stylesheet>
