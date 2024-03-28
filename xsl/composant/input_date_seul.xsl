<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="input_date">
						<td class="titreListe" align="right">
							<xsl:value-of select="@lib" />
						</td>
						<td class="titreListe">
		<input class="jcalendrier ui-widget ui-widget-content ui-corner-all"  type="text" >
			<xsl:attribute name="id"><xsl:value-of select="@name" /></xsl:attribute>	
			<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>	
			<xsl:attribute name="name"><xsl:value-of select="@name" /></xsl:attribute>
		</input>
		<!-- si l'attribue value_heure est
		 présent on génère un champ de saisie pour l'heure -->
		<xsl:if test="@value_heure">
			Heure: <input  onKeyPress="if(event.keyCode == 13)return false;" class="timePicker inputText ui-widget ui-widget-content ui-corner-all" type="text">
				<xsl:attribute name="name">heure_<xsl:value-of select="@name" />	</xsl:attribute>
				<xsl:attribute name="id">heure_<xsl:value-of select="@name" /></xsl:attribute>
				<xsl:attribute name="size">5</xsl:attribute>
				<xsl:attribute name="maxlength">5</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@value_heure" /></xsl:attribute>
			</input>
		</xsl:if>
		</td>
	</xsl:template>
</xsl:stylesheet>
