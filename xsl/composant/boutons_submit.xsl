<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<!-- template à utiliser pour des boutons dans des formulaires -->
<!-- avec modification dynamique de la target -->
<xsl:template match="boutons">
	<div class="desBoutons" nowrap='nowrap'>
		<xsl:apply-templates/>
	</div>
</xsl:template>

<xsl:template match="bouton_submit">
       <xsl:choose>
          <xsl:when test="(@target='pdf') or (@target='file')">
          <!-- si le bouton fait appel à du PDF ou autre fichier, c'est une soumission de formulaire standard sans appel AJAX -->
          <!--  la target du formulaire est mise à jour dynamiquement pour etre l'iframe -->
				<a style="margin-bottom:5px">
				<xsl:if test="(@target='file')">
					<xsl:attribute name="onclick">geoAfficheMessage();document.geoFormSaisie.target='geoIframeFile';
					geoPrepareIframe('geoIframeFile');
					document.geoFormSaisie.which_button.value='<xsl:value-of select="@url" />';
					document.geoFormSaisie.submit()
					</xsl:attribute>					
				</xsl:if>
				<xsl:if test="(@target='pdf')">
					<xsl:attribute name="onclick">
					geoAfficheMessage();
					geoPrepareIframe('geoIframe');
					document.geoFormSaisie.which_button.value='<xsl:value-of select="@url" />';
					geoRequeteDepuisFormulaire('geoIframe','geoFormSaisie','<xsl:value-of select="@push"/>');
					</xsl:attribute>
					<xsl:attribute name="target">geoIframe</xsl:attribute>								
				</xsl:if>
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:value-of select="@id"/>
			   </a>
              </xsl:when>
          <xsl:otherwise>
          <!--  bouton à gérer par un appel AJAX pour soumettre le formulaire -->
				<a style="margin-bottom:5px">
			    <xsl:attribute name="href">#</xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:attribute name="onclick">geoAfficheMessage();
					document.geoFormSaisie.which_button.value='<xsl:value-of select="@url" />'; manageSubmit('geoFormSaisie','<xsl:value-of select="@push"/>');
				</xsl:attribute>				
				<xsl:value-of select="@id"/>
			   </a>
     </xsl:otherwise>
        </xsl:choose>

</xsl:template>

</xsl:stylesheet>