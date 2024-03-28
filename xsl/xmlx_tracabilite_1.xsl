<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="composant/table.xsl" />
	<xsl:include href="composant/context.xsl" />
	<xsl:include href="composant/texte.xsl" />
	<xsl:include href="composant/boutonsjs.xsl" />
	<xsl:include href="composant/input-seul.xsl" />
	<xsl:include href="composant/input_hidden.xsl" />

	<xsl:output method="xml" encoding="UTF-8"></xsl:output>

	<xsl:template match="root">
			<xsl:apply-templates select="grille_traca"/>
	</xsl:template>

	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="grille_traca">
		<rows>
		  <page><xsl:value-of select="@page"/></page>
		  <total><xsl:value-of select="@total"/></total>
		  <records><xsl:value-of select="@records"/></records>
		  <type><xsl:value-of select="@type"></xsl:value-of></type>
		  <onglet><xsl:value-of select="@onglet"></xsl:value-of></onglet>
		  <grille><xsl:value-of select="@grille"></xsl:value-of></grille>
		  <ordref><xsl:value-of select="@ordref"></xsl:value-of></ordref>
		  
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
				
		<!--  pas d'id pour les titres il seront attribués automatiquement -->
			<xsl:if test='(@typeligne = "pal_data") or (@typeligne ="detail_data") or (@typeligne ="detail_pal_inter")'>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			</xsl:if>

			<!--  statut , non utilisé -->
			<cell>
			</cell>
			
			<!--   type ligne  -->
			<cell>
				<xsl:value-of select="@typeligne"/>
			</cell>
			<!--   ref traca -->
			<cell>
				<xsl:value-of select="cell[@id = 'reftraca']"/>
			</cell>
			
			<!--   numéro de palette -->
			<cell>
			<xsl:if test='(@cloture = "N") and (@typeligne ="pal_data")'>
				<xsl:value-of select="cell[@id = 'num_pal']"/> 			
			</xsl:if>			
			</cell>
		
			<xsl:if test='(@cloture = "N") and (@typeligne ="detail_data")'>
			<!--  Actions sur detail articles -->
			<cell><![CDATA[<img title="Supprimer article" onclick="geoGridDeleteRowChoixArticles('geoGridTraceabilite',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>			
			</xsl:if>

			<xsl:if test='(@cloture = "N") and (@typeligne ="pal_data")'>
			<!--  Actions sur palette -->
			<cell> <![CDATA[<img  title="Supprimer palette" onclick="geoGridDeleteRowPalette('geoGridTraceabilite',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>			
			</xsl:if>
			
			<xsl:if test='(@cloture = "N") and (@typeligne ="detail_pal_inter")'>
			<!--  Actions sur palette -->
			<cell><![CDATA[<img  title="Supprimer palette intermédiaire" onclick="geoGridDeleteRowPaletteInter('geoGridTraceabilite',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/delete.gif" />]]></cell>			
			</xsl:if>

			<xsl:if test='(@cloture = "O") or (@typeligne ="detail_titre")'>
			<!-- Ordre cloturé ou ligne de titre donc pas d'action possible -->
			<cell></cell>			
			</xsl:if>
			
			<!--  description article et palette-->
			<cell>
				<xsl:value-of select="cell[@id = 'desc']"/>
			</cell>	
				
			<!--  nombre colis ou palette au sol-->
			<cell>
				<xsl:value-of select="cell[@id = 'sol_colis']"/>
			</cell>	

			<!--  indicateur demi-palette-->
			<cell>
				<xsl:value-of select="cell[@id = 'demi_pal']"/>
			</cell>	
			
			<!--  poids brut total-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsbrut']"/>
			</cell>	
							
			<!--  poids net-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsnet']"/>
			</cell>	
			
			<!--  code arbo ou poids brut palette-->
			<cell>
				<xsl:value-of select="cell[@id = 'arbo_pds_pal']"/>
			</cell>	
			
			<!--  articles-->
			<cell>
				<xsl:value-of select="cell[@id = 'articles']"/>
			</cell>		
			
			<!--   orl ref -->
			<cell>
				<xsl:value-of select="cell[@id = 'orlref']"/>
			</cell>

			<!--  tare-->
			<cell>
				<xsl:value-of select="cell[@id = 'tare']"/>
			</cell>							
			<!--  poids net unité-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsnetunit']"/>
			</cell>	
			<!--  poids brut unité-->
			<cell>
				<xsl:value-of select="cell[@id = 'pdsbrutunit']"/>
			</cell>	
			
			<xsl:if test='@typeligne = "pal_data"'>
			<!--  Actions sur articles -->
			<cell>
			<![CDATA[<img title="Ajouter articles" onclick="geoGridDetailArticles('geoGridChoixArticles',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/plus.gif" />]]>			
			
			
			<![CDATA[<img title="Ajouter palette intermédiaire" onclick="geoGridAjouterPaletteInter('geoGridTraceabilite',']]><xsl:value-of select="@id"/><![CDATA[')" class="geoImageAction" src="images/pluspalette.gif" />]]>
			
			
			<![CDATA[<a href="PBServlet?httpPBCommand=ficpal_exp_traca&amp;ordref=]]><xsl:value-of select="//root/grille_traca/@ordref"/><![CDATA[&amp;reftraca=]]><xsl:value-of select="cell[@id = 'reftraca']"/><![CDATA[" target="geoIframe">
			<img title="Imprimer" onclick="geoPrepareIframe('geoIframe')" class="geoImageAction" src="images/print2.gif" /></a>]]>
			
			</cell>			
			</xsl:if>

			<xsl:if test='@typeligne != "pal_data"'>
			<!-- Sinon pas d'action -->
			<cell></cell>			
			</xsl:if>
			
			</row>
	</xsl:template>
	
</xsl:stylesheet>
