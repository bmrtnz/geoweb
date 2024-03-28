<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="liste_multi_check">
		<xsl:if test="count(item) != 0" >
	
				<td title="listeMultiCheck" align="right">
					<xsl:value-of select="@lib" />:&#160;
				</td>
				<td>
				<select multiple="true" class="listeMultiCheck">
				<xsl:if test="(@onchange !='')">
					<xsl:attribute name="onchange"><xsl:value-of select="@onchange" />();</xsl:attribute>
				</xsl:if>
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:apply-templates />
				</select>
				</td>
		</xsl:if>	
		<xsl:if test="count(item) = 0" >
		<td align="right">
			<xsl:value-of select="@none" />
		</td>
		<td>
		 
		</td>
		</xsl:if>		
			

	</xsl:template>
	
	
	<xsl:template match="item">
		<option>
			<xsl:attribute name="value">
				<xsl:value-of select="@value" />
			</xsl:attribute>
			<xsl:if test="@check">
				<xsl:attribute name="selected"></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="@lib" />
		</option>
	</xsl:template>
</xsl:stylesheet>