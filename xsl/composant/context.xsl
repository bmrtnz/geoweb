<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<!-- template pour le contexte de navigation -->
<xsl:template match="contextes">

<xsl:apply-templates />

</xsl:template>

<xsl:template match="contexte">

<!--  si l'url est renseigné le lien de contexte est actif -->
<xsl:choose>
	<xsl:when test="@url != ''">
		<a>
		<xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
		<xsl:value-of select="@lib"/>
		</a>
	</xsl:when>
	<xsl:otherwise>
	<a class="geoNavigationContexteInactive"><xsl:value-of select="@lib"/>
	</a>
	</xsl:otherwise>
</xsl:choose>



</xsl:template>

</xsl:stylesheet>