<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="UTF-8"></xsl:output>
<xsl:template match="input_hidden">

	<!-- chaque input -->

		<input class="inputText ui-widget ui-widget-content ui-corner-all" type="hidden">
		<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
		<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
		<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
		</input>
</xsl:template>
</xsl:stylesheet>
