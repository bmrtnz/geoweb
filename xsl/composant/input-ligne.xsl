<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="input">

	<!-- chaque input -->

	<td class="cell-flottant" align="left" style="white-space: nowrap;">
		
		<xsl:if test="@lib !=''">
			<xsl:value-of select="@lib" />:&#160;
		</xsl:if>
	
		<input onChange="geoFormChange(this)" onKeyPress="if(event.keyCode == 13)return false;" class="inputText ui-widget ui-widget-content ui-corner-all" type="text">
		<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
		<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
		<xsl:attribute name="maxlength"><xsl:value-of select="@len" /></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
		<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
		</input>
	</td>
</xsl:template>
</xsl:stylesheet>
