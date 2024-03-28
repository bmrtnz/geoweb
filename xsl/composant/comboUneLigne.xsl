<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	
<xsl:output method="html" encoding="ISO-8859-1">
</xsl:output>
	

		
<xsl:template match="liste_drop">
				<td>
		
		<div class="titreListe" ><xsl:value-of select="@lib" /> :
			</div>
		<select class="listeDrop">
			<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:apply-templates />
		</select>
		
	</td>
</xsl:template>

<xsl:template match="item">
<option>
<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
<xsl:if test="@check">
	<xsl:attribute name="selected"></xsl:attribute>
</xsl:if>
</option>
<xsl:value-of select="@lib" />

</xsl:template>


</xsl:stylesheet>