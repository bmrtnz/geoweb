<?xml version="1.0" encoding="UTF-8"?>
<!-- transformation xml xml standard pour un ordre-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
<xsl:variable name="refdoc">
<xsl:value-of select="xml_recap_historique_palox/doc/ref_doc"/>
</xsl:variable>
<xsl:output method="text" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="/">
	<xsl:text>Client;Code client;Transporteur;Code transporteur;Date départ;Ref client / CMR;No d'ordre;Quantité</xsl:text>
	<xsl:value-of select="$newline"/>
	<xsl:for-each select="xml_recap_historique_palox/header">
		<xsl:for-each select="detail">
			
			<xsl:value-of select="geo_client_cli_raisoc"/>
			<xsl:text>;</xsl:text>

			<xsl:value-of select="geo_ordre_cli_code"/>
			<xsl:text>;</xsl:text>

			<xsl:value-of select="geo_transp_trp_raisoc"/>
			<xsl:text>;</xsl:text>

			<xsl:value-of select="geo_ordre_trp_code"/>
			<xsl:text>;</xsl:text>

			<xsl:value-of select="geo_ordre_depdatp"/>
			<xsl:text>;</xsl:text>
		
			<xsl:value-of select="geo_ordre_ref_cli"/>
			<xsl:text>;</xsl:text>
		
			<xsl:value-of select="nordre"/>
			<xsl:text>;</xsl:text>
		
			<xsl:value-of select="qte"/>
			<xsl:text>;</xsl:text>
		
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>