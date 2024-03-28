<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1">
</xsl:output>
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
			<div   style="visibility:hidden" id="bulle"><xsl:text>&#xA;</xsl:text>
			</div> 
			<!-- <label> TRANSFORMATION XSL OK</label> -->
		    <xsl:apply-templates />
        </div>
</xsl:template>		

<xsl:template match="header/titre">
	<table cellspacing="0" cellpadding="0" border="0" bordercolor="red">
		<tr class="mytitcol"><td> <xsl:value-of select="."/></td></tr>
	</table>
</xsl:template>	
	
<xsl:template match="lignes">
		<table cellspacing="5" cellpadding="2" border="0" bordercolor="blue">
	<tr class="header2"><th>heure envois</th><th>heure réception</th><th>moyen</th><th>version</th></tr>
	<xsl:apply-templates />
</table>
</xsl:template>	
	
<xsl:template match="detail">
<tr  class="myrowsmall" height="6">
<xsl:apply-templates />
</tr>
</xsl:template>	
	
<xsl:template match="geo_envois_version_ordre">
	<td align="center">
		<xsl:value-of select="."/>
	</td>
</xsl:template>	

<xsl:template match="moc_code">
	<td align="center">
		<xsl:value-of select="."/>
	</td>
</xsl:template>	
<xsl:template match="demdat">
	<td>
		<xsl:value-of select="."/>
	</td>
</xsl:template>	
<xsl:template match="ackdat">
	<td>
		<xsl:value-of select="."/>
	</td>
</xsl:template>	
	
</xsl:stylesheet>
		

