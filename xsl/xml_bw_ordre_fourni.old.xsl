<?xml version="1.0" encoding="UTF-8"?>
<!-- transformation xml xml standard pour un ordre-->
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" encoding="ISO-8859-1"> </xsl:output>
<xsl:template match="root">
<xsl:for-each select="ORDRE">
<xsl:for-each select="ENTETE/ITEM">&lt;ENTETE&gt;<xsl:text>&#9;</xsl:text><xsl:for-each select="*"><xsl:value-of select="."/><xsl:text>&#9;</xsl:text></xsl:for-each>&lt;/ENTETE&gt;
</xsl:for-each>
<xsl:for-each select="LIGNE/ITEM">&lt;LIGNE&gt;<xsl:text>&#9;</xsl:text><xsl:for-each select="*"><xsl:value-of select="."/><xsl:text>&#9;</xsl:text></xsl:for-each>&lt;/LIGNE&gt;
</xsl:for-each>
</xsl:for-each>
</xsl:template>
</xsl:stylesheet>