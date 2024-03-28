<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<!-- template à utiliser pour des boutons dans des formulaires flottants-->
<!-- avec modification dynamique de la target -->
<xsl:template match="boutons">
<td>
	<div class="desBoutons" nowrap='nowrap'>
	<xsl:for-each select="bouton_submit">
       <xsl:choose>
          <xsl:when test="(@target='pdf') or (@target='file')">
          <!-- si le bouton fait appel à du PDF ou autre fichier, c'est une soumission de formulaire standard sans appel AJAX -->
          <!--  la target du formulaire est mise à jour dynamiquement pour etre l'iframe -->
				<a>
				<xsl:if test="(@target='file')">
					<xsl:attribute name="onclick">geoAfficheMessage();document.geoFormSaisieFlottant.target='geoIframeFile';
					geoPrepareIframe('geoIframeFile');
					document.geoFormSaisieFlottant.which_button.value='<xsl:value-of select="@url" />';
					document.geoFormSaisieFlottant.submit()
					</xsl:attribute>					
				</xsl:if>
				<xsl:if test="(@target='pdf')">
					<xsl:attribute name="onclick">
					geoAfficheMessage();
					geoPrepareIframe('geoIframe');
					document.geoFormSaisieFlottant.which_button.value='<xsl:value-of select="@url" />';
					geoRequeteDepuisFormulaire('geoIframe','geoFormSaisieFlottant','<xsl:value-of select="@push"/>');
					</xsl:attribute>
					<xsl:attribute name="target">geoIframe</xsl:attribute>								
				</xsl:if>
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:value-of select="@id"/>
			   </a>
              </xsl:when>
          <xsl:when test="(@target='close')">
          <!-- si le bouton fait appel à du PDF ou autre fichier, c'est une soumission de formulaire standard sans appel AJAX -->
          <!--  la target du formulaire est mise à jour dynamiquement pour etre l'iframe -->
				<a>
				    <xsl:attribute name="href">#</xsl:attribute>
					<xsl:attribute name="onclick">
					<!--  fermeture du dialog flottant -->
					$('.geoContainerFlottant').dialog('close');
					</xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:value-of select="@id"/>
			   </a>
              </xsl:when>
          <xsl:otherwise>
          <!--  bouton à gérer par un appel AJAX pour soumettre le formulaire -->
				<a>
			    <xsl:attribute name="href">#</xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				<xsl:attribute name="onclick">geoAfficheMessage();
					document.geoFormSaisieFlottant.which_button.value='<xsl:value-of select="@url" />'; manageSubmit('geoFormSaisieFlottant');$('.geoContainerFlottant').dialog('close');
				</xsl:attribute>				
				<xsl:value-of select="@lib"/>
			   </a>
     </xsl:otherwise>
        </xsl:choose>
	</xsl:for-each>
	</div>
	</td>
</xsl:template>
</xsl:stylesheet>