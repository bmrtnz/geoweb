<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="inputs">
<xsl:choose>
	<xsl:when test="@disposition='horizontale'">
		<div class="titreListe" ><xsl:value-of select="@lib" /></div>
		<table>
			<!-- chaque input -->
		<xsl:for-each select="input">
			<tr>
			<td class="myrow">	<xsl:value-of select="@lib" /></td>
			<td>
			<input onKeyPress="if(event.keyCode == 13)return false;" class="inputText" type="text">
			<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
			<xsl:attribute name="maxlength"><xsl:value-of select="@len" /></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
			<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
			</input>
			</td>
			</tr>
		</xsl:for-each>
		</table>
	</xsl:when>
	<xsl:otherwise>
		<div class="titreListe" ><xsl:value-of select="@lib" /></div>
		<table>
		<tr>
			<!-- chaque input -->
		<xsl:for-each select="input">
			<td class="myrow">	<xsl:value-of select="@lib" /></td>
			<td>
			<input class="inputText" type="text">
			<xsl:attribute name="name"><xsl:value-of select="@name" />	</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
			<xsl:attribute name="maxlength"><xsl:value-of select="@len" /></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
			<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
			</input>
			</td>
		</xsl:for-each>
		</tr>
		</table>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
