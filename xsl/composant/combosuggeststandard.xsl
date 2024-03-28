<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="liste_drop">
	<div style="margin-bottom:5px;">
		<xsl:if test="count(item) != 0" >
	
				<td title="listeDrop" align="right" valign="bottom" >
					<xsl:value-of select="@lib" />:&#160;
				</td>
				<td valign="bottom">
				<select class="listeDropStandard ui-autocomplete-input ui-widget ui-widget-content ui-corner-left">  <!--  pour composant non jquery -->
				<xsl:if test="(@onchange !='')">
					<xsl:attribute name="onchange"><xsl:value-of select="@onchange" />();</xsl:attribute>
				</xsl:if>
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
					<xsl:apply-templates />
				</select>
				</td>
		</xsl:if>	
		<xsl:if test="count(item) = 0" >
		<td align="right">
			<xsl:value-of select="@none" />
		</td>
		<td>
		 
		</td>
		</xsl:if>		
			
</div>
	</xsl:template>
	
	<!--  liste deroulante dont les options ne sont pas fournies par le serveur -->
	<!--  mais récupérées en local -->
	<xsl:template match="liste_cache">
			<td  valign="top" title="listeCache" align="right">
				<xsl:value-of select="@lib" />:&#160;
			</td>
			<td valign="top">
			<input size="80" onfocus="this.value='';" >
				<xsl:attribute name="class">listeCache<xsl:value-of select="@name" /> ui-widget ui-widget-content ui-corner-all </xsl:attribute>
				<xsl:attribute name="name">ENTREE FORMULAIRE A_IGNORER</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="selected">
					<xsl:value-of select="@value" />
				</xsl:attribute>
			</input>
			<div class="geoAideInput">Cliquez dans le champ et entrez au moins 2 caractères ...</div>

			<input type="hidden">
				<xsl:attribute name="id"><xsl:value-of select="@name" />_hidden</xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="selected">
					<xsl:value-of select="@value" />
				</xsl:attribute>
			</input>			

			</td>
	</xsl:template>
	
	<!--  liste deroulante dont les options ne sont pas fournies par le serveur -->
	<!--  mais récupérées en local et qui s'affiche en pop-up avec un bouton -->
	<xsl:template match="liste_pop">
			<td  title="listeCache" align="right">
				<xsl:value-of select="@lib" />:&#160;
			</td>
			<td>
			<div nowrap='nowrap' class="desBoutons">	
						<input size="50" onfocus="this.value='';" class="inputText ui-widget ui-widget-content ui-corner-all" type="text" id="geoSearch" value="Chercher ici">
						<xsl:attribute name="id">search_<xsl:value-of select="@name" /></xsl:attribute>
						<xsl:attribute name="onKeyPress">
						if(event.keyCode == 13){geoGridSearchInjectHtml('search_<xsl:value-of select="@name" />','geojGridPop','geoDataEntrepot','entrepot',2);return false}
						</xsl:attribute>
						 </input>
						<input type="hidden" value="">
						<xsl:attribute name="id">search_<xsl:value-of select="@name" />_hidden</xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
						 </input>
							<a href="#">
							<xsl:attribute name="onclick">
							geoGridSearchInjectHtml('search_<xsl:value-of select="@name" />','geojGridPop','geoDataEntrepot','entrepot',2);
							</xsl:attribute>
							...
							</a>
				</div>
			</td>
	</xsl:template>
	
	<xsl:template match="item">
		<option>
			<xsl:attribute name="value">
				<xsl:value-of select="@value" />
			</xsl:attribute>
			<xsl:if test="@check">
				<xsl:attribute name="selected"></xsl:attribute>
			</xsl:if>
			<xsl:value-of select="@lib" />
		</option>
	</xsl:template>
</xsl:stylesheet>