<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<!--<xsl:include href="actionMenuM_2.xsl"/>-->
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="root">
<html>
<head>
<xsl:text>&#xA;</xsl:text>
<meta http-equiv="Expires" CONTENT="-1"/>
<meta http-equiv="Cache-Control" CONTENT="no-cache"/>
<meta http-equiv="Pragma" CONTENT="no-cache"/>
<link href="../css/tools.css" rel="stylesheet" type="text/css" />
<xsl:text>&#xA;</xsl:text>
<script src="../js/tools.js" type="text/javascript">
<xsl:text>&#xA;</xsl:text>
</script>
<xsl:text>&#xA;</xsl:text>
</head>
<xsl:text>&#xA;</xsl:text>
<body topmargin="0" onload="switchFrameLocation(top.frame_form);">
<div   style="visibility:hidden" id="bulle">
<xsl:text>&#xA;</xsl:text>
</div>
<!--<xsl:apply-templates select="menu" />-->
<div id="contenuPickListe">
<xsl:for-each select="header/titre">
<div class="mytitcol">
<xsl:value-of select="."/>
</div>
</xsl:for-each>
<xsl:for-each select="boutons/bouton">
<a target="hiddenframe">
	<!-- rajout du / devant l'url -->
<xsl:attribute name="href">/<xsl:value-of select="@url"/></xsl:attribute>
<img style="cursor:hand" border="0" >
<xsl:attribute name="src"> ../images/<xsl:value-of select="@lib"/>-on.gif </xsl:attribute>
<xsl:attribute name="onmouseover"> this.src='../images/<xsl:value-of select="@lib"/>.gif';window.status='';return true </xsl:attribute>
<xsl:attribute name="onmouseout"> this.src='../images/<xsl:value-of select="@lib"/>-on.gif' </xsl:attribute>
</img>
</a>
</xsl:for-each>
<table cellspacing="0" cellpadding="0" border="0" bordercolor="blue">
<xsl:for-each select="lignes/detail">
<tr  class="myrow">
<xsl:for-each select="link">
<td valign="top" width="10%">
	<!-- si l'attribut target est n'est pas présent on considere que la target est frame_form -->
<xsl:if test="not(@target)">
<a target="frame_form">
<xsl:attribute name="class">a_<xsl:value-of select="../statut"/>
</xsl:attribute>
<xsl:attribute name="href"><!-- rajout du / devant l'URL -->/<xsl:value-of select="@url"/>
</xsl:attribute>
<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
<xsl:value-of select="@lib"/><xsl:text>&#x20;</xsl:text> 
</a>
</xsl:if>
	<!-- si l'attribut target est présent on applique la veleur de cet attribut -->
<xsl:if test="@target">
<a>
<xsl:attribute name="target">
<xsl:value-of select="@target"/>
</xsl:attribute>
<xsl:attribute name="class">a_<xsl:value-of select="../statut"/>
</xsl:attribute>
<xsl:attribute name="href"><!-- rajout du / devant l'URL -->/<xsl:value-of select="@url"/>
</xsl:attribute>
<xsl:attribute name="onmouseover">window.status='';return true </xsl:attribute>
<xsl:value-of select="@lib"/> <xsl:text>&#x20;</xsl:text><xsl:value-of select="../description"/>
</a>
</xsl:if>
</td>
</xsl:for-each>
<xsl:for-each select="description">
<td class="value">
<xsl:value-of select="../description"/>
</td>
</xsl:for-each>
</tr>
</xsl:for-each>
</table>
</div>
</body>
</html>
</xsl:template>
</xsl:stylesheet>