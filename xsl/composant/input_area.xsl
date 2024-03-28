<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="input_area">

	<!-- chaque input -->
<div style="margin-bottom:5px">
	<div>	<xsl:value-of select="@lib" />:&#160;
	</div>
	<div>
		<textarea onChange="geoFormChange()" onKeyPress="if(event.keyCode == 13)return false;" class="inputText ui-widget ui-widget-content ui-corner-all">
		<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
		<xsl:attribute name="cols"><xsl:value-of select="@nbcol" />	</xsl:attribute>
		<xsl:attribute name="rows"><xsl:value-of select="@nbligne" />	</xsl:attribute>
		<xsl:attribute name="maxlength"><xsl:value-of select="@size" />	</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
		<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
		</textarea>
	</div>
</div>
</xsl:template>
</xsl:stylesheet>
