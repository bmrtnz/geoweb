<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
<!--l:include href="actionMenuM_2.xsl"/>-->
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
	<html>
	<head>
        <meta http-equiv="Expires" CONTENT="-1"/> 
        <meta http-equiv="Cache-Control" CONTENT="no-cache"/>
        <meta http-equiv="Pragma" CONTENT="no-cache"/> 		
		<link href="../css/tools.css" rel="stylesheet" type="text/css" />
		<script src="../js/tools.js" type="text/javascript">
		</script>
	</head>
	<body onload="afficheMessage();cacheWaitMessage();" topmargin="0">
		<xsl:apply-templates select="menu" />
		<div id="messageContent">
			<div class="welcomeMessage" id="welcome_message" style="visibility:hidden">
			<xsl:for-each select="item">
				
					<div>
							<xsl:value-of select="."/>
	                 </div>
			</xsl:for-each>
			</div>
		</div>
	</body>
	</html>
</xsl:template>
</xsl:stylesheet>
