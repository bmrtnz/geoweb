<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="texte">
	<td class="cell-flottant" valign="middle" align="left">
		<xsl:if test="@colspan">
			<xsl:attribute name="colspan"><xsl:value-of select="@colspan"></xsl:value-of></xsl:attribute>
		</xsl:if>
		<xsl:if test="@title">
			<xsl:attribute name="align">center</xsl:attribute>
			<xsl:attribute name="bgcolor">#cccccc</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@lib"/>&#160; 
	</td>
</xsl:template>
</xsl:stylesheet>
