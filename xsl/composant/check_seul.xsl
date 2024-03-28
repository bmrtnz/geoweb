<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:template match="liste_check">
		<td>
		<div class="titrecheck">
			<xsl:value-of select="@lib" />
		</div>
		</td>
		<td>
		<xsl:for-each  select="item">
			<div>
				<xsl:choose>
					<xsl:when test="@check='checked'">
						<input type="checkbox" checked="Y">
							<xsl:attribute name="name">
								<xsl:value-of select="@name"/>
							</xsl:attribute>
							<label class="inputchecklabel">
								<xsl:value-of select="@lib"/>
							</label>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<input type="checkbox">
							<xsl:attribute name="name">
								<xsl:value-of select="@name"/>
							</xsl:attribute>
							<label class="inputchecklabel">
								<xsl:value-of select="@lib"/>
							</label>
						</input>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
					</td>
	</xsl:template>
</xsl:stylesheet>