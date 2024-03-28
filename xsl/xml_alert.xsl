<?xml version="1.0" encoding="UTF-8"?>
<!-- l'alerte s'affiche dans la frame destinataire -->
<!-- si cette frame est la frame cachee -->
<!-- le swith permet de l'afficher dans la frame "form" -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
<!--	<xsl:import href="actionMenuM_2.xsl"/>-->
	<xsl:include href="xml_errormessage.xsl"/>
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
		<html>
			<head>
                <meta http-equiv="Expires" CONTENT="-1"/> 
                <meta http-equiv="Cache-Control" CONTENT="no-cache"/>
                <meta http-equiv="Pragma" CONTENT="no-cache"/> 
				<link href="../css/tools.css" rel="stylesheet" type="text/css" />
				<script src="../js/tools.js" type="text/javascript">
				<xsl:text>&#xA;</xsl:text>
				</script>
			</head>
			<body onload="switchFrameLocation(top.frame_form);" > 
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>