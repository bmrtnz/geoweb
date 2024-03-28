<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/boutons.xsl" />
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au
			fragment html genere -->
		<div class="geoRoot">
			<xsl:if test="not(target)">
				<div class="geoTarget" id="geoColonneMilieu">
		<div  class="diverror" id="geoErreur">
	<div class="titreError"> 
	<img style="cursor:hand" onclick="$('#geoErreur').fadeOut()"  src="images/close.gif"/></div>
			Pas de target definie
				</div>
				</div>
			</xsl:if>
			<xsl:if test="target">
			<xsl:apply-templates />
			</xsl:if>
			<div id="geoBack" class="geoTarget">
				<a onclick="geoRestoreHistory()" href="#" >Retour</a>
			</div>
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé
		l'id de la target -->
	<!-- on garde une balise <div> de class geoTarget qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<!-- titre -->
			<xsl:for-each select="titre">
				<div class="header1">
					<xsl:value-of select="." />
				</div>
			</xsl:for-each>
			<!-- description -->
			<xsl:for-each select="description">
				<table cellspacing="0" cellpadding="0" border="0" bordercolor="red">
					<tr class="myrow" style="font-style:italic">
						<td>
							<xsl:value-of select="." />
						</td>
					</tr>
				</table>
				<br />
			</xsl:for-each>
			<xsl:apply-templates />
		</div>
	</xsl:template>

</xsl:stylesheet>
