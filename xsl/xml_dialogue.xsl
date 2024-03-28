<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:include href="composant/input_hidden.xsl"/>	
<xsl:include href="composant/boutonsjs.xsl"/>	
<xsl:include href="composant/context.xsl"/>
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<xsl:template match="root">
	<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
	<div class="geoRoot">
		<xsl:apply-templates />
	</div>
</xsl:template>

	<!-- pour chaque target on va relancer les template apr�s avoir conserv� l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	<!-- ce detail de saisie doit s'afficher dans un div flottant -->
	<!--  la cible (qui doit etre unique) est identifi�e avec la classe geoTargetFlottant -->
	<!--  elle sera reper�e dans le manageReponseHTML gr�ce � cette classe -->
	<!--  on ajoute au contenu de cette target un div geoContainerFlottant qui sera ajout� dynamiquement au body et rendu flottant -->
	<!--  � ce moment (voir  manageReponseHTML) -->
	<xsl:template match="target">
		<div class="geoTargetFlottant">
			<div class="geoContainerFlottant">
				<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@titre"></xsl:value-of></xsl:attribute>
				<xsl:apply-templates />
			</div>
		</div>
	</xsl:template>

<xsl:template match="description">
<div><xsl:value-of select="."/></div>
</xsl:template>

</xsl:stylesheet>