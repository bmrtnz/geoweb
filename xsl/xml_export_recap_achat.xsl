<?xml version="1.0" encoding="UTF-8"?>
<!-- transformation xml xml standard pour un ordre-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
<xsl:variable name="refdoc">
<xsl:value-of select="xml_recap_achat_detail/doc/ref_doc"/>
</xsl:variable>
<xsl:output method="text" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="/">
	<xsl:text>refdoc;typevente;fou_code;nordre;fac_num;fou_ref_doc;description;nb_col;pds_net;ach_qte;ach_bta_code;ach_pu;montant;pay_code;client_raisoc;date_exp;orl_ref;orl_ref_ori;lit_cause_code;lit_cause_desc;exp_code</xsl:text>
	<xsl:value-of select="$newline"/>
	<xsl:for-each select="xml_recap_achat_detail/header">
		<xsl:variable name="typevente">
			<xsl:value-of select="type_vente"/>
		</xsl:variable>
		<xsl:for-each select="detail">
			<xsl:value-of select="$refdoc"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="$typevente"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="fou_code"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="nordre"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="fac_num"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="fou_ref_doc"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="description"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="nb_col"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="pds_net"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="ach_qte"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="ach_bta_code"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="ach_pu"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="montant"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="pay_code"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="client_raisoc"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="date_exp"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="orl_ref"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="orl_ref_papa"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="lca_code"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="lca_desc"/>
			<xsl:text>;</xsl:text>
			<xsl:value-of select="exp_code"/>
			<xsl:value-of select="$newline"/>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>