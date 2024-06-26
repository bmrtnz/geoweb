<xsl:stylesheet version="1.0"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<!-- Page body -->
	<xsl:template name="page_body">
		<xsl:variable name="PrintDate" select="//root/doc/Date"/>
		<fo:block font-family="sans-serif" font-size="6pt" font-weight="normal"><xsl:text>Planning généré : </xsl:text><xsl:value-of select='$PrintDate'/></fo:block>
		<fo:block font-size="8pt" color="#ffffff"><xsl:text>blank</xsl:text></fo:block>
		<xsl:call-template name="table_header"/>
		<xsl:call-template name="table_detail"/>
	</xsl:template>

	<xsl:template name="table_header">
		<fo:table border-collapse="collapse">
			<fo:table-column column-width="2.0cm"/>
			<xsl:for-each select="//root/header/HeaderLine/Column"> 
				<xsl:choose>
					<xsl:when test="position()='1'">
						<fo:table-column column-width="6.0cm"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:table-column column-width="2.0cm"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each> 
			<fo:table-body font-family="sans-serif" font-size="6pt" font-weight="normal">
				<xsl:for-each select="//root/header/HeaderLine"> 
					<fo:table-row >
						<xsl:if test="position()='1'">
							<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" display-align="center" number-rows-spanned='5' font-weight="bold"><fo:block><xsl:text>TESCO DIRECT</xsl:text></fo:block></fo:table-cell>
						</xsl:if>
						<xsl:for-each select="Column"> 
							<xsl:choose>
								<xsl:when test="position()='1'">
									<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="right" display-align="center" background-color="#FFFFFF" font-weight="bold"><fo:block><xsl:value-of select='Value'/><xsl:text> : </xsl:text></fo:block></fo:table-cell>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="BackColor='true'">
											<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" display-align="center" background-color="#AAAAAA"><fo:block><xsl:value-of select='Value'/></fo:block></fo:table-cell>
										</xsl:when>
										<xsl:otherwise>
											<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" display-align="center" background-color="#DDDDDD"><fo:block><xsl:value-of select='Value'/></fo:block></fo:table-cell>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each> 
					</fo:table-row>
				</xsl:for-each> 
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	
	<xsl:template name="table_detail">
		<xsl:variable name="NbrColumns" select="//root/header/HeaderNbrCol"/>
		<fo:table border-collapse="collapse">
			<fo:table-column column-width="2.0cm"/>
			<fo:table-column column-width="0.8cm"/>
			<fo:table-column column-width="2.2cm"/>
			<fo:table-column column-width="1.0cm"/>
			<fo:table-column column-width="1.0cm"/>
			<fo:table-column column-width="1.0cm"/>
			<xsl:for-each select="//root/header/HeaderLine/Column"> 
				<fo:table-column column-width="2.0cm"/>
			</xsl:for-each> 
			<fo:table-body>
				<fo:table-row font-family="sans-serif" font-size="6pt" font-weight="bold">
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Colis</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Ref art.</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Art Desc</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Calibre</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Nbr fruits</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" text-align="center" background-color="#AAAAAA"><fo:block><xsl:text>Etiquetage</xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" border="0.5pt solid black" number-columns-spanned="{$NbrColumns}"><fo:block><xsl:text></xsl:text></fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:for-each select="//root/Lines/Colis"> 
					<!-- <xsl:variable name="NbrArticle" select="NbrArt"> -->
					<fo:table-row font-family="sans-serif" font-size="6pt" font-weight="normal">
						<fo:table-cell padding="1pt" text-align="center" display-align="center" border="0.5pt solid black" number-rows-spanned="{NbrArt+2}"><fo:block><xsl:value-of select='ColDesc'/></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<xsl:for-each select="LinePalCol/PalCol">
							<fo:table-cell padding="1pt" text-align="center" display-align="center" border="0.5pt solid black"><fo:block><xsl:value-of select='Value'/></fo:block></fo:table-cell>
						</xsl:for-each> 
					</fo:table-row>
					<fo:table-row font-family="sans-serif" font-size="6pt" font-weight="normal">
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<xsl:for-each select="LineDLV/DLV">
							<fo:table-cell padding="1pt" text-align="center" display-align="center" border="0.5pt solid black"><fo:block><xsl:value-of select='Value'/></fo:block></fo:table-cell>
						</xsl:for-each> 
					</fo:table-row>
					<xsl:for-each select="Article">
					<fo:table-row font-family="sans-serif" font-size="6pt" font-weight="normal">
						<fo:table-cell padding="1pt" text-align="center" display-align="center" border="0.5pt solid black"><fo:block><xsl:value-of select='ArtRef'/></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" text-align="center" display-align="center" border="0.5pt solid black"><fo:block><xsl:value-of select='ArtDesc'/></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black"><fo:block></fo:block></fo:table-cell>
						<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black" number-columns-spanned="{$NbrColumns}"><fo:block></fo:block></fo:table-cell>
					</fo:table-row>
					</xsl:for-each> 
				</xsl:for-each> 
				<fo:table-row font-family="sans-serif" font-size="6pt" font-weight="bold">
					<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black" background-color="#AAAAAA" text-align="right"><fo:block><xsl:text>Total palettes : </xsl:text></fo:block></fo:table-cell>
					<fo:table-cell padding="1pt" display-align="center" border="0.5pt solid black" background-color="#AAAAAA" number-columns-spanned="5"><fo:block><xsl:value-of select='//root/Lines/LineTotal/TotalPal/Value'/></fo:block></fo:table-cell>
					<xsl:for-each select="//root/Lines/LineTotal/PalCol">
						<fo:table-cell background-color="#DDDDDD" padding="1pt" text-align="center" display-align="center" border="0.5pt solid black"><fo:block><xsl:value-of select='Value'/></fo:block></fo:table-cell>
					</xsl:for-each> 
				</fo:table-row>
			</fo:table-body>
		</fo:table>
	</xsl:template>

</xsl:stylesheet>
