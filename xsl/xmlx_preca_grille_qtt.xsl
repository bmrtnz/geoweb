<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/table.xsl" />
	<xsl:include href="composant/combosuggeststandard.xsl" />
	<xsl:include href="composant/context.xsl" />
	<xsl:include href="composant/texte.xsl" />
	<xsl:include href="composant/boutonsjs.xsl" />
	<xsl:include href="composant/input_hidden.xsl" />

	
	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="preca_grille_qtt"/>
	</xsl:template>

	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates/>
		</div>
		<!--  pas de back pour cette fenetre -->
		 <div id="geoBack" class="geoTarget">
		</div>
		
	</xsl:template>

	<xsl:template match="preca_grille_qtt">
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
		<xsl:attribute name="id"><xsl:value-of select="@preca_ref"/></xsl:attribute>

			<!--  Statut (vide en entrée) pour gérer les lignes nouvelles ou modifiées-->
			<cell></cell>
			<!--  Actions (accueille les boutons d'actions )-->
			<cell><![CDATA[<img onclick="geoGridDeleteRowStockPreca('geoGridStockPreca',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>		
			
			<!--  Catégorie -->
			<cell>
				<xsl:value-of select="cell[@id = 'choix']"/>
			</cell>
			
			<!--  couleur -->
			<cell>
				<xsl:value-of select="cell[@id = 'colo']"/>
			</cell>

			<!--  quantite -->
			<cell>
				<xsl:value-of select="cell[@id = 'qtt']"/>
			</cell>

			<!--  cal 216 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p216']"/>
			</cell>
							
			<!--  cal 198 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p198']"/>
			</cell>	
			
			<!--  cal 175 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p175']"/>
			</cell>	
			
			<!--  cal 163 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p163']"/>
			</cell>	
								
			
			<!--  cal 150 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p150']"/>
			</cell>	
								
			
			<!--  cal 138 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p138']"/>
			</cell>	
								
			
			<!--  cal 125 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p125']"/>
			</cell>	
								
			
			<!--  cal 113 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p113']"/>
			</cell>	
								
			
			<!--  cal 100 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p100']"/>
			</cell>	
								
			
			<!--  cal 88 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p88']"/>
			</cell>	
								
			
			<!--  cal 80 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p80']"/>
			</cell>	
								
			
			<!--  cal 72 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p72']"/>
			</cell>	
								
			
			<!--  cal 64 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p64']"/>
			</cell>	
								
			
			<!--  cal 56 -->
			<cell>
				<xsl:value-of select="cell[@id = 'p56']"/>
			</cell>	
								
			<cell>
				<xsl:value-of select="cell[@id = 'commentaire']"/>
			</cell>	
								
		</row>
	</xsl:template>
	
</xsl:stylesheet>
