<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/combosuggest.xsl" />
	<xsl:include href="composant/input_date_seul.xsl" />
	<xsl:include href="composant/input-seul.xsl" />
	<xsl:include href="composant/input_hidden.xsl" />
	<xsl:include href="composant/texte.xsl" />
	<xsl:include href="composant/titrepara.xsl" />
	<xsl:include href="composant/boutons_submit_table.xsl" />
	<xsl:include href="xml_errormessage.xsl" />
	<xsl:include href="composant/input_file.xsl" />
	
	<xsl:output method="html" encoding="UTF-8"></xsl:output>
	<xsl:template match="root">
	<xsl:apply-templates select="msgs" />

		<!-- la balise root est traduite en un element englobant correspondant au
			fragment html genere -->
		<div class="geoRoot">
			<!--  declenchement de l'init du cache en mode test pour le moment -->
			<div class="geoCache">
			<xsl:attribute name="cache">init</xsl:attribute>
			<xsl:attribute name="cacheprefix"><xsl:value-of select="@prefix"/></xsl:attribute>
			</div>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé
		l'id de la target -->
	<!-- on garde une balise <div> de class geoTarget qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">

		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!--  Template pour le formulaire de saisie  -->
	<xsl:template match="form">
		<!-- formulaire -->
		<form target="" name="geoFormSaisie" id="geoFormSaisie"  
			method="post" action="PBServlet">
			<input type='hidden' name='httpPBCommand'>
				<xsl:attribute name="value">
				<xsl:value-of select="@url" />
				</xsl:attribute>
			</input>
			<!-- gestion des boutons submit-->
			<input type="hidden" id="geoWhichButton" name="which_button" value="" />
			<xsl:apply-templates select="titre" />
			<div style="float:left">
			<xsl:apply-templates />
			</div>		
				
		</form>

	</xsl:template>
	
	<xsl:template match="lignes">
	<table border="0" cellspacing="1" cellpadding="1">
	<xsl:apply-templates></xsl:apply-templates>
	</table>
	</xsl:template>

			<!--  titre -->
	<xsl:template match="titre">
			<!-- titre -->
			<div class="header1">
				<xsl:value-of select="." />
			</div>
	</xsl:template>

	<xsl:template match="ligne">
	<tr>
	<xsl:apply-templates/>
	</tr>
	</xsl:template>

</xsl:stylesheet>
