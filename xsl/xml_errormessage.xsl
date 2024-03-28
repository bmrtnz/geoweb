<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
<xsl:template match="msgs">
<link href="../css/tools.css" rel="stylesheet" type="text/css" />
<div class="geoTargetFlottant">
<div class="geoContainerFlottant diverror"  id="geoErreur">
	<div class="titreError"> 
	<table border="0">
	<tr>
	<td align="center" valign="middle"><img src="images/error.gif" /></td>
	<td>
		<table>
			<xsl:for-each select="msg">
				<tr><td style="font-size:11px"><xsl:value-of select="."/></td></tr>
			</xsl:for-each>
		</table>
	</td>
	</tr>
	</table>
</div>
</div>
</div>
</xsl:template>
</xsl:stylesheet>