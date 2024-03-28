<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
<!-- template à utiliser pour des boutons hors de formulaire -->
<!-- qui sont en fait des liens  (pas de soumission dans onclick-->
	<xsl:template match="boutons">
		<div class="titreListe" >
			<xsl:value-of select="@lib" />
		</div>
		<div class="desBoutons" nowrap='nowrap'>
				<!-- chaque bouton -->
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="bouton">
	       <xsl:choose>
         <xsl:when test="(@target='js')">
	         <a style="margin-bottom:5px" href="#">
						<xsl:attribute name="onclick"><xsl:value-of select="@url"/>()
						</xsl:attribute>	
				<xsl:value-of select="@lib"/>
			</a>				
		</xsl:when>
          <xsl:when test="(@target='pdf') or (@target='file')">
          <!-- si le bouton fait appel à du PDF, ou un autre type de fichier, c'est un appel standard sans AJAX -->
				<a style="margin-bottom:5px">
				<xsl:if test="(@target='file')">
					<xsl:attribute name="target">geoIframeFile</xsl:attribute>
					<xsl:attribute name="onclick">geoPrepareIframe('geoIframeFile','<xsl:value-of select="@push"/>');
					</xsl:attribute>					
				</xsl:if>
				<xsl:if test="(@target='pdf')">
					<xsl:attribute name="target">geoIframe</xsl:attribute>
					<xsl:attribute name="onclick">geoPrepareIframe('geoIframe','<xsl:value-of select="@push"/>');
					</xsl:attribute>					
				</xsl:if>
			    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:value-of select="@id"/>
			   </a>

         </xsl:when>
          <xsl:otherwise>
          <!--  bouton à gérer par un appel AJAX direct au serveur-->
			<a style="margin-bottom:5px" href="#">
				<xsl:attribute name="title"><xsl:value-of select="@lib"/></xsl:attribute>
				<xsl:attribute name="onclick">geoRequete('<xsl:value-of select="@url"/>','<xsl:value-of select="@push"/>');geoAfficheMessage();</xsl:attribute>
				<xsl:value-of select="@id"/>
			</a>
          </xsl:otherwise>
        </xsl:choose>
	
	</xsl:template>
	
</xsl:stylesheet>