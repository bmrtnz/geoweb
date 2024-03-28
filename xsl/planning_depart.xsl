<xsl:stylesheet version="1.0"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--	xmlns:fn="http://www.w3.org/2005/02/xpath-functions">
	<xsl:import href="fof_general.xsl"/> -->
	<xsl:import href="planning_depart_templates.xsl"/>

	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-16LE"/>
	<xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
	<xsl:param name="current_date"/>
	<xsl:template match="root">

		<fo:root>
			<fo:layout-master-set>
					<!-- définition du support papier -->
				<fo:simple-page-master
					master-name="resume_intervention"
					page-height="21cm" page-width="29.7cm"
					margin-top="0.8cm"	margin-bottom="0.8cm"
					margin-left="0.8cm"	margin-right="0.8cm">
						<!-- Central part of page -->
					<fo:region-body
						region-name="xsl-region-body"
						column-count="1"
						margin-top="0cm"
						margin-bottom="0cm"
						margin-left="0cm"
						margin-right="0cm"/>
						<!-- Header -->
					<fo:region-before
						region-name="xsl-region-before"
						extent="0cm"/>
						<!-- Footer -->
					<fo:region-after
						region-name="xsl-region-after"
						extent="0cm"/>
						<!-- Gauche -->
					<fo:region-start
						region-name="xsl-region-start"
						extent="0cm"/>
						<!-- Droite -->
					<fo:region-end
						region-name="xsl-region-end"
						extent="0cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
				<!-- définition du contenu de la page (un seul type de page)  -->
			<fo:page-sequence master-reference="resume_intervention"
				force-page-count="no-force" initial-page-number="1">
				<!-- Marge haute -->
				<!--
				<fo:static-content flow-name="xsl-region-before">
					<xsl:call-template name="page_header"/>
				</fo:static-content>
				-->
				<!-- Marge basse -->
				<!--
				<fo:static-content flow-name="xsl-region-after">
					<xsl:call-template name="page_footer"/>
				</fo:static-content>
				-->
				<!-- le corps de page (body) -->
				<fo:flow flow-name="xsl-region-body">
					<xsl:call-template name="page_body"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>