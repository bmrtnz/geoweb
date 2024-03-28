<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:include href="composant/table-ligne.xsl"/>
<xsl:include href="composant/combosuggest.xsl"/>
<xsl:include href="composant/input_area_seul.xsl"/>
<xsl:include href="composant/check_seul.xsl"/>
<xsl:include href="composant/input_date_seul.xsl"/>
<xsl:include href="composant/input_hidden.xsl"/>
<xsl:include href="composant/input-seul.xsl"/>		
<xsl:include href="composant/context.xsl"/>
<xsl:include href="composant/texte_seul.xsl"/>
<xsl:include href="composant/boutons_submit_flottant.xsl"/>	

<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="root">
	<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
	<div class="geoRoot">
		<xsl:apply-templates />
	</div>
</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	<!-- ce detail de saisie doit s'afficher dans un div flottant -->
	<!--  la cible (qui doit etre unique) est identifiée avec la classe geoTargetFlottant -->
	<!--  elle sera reperée dans le manageReponseHTML grâce à cette classe -->
	<!--  on ajoute au contenu de cette target un div geoContainerFlottant qui sera ajouté dynamiquement au body et rendu flottant -->
	<!--  à ce moment (voir  manageReponseHTML) -->
	<xsl:template match="target">
		<div class="geoTargetFlottant">
			<div class="geoContainerFlottant">
				<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@titre"></xsl:value-of></xsl:attribute>
				<xsl:apply-templates />
			</div>
		</div>
	</xsl:template>
	
<xsl:template match="form">
<form name="geoFormSaisieFlottant" id="geoFormSaisieFlottant" target=""  method="post" action="PBServlet">
	<input type='hidden' name='httpPBCommand'>
		<xsl:attribute name="value">
		<xsl:value-of select="@url" />
		</xsl:attribute>
	</input>			

<!-- gestion des boutons submit les 2 lignes sont nécessaires -->
<input type="hidden" id="geoWhichButton" name="which_button" value="" />

<!--  relance des templates pour les messages et les boutons -->
<xsl:apply-templates />
</form>

</xsl:template>	

<xsl:template match="description">
<div><xsl:value-of select="."/></div>
</xsl:template>

</xsl:stylesheet>