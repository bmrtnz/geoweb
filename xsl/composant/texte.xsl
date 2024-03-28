<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="texte">
	<td align="right">
		<xsl:value-of select="@lib"/>&#160;
	</td>
	<td>
		<xsl:value-of select="@value"/>
	</td>
</xsl:template>
</xsl:stylesheet>
