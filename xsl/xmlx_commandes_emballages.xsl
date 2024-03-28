<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/table.xsl" />
	<xsl:include href="composant/combosuggest.xsl" />
	<xsl:include href="composant/context.xsl" />
	<xsl:include href="composant/texte.xsl" />
	<xsl:include href="composant/boutonsjs.xsl" />
	<xsl:include href="composant/input_hidden.xsl" />
	<xsl:include href="composant/input_date_seul.xsl" />
	
	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="grille_CommandesEmballages"/>
	</xsl:template>

	<xsl:template match="target">
	
	<!--  On vide la colonne de gauche et on met une image d'emballage -->
		<div class="geoTarget" id="geoColonneGauche">
			<div>
				<img style="margin-top:50px;margin-left:20px" height="120" width="190" src="images/emballage.jpg" border="0" ></img>			
			</div>
		</div>

		<div id="geoBack" class="geoTarget"> <!--  geoBack vide : pas de lien de retour -->
		</div>
			
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates/>
		</div>


	</xsl:template>

	<xsl:template match="grille_CommandesEmballages">
		<rows>
		  <page><xsl:value-of select="@page"/></page>
		  <total><xsl:value-of select="@total"/></total>
		  <records><xsl:value-of select="@records"/></records>
		  <type><xsl:value-of select="@type"></xsl:value-of></type>
		  <onglet><xsl:value-of select="@onglet"></xsl:value-of></onglet>
		  <grille><xsl:value-of select="@grille"></xsl:value-of></grille>
		  
		  <!--  gestion de l'entete de grille et d'autres cibles HTML -->
		  <!--  on force le traitement des elements qui sont sous la balise <target> -->
		  <!--  à cet endroit ces elements ne gênent pas la structure attendue pour la grille -->
		  <!--  ils seront exploités dans la fonction geoGridManageReponse pour etre injectes -->
		  <!--  dans le div dont l'id est celui la balise <target> -->

		  	<xsl:apply-templates select="/root/target"/>
			<xsl:apply-templates />
		</rows>
	</xsl:template>
	
	<xsl:template match="row">
		<row>
		<!--  id du row qui est la clé unique -->
		<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>

			<!--  Actions (accueille les boutons d'actions )-->
			<cell>
			<xsl:if test='cell[@id = "bouton_supprime"] = 1'>
				<![CDATA[<img onclick="geoGridDeleteRowEmballage('geoGridCommandesEmballages',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]>
			</xsl:if>
			</cell>		
			
			<!--  Numéro de commande qui est l'id du row -->
			<cell>
				<xsl:value-of select="@id"/>
			</cell>
			
			<!--  article -->
			<cell>
				<xsl:value-of select="cell[@id = 'article']"/>
			</cell>

			<!--  quantite -->
			<cell>
				<xsl:value-of select="cell[@id = 'qtt']"/>
			</cell>

			<!--  unité commande -->
			<cell>
				<xsl:value-of select="cell[@id = 'UC']"/>
			</cell>

			<!--  date liv souhaitee -->
			<cell>
				<xsl:value-of select="cell[@id = 'date_liv_station']"/>
			</cell>
			
			<!--  date liv prévue -->
			<cell>
				<xsl:value-of select="cell[@id = 'date_liv_prevue']"/>
			</cell>

			<!--  etat -->
			<cell>
				<xsl:value-of select="cell[@id = 'etat']"/>
			</cell>

			<!--  fournisseur -->
			<cell>
				<xsl:value-of select="cell[@id = 'fournisseur']"/>
			</cell>

			<!--  lieu -->
			<cell>
				<xsl:value-of select="cell[@id = 'lieu']"/>
			</cell>

			<!--  Autres Actions (accueille les boutons d'actions )-->
			<cell>
			<xsl:if test='cell[@id = "modifiable"] = 0'>
				<![CDATA[<img title="Consulter commande emballages" onclick="geoConsulterCommandeEmballages(']]><xsl:value-of select="@id"/><![CDATA[');" class="promoImageAction" src="images/flechebleuedroite.gif" />]]>
			</xsl:if>
			<xsl:if test='cell[@id = "modifiable"] = 1'>
				<![CDATA[<img title="Modifier commande emballages" onclick="geoModifierCommandeEmballages(']]><xsl:value-of select="@id"/><![CDATA[');" class="promoImageAction" src="images/flechebleuedroite.gif" />]]>
			</xsl:if>
			</cell>		
															
		</row>
	</xsl:template>
	
</xsl:stylesheet>
