<?xml version="1.0" encoding="ISO-8859-1"?>
<!--  feuille de style obsolet, n'est plus utilisée -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
	<xsl:param name="imageserver" />
	<xsl:template match="root">
		<!-- la balise root est traduite en un element englobant correspondant au fragment html genere -->
		<div class="geoRoot">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!-- pour chaque target on va relancer les template après avoir conservé l'id de la target -->
	<!-- on garde une balise <target> qui va englober chaque fragment HTML-->
	
	<xsl:template match="target">
		<div class="geoTarget">
				<xsl:attribute name="id"><xsl:value-of select="@id"></xsl:value-of></xsl:attribute>
				<table>
					<tr>
						<td>
							<div class="header1" style="text-align:center">
								<xsl:value-of select="titre" />
							</div>
						</td>
					</tr>
					<xsl:for-each select="photo">
						<tr>
							<td>
								<div class="header1" align="left">
									<xsl:value-of select="@titre" />
								</div>
							</td>
						</tr>
						<tr>
							<td>
								<div class="photo">
									<img border="0" align="left" alt="aucune image">
										<xsl:attribute name="src">
											<xsl:value-of select="$imageserver"/>/
											<xsl:value-of select="@img"/>
										</xsl:attribute>
									</img>
								</div>
							</td>
						</tr>
					</xsl:for-each>
					<tr>
						<td>
							<div style="text-align:left">
								<a href="#" onclick="geoRestoreHistory()"  >
									<img src="images/fermer-on.gif" style="cursor:hand" onmouseover="this.src='images/fermer.gif'" onmouseout="this.src='images/fermer-on.gif'" border="0" ></img>
								</a>
							</div>
						</td>
					</tr>
				</table>
		</div>
	</xsl:template>
</xsl:stylesheet>