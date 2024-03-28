<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="texte">
<div style="margin-bottom:5px">
	<table width='100%' border="0" class="myrow">
	<tr>
	<td align="right" width="150px">
		<xsl:value-of select="@lib"/>&#160;
	</td>
	<td  align="left" style="font-weight:bold">
		<xsl:value-of select="@value"/>
	</td>
	</tr>
	</table>
</div>


</xsl:template>
</xsl:stylesheet>
