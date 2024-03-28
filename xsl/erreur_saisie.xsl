<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:include href="xml_errormessage.xsl"/>
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
			<!-- transfert du contenu de la fenetre des messages de la hidden frame vers la frame_form -->
			<body onload="top.frame_form.document.getElementById('errormessage').innerHTML = document.getElementById('errormessage').innerHTML;
				top.frame_form.document.getElementById('errormessage').style.visibility='visible';top.frame_form.document.getElementById('geoMessage').style.visibility='hidden'">
				<!-- generation de la fenetre des messages -->
				<xsl:apply-templates select="msgs"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="ok">
		<!-- id qui sont OK : on leur donne l'aspect des champs sans erreur -->
		<xsl:for-each select="id">
		top.frame_form.document.getElementById('<xsl:value-of select="."/>').className='inputText';
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="err">
		<!-- id qui sont pas OK : on leur donne l'aspect des champs avec erreur -->
		<xsl:for-each select="id">
		top.frame_form.document.getElementById('<xsl:value-of select="."/>').className='inputTextError';
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>