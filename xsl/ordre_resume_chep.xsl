<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- detail d'un ordre -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1">
</xsl:output>
<xsl:include href="composant/boutons.xsl" />
<!-- corps principal de la page -->
<xsl:template match="root">
	<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
	<div class="geoRoot">
		<xsl:apply-templates />
		<div id="geoBack" class="geoTarget">
			<a onclick="geoRestoreHistory()" href="#" >Retour</a>
		</div>
	</div>

</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
<xsl:template match="target">
	<div class="geoTarget">
		<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
	
		<div class="header1">Expéditions : ordre résumé</div>
		<xsl:apply-templates />
	</div>
</xsl:template>		

<!-- entete commande -->
<xsl:template match="header">
	<table border="0" cellpadding="0" cellspacing="5">
		<tr>
			<td class="geoLabel">Ordre</td>
			<td class="geoValue">
				<xsl:value-of select="ordre" /> 
				- <xsl:value-of select="commercial" />

				/ <xsl:value-of select="assistant" />
			</td>
		</tr>
		<tr>
			<td class="geoLabel">Entrepot</td>
			<td class="geoValue">
				<xsl:value-of select="entrepot" />
			</td>
		</tr>
		<tr>
			<td class="geoLabel">Transport</td>
			<td class="geoValue">
				<xsl:value-of select="transport" />
			</td>
			<td class="geoValue">
				<xsl:value-of select="groupage" />
			</td>
		</tr>
		<xsl:if test="instructions!=''">
			<tr>
				<td class="geoLabel">Instructions</td>
				<td class="geoValue">
					<xsl:value-of select="instructions" />
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="ref_client!=''">
			<tr>
				<td class="geoLabel">Reference</td>
				<td class="geoValue">
					<xsl:value-of select="ref_client" />
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="immatriculation!=''">
			<tr>
				<td class="geoLabel">Immatriculation</td>
				<td class="geoValue">
					<xsl:value-of select="immatriculation" />
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="chep!=''">
			<tr>
				<td class="geoLabel">CHEP</td>
				<td class="geoValue">
					<xsl:value-of select="chep" />
				</td>
			</tr>
		</xsl:if>
		<tr>
			<td class="geoLabel"></td>
			<td class="geoStatut">
				<xsl:value-of select="statut" />
			</td>
		</tr>
	</table>
	<table border="0" cellpadding="0" cellspacing="5">
		<tr>
			<td class="geoLabel">palettes au sol</td>
			<td class="geoStatut">
				<xsl:value-of select="geo_ordlog_pal_nb_sol" />
			</td>
			<td></td>
			<xsl:if test="geo_ordlog_pal_nb_pb100x120!=''">
				<td class="geoLabel">pal.bleues 100x120</td>
				<td class="geoStatut">
					<xsl:value-of select="geo_ordlog_pal_nb_pb100x120" />
				</td>
				<td></td>
			</xsl:if>
			<xsl:if test="geo_ordlog_pal_nb_pb80x120!=''">
				<td class="geoLabel">pal.bleues 80x120</td>
				<td class="geoStatut">
					<xsl:value-of select="geo_ordlog_pal_nb_pb80x120" />
				</td>
				<td></td>
			</xsl:if>
			<xsl:if test="geo_ordlog_pal_nb_pb60x80!=''">
				<td class="geoLabel">pal.bleues 60x80</td>
				<td class="geoStatut">
					<xsl:value-of select="geo_ordlog_pal_nb_pb60x80" />
				</td>
			</xsl:if>
		</tr>
	</table>
</xsl:template>

<!-- titre des lignes -->
<xsl:template match="lignes">
	<table cellspacing="2" cellpadding="2" border="0">
		<tr class="header1">
			<td>pal.</td>
			<td>½ pal</td>
			<td>pal inter.</td>
			<td>col/pal</td>
			<td>colis</td>
			<td>article</td>
			<td>description du produit</td>
		</tr>
		<xsl:apply-templates /> <!--  va relancer le template pour le detail des lignes -->
	</table>
</xsl:template>

	<!-- Traitement des lignes  -->
<xsl:template match="detail">
	<tr class="geoLigne">
		<td class="geoCell" align='center'>
			<xsl:value-of select="palettes" />
		</td>
		<td class="geoCell" align='center'>
		<xsl:if test="geo_ordlig_demipal_ind='1'">
			Oui
		</xsl:if>
		<xsl:if test="geo_ordlig_demipal_ind='0'">
			Non
		</xsl:if>
		</td>
		<td class="geoCell" align='center'>
		<xsl:if test="geo_ordlig_pal_nb_palinter='1'">
			Oui
		</xsl:if>
		<xsl:if test="geo_ordlig_pal_nb_palinter='0'">
			Non
		</xsl:if>
		</td>
		<td class="geoCell" align='center'>
			<xsl:value-of select="pal_nb_col" />
		</td>
		<td class="geoCell">
			<xsl:value-of select="colis" />
		</td>
		<td class="geoCell">
			<a class="a_bw" href='#'>
				<xsl:attribute name="onclick">
					geoRequete('PBServlet?httpPBCommand=zoom_article&amp;art_ref=<xsl:value-of select="article" />')
				</xsl:attribute>	
				<xsl:value-of select="article" />			
			</a>
		</td>
		<td class="geoCell">
			<xsl:value-of select="produit" />
		</td>
	</tr>
</xsl:template>	
		
</xsl:stylesheet>