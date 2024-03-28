<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>

<xsl:template match="table">
	<table  class="table-flottant" border="0" cellpadding="5" cellspacing="0">
		<xsl:apply-templates/>
	</table>
</xsl:template>


<xsl:template match="ligne">
	<tr class="ligne-flottant myrow"  >
		<xsl:apply-templates/>	
	</tr>
</xsl:template>

</xsl:stylesheet>
