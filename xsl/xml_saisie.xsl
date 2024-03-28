<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:include href="xml_errormessage.xsl" />
	<xsl:include href="composant/check.xsl" />
	<xsl:include href="composant/combo.xsl" />
	<xsl:include href="composant/boutons_submit.xsl" />
	<xsl:include href="composant/input_date.xsl" />
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="root">
	<xsl:apply-templates select="msgs" />
	
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<xsl:if test="not(target)">
				<div class="geoTarget" id="geoColonneMilieu">
					<div  class="diverror" id="geoErreur">
						<div class="titreError"> 
							<img style="cursor:hand" onclick="$('#geoErreur').fadeOut()"  src="images/close.gif"/>
						</div>
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

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <div> de class geoTarget qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
			<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!--  Template pour le formulaire de saisie  -->
	<xsl:template match="form">
		<!-- formulaire -->
		<form target="" name="geoFormSaisie" id="geoFormSaisie" method="post" action="PBServlet">
			<input type='hidden' name='httpPBCommand'>
			<xsl:attribute name="value">
				<xsl:value-of select="@url" />
			</xsl:attribute>
			</input>
			<!-- titre -->
			<xsl:for-each select="titre">
				<div class="header1">
					<!--  si attribut fermer est présent on affiche une croix -->
					<xsl:if test="@fermer">
						<div style="display:inline;">
							<img style="cursor:pointer;" border="0">
								<!-- Soumission formulaire via Ajax -->
								<xsl:attribute name="onclick">geoAfficheMessage();
									document.geoFormSaisie.which_button.value='b_quitter'; manageSubmit('geoFormSaisie');
								</xsl:attribute>
								<xsl:attribute name="src">images/step_back_button.jpg</xsl:attribute>
								<xsl:attribute name="title">Fermer et revenir à l'écran précédent</xsl:attribute>
								<xsl:attribute name="onmouseover">this.src='images/step_back_button.jpg';window.status='';return true</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src='images/step_back_button.jpg'</xsl:attribute>
							</img>
						</div>
						<div style="display:inline;position:relative;top:-5px">
							<xsl:value-of select="." />
						</div>
					</xsl:if>
					<xsl:if test="not(@fermer)">
						<xsl:value-of select="." />
					</xsl:if>
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
			<table>
				<!-- chaque input -->
				<xsl:apply-templates select="input_date" />
				<xsl:for-each select="input">
					<tr>
						<td class="myrow">
							<xsl:value-of select="@lib" /> :
						</td>
						<td>
							<input onKeyPress="if(event.keyCode == 13)return false;"
								class="inputText" type="text">
								<xsl:attribute name="name">
									<xsl:value-of select="@name" />
								</xsl:attribute>
								<xsl:attribute name="id">
									<xsl:value-of select="@name" />
								</xsl:attribute>
								<xsl:attribute name="size">
									<xsl:value-of select="@size" />
								</xsl:attribute>
								<xsl:attribute name="maxlength">
									<xsl:value-of select="@len" />
								</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="@value" />
								</xsl:attribute>
								<xsl:attribute name="tabindex">
									<xsl:value-of select="@tabindex" />
								</xsl:attribute>
							</input>
						</td>
					</tr>
				</xsl:for-each>
				<!-- chaque input PASSWORD -->
				<xsl:for-each select="password">
					<tr>
						<td class="myrow">
							<xsl:value-of select="@lib" /> :
						</td>
						<td>
							<input onKeyPress="if(event.keyCode == 13)return false;"
								class="inputText" type="password">
								<xsl:attribute name="name">
									<xsl:value-of select="@name" />
								</xsl:attribute>
								<!-- name sert aussi d'id pour les champs -->
								<xsl:attribute name="id">
									<xsl:value-of select="@name" />
								</xsl:attribute>
								<xsl:attribute name="size">
									<xsl:value-of select="@size" />
								</xsl:attribute>
								<xsl:attribute name="maxlength">
									<xsl:value-of select="@len" />
								</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="@value" />
								</xsl:attribute>
								<xsl:attribute name="tabindex">
									<xsl:value-of select="@tabindex" />
								</xsl:attribute>
							</input>
						</td>
					</tr>
				</xsl:for-each>
				
				<xsl:apply-templates select="liste_check" />
				<xsl:apply-templates select="liste_drop" />
				
			</table>

			<!-- gestion des boutons submit les 2 lignes sont nécessaires -->
			<input type="hidden" name="which_button" value="" />
			<xsl:apply-templates select="boutons" />

			<!-- comment -->
			<xsl:for-each select="comment">
				<br/><br/>
				<table>
				<xsl:for-each select="itemnew">
					<tr>
					<td class="myrow" style="font-weight:bold">
						<xsl:value-of select="ctitre"/>
					</td>
					<td class="myrow" style="color:rgb(255,0,0)" >
						<xsl:value-of select="cbody"/>
					</td>
					</tr>
				</xsl:for-each>
				<xsl:for-each select="item">
					<tr>
					<td class="myrow" style="font-weight:bold">
						<xsl:value-of select="ctitre"/>
					</td>
					<td class="myrow">
						<xsl:value-of select="cbody"/>
					</td>
					</tr>
				</xsl:for-each>
				</table>
			</xsl:for-each>
		</form>
		

	</xsl:template>
</xsl:stylesheet>
