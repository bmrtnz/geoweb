<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:include href="xml_errormessage.xsl"/>	
<xsl:include href="composant/boutons_submit.xsl"/>	
<xsl:include href="composant/multiselect.xsl"/>
<xsl:include href="composant/context.xsl"/>
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<xsl:if test="not(target)">
				<target id="geoColonneMilieu">
		<div  class="diverror" id="geoErreur">
	<div class="titreError"> 
	<img style="cursor:hand" onclick="$('#geoErreur').fadeOut()"  src="images/close.gif"/></div>
			Pas de target definie
				</div>
				</target>
			</xsl:if>
			<xsl:if test="target">
			<xsl:apply-templates />
			</xsl:if>
			<!--  pas de back pour cette fenetre -->
			<div id="geoBack" class="geoTarget">
			</div>
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates />
		</div>
	</xsl:template>
<xsl:template match="form">
<form name="geoFormSaisie" id="geoFormSaisie" target=""  method="post" action="PBServlet">
<input type='hidden' name='httpPBCommand'>
<xsl:attribute name="value">
<xsl:value-of select="@url" />
</xsl:attribute>
</input>			
	<!-- gestion des boutons submit les 2 lignes sont nécessaires -->
<input type="hidden" name="which_button" value="" />
<xsl:apply-templates select="boutons" />
<div class="header1" wrap="nowrap">Expéditions : saisie du détail
</div>
	<!-- header avec ordre, total et input pour docs, immat et bon station -->
<xsl:for-each select="header">
	<div style="padding:2;border-color:gray;border:0;border-style:solid">
	<div class="boldText"><xsl:value-of select="t_ord_desc"/></div>
	<xsl:for-each select="total">
		<div class="boldText" nowrap='nowrap' id="total"> total :
		<label id="totpal"  class="boldTexT"> <xsl:value-of select="@totpal"/> </label> palettes - 
		<label id="totcol"  class="boldTexT"> <xsl:value-of select="@totcol"/> </label> colis - 
		<label id="totbrut" class="boldTexT"> <xsl:value-of select="@totbrut"/>  </label> pds brut -
		<label id="totnet"  class="boldTexT"> <xsl:value-of select="@totnet"/> </label> pds net	
		</div>
	</xsl:for-each>
	</div>
	<xsl:for-each select="inputs">
	<table>
	<tr>
		<xsl:for-each select="input">
			<td>
			<div style="padding:2;">
			<div class="labelInputTextHeader" ><xsl:value-of select="@lib" /></div>
			<input class="inputText" type="text">
			<!--  attributs name et id ont la meme valeur -->
			<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
			<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
			<xsl:attribute name="maxlength"><xsl:value-of select="@len" /></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
			<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>
			</input>
			</div>
			</td>
		</xsl:for-each>
	</tr>
	</table>
	</xsl:for-each>
	<br></br>
</xsl:for-each>
<xsl:for-each select="lignes">
	<table border="0" cellpadding="2" cellspacing="2">
		<!-- ligne de titre -->	
	<tr class="header2"><td>palettes</td><td>nb_colis</td><td>colis/pal</td><td>poids brut</td><td>poids net</td><td>vente qté/unité</td><td>achat qté/unité</td><td>CQ</td>	
	</tr>	
	<xsl:for-each select="detail">
		<tr>
			<td class="titreProduit" colspan="8"><xsl:value-of select="t_produit" /></td>
		</tr>
		<xsl:for-each select="inputs">
			<tr>
			<xsl:for-each select="input">
				<td nowrap="nowrap" valign="bottom">
					<span style="position:relative;top:-1" class="labelInputText" >
						<xsl:value-of select="@lib" />
						<xsl:text>&#xA;</xsl:text>
					</span>
					<input style="text-align:right" class="inputText" type="text">
						<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
						<!-- id est l'identifiant unique d'un element html -->
						<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>
						<!-- Test si l'attribut "disabled" est présent  -->
						<xsl:if test="@disabled='O'">
							<xsl:attribute name="disabled"></xsl:attribute>
							<xsl:attribute name="class='inputTextDisabled'"></xsl:attribute>
						</xsl:if>
						<xsl:attribute name="size"><xsl:value-of select="@size" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
						<xsl:attribute name="tabindex"><xsl:value-of select="@tabindex" /></xsl:attribute>	
						<xsl:attribute name="onchange">analyseChange(this.name,this.value);</xsl:attribute>			
					</input>		
				</td>
			</xsl:for-each>
			<xsl:for-each select="input_hidden">
				<input type="hidden">
					<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
					<!-- id est l'identifiant unique d'un element html -->	
					<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>	
				</input>
			</xsl:for-each>
			</tr>
		</xsl:for-each>
	</xsl:for-each>
	</table>
</xsl:for-each>
</form>
</xsl:template>	

</xsl:stylesheet>