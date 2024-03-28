<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="titre_para">
<td class="titreListe" align="left">	
	<div style="font-size:14px;margin-top:10px;margin-bottom:10px;text-decoration:underline;font-weight:bold">		
		<xsl:value-of select="@lib"/>
	</div>
</td>	
<td></td>
</xsl:template>
</xsl:stylesheet>
