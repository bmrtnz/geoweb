<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="UTF-8"></xsl:output>
<xsl:template match="input-file">

	<!-- chaque input -->
<div style="margin-bottom:5px">
	<td class="titreListe" align="right">	<xsl:value-of select="@lib" />:&#160;
	</td>
	<td>
		<input onChange="geoFormChange()" onKeyPress="if(event.keyCode == 13)return false;" class="inputText ui-widget ui-widget-content ui-corner-all" type="file">
		<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
		<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
		</input>
	</td>
</div>
</xsl:template>
</xsl:stylesheet>