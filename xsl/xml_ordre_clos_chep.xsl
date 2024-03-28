<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" encoding="ISO-8859-1"></xsl:output>
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
	<!-- identification de l'ordre - descriptifs -->
	<xsl:for-each select="header">
		<xsl:for-each select="titre">
			<table cellspacing="0" cellpadding="0" border="0" bordercolor="red">
				<tr class="mytitcol">
					<td><xsl:value-of select="."/></td>
				</tr>
			</table>
		</xsl:for-each>
		<table border="0" class="myrow">
		<xsl:for-each select="t_ord_desc">
			<tr><td>ordre</td>
			<td><xsl:value-of select="."/></td></tr>
		</xsl:for-each>
		<xsl:for-each select="documents">
			<tr><td>documents</td>
			<td><xsl:value-of select="."/></td></tr>
		</xsl:for-each>
		<xsl:for-each select="immatriculations">
			<tr><td>immatricul.</td>
			<td><xsl:value-of select="."/></td></tr>
		</xsl:for-each>
		<xsl:for-each select="fou_ref_doc">
			<tr><td>bon</td>
			<td><xsl:value-of select="."/></td></tr>
		</xsl:for-each>
		<xsl:for-each select="total">
			<tr><td>total</td>
			<td><xsl:value-of select="@totpal"/> palettes - <xsl:value-of select="@totcol"/> colis - <xsl:value-of select="@totbrut"/> pds brut - <xsl:value-of select="@totnet"/> pds net </td>
			</tr>
		</xsl:for-each>
		<xsl:for-each select="palettes">
			<tr><td>palettes</td>
			<td>au sol : <xsl:value-of select="@sol"/> - PB100x120 : <xsl:value-of select="@pb100x120"/> - PB80x120 : <xsl:value-of select="@pb80x120"/> - PB60x80 : <xsl:value-of select="@pb60x80"/></td>
			</tr>
		</xsl:for-each>
		</table>
	</xsl:for-each>
		<!-- on attaque les lignes -->
	<table border="0" >
		<tr><td style="border:#F4FCE0 solid 3px">
	<table border = "0" cellpadding="0" cellspacing="2">
			<!-- ligne de titre -->
		<tr class="header2" bordercolor="#c0c0c0">
			<td colspan="2">palettes</td>
			<td colspan="2">nb_colis</td>
			<td>colis/pal</td>
			<td>poids brut</td>
			<td>poids net</td>
			<td>vente qté/unité</td>
			<td>achat qté/unité</td>
			<td>pu achat</td>
			<td>contrôle qualité</td>
		</tr>
			<!-- pour chaque ligne -->
		<xsl:for-each select="lignes/detail">
				<!-- on affiche la description sur une ligne -->
			<xsl:for-each select="t_produit">
				<tr style="text-decoration:underline" class="myrowsmall">
				<td colspan="11"><xsl:value-of select="." /></td>
				</tr>
			</xsl:for-each>
			<tr class="myrow">
			<xsl:for-each select="cde_nb_pal">
				<td class="myrowsmall" style="font-style:italic" ></td>
			</xsl:for-each>
			<xsl:for-each select="exp_nb_pal">
				<td><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="cde_nb_col">
				<td class="myrowsmall" style="font-style:italic"></td>
			</xsl:for-each>
			<xsl:for-each select="exp_nb_col">
				<td><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="pal_nb_col">
				<td  align="center"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="exp_pds_brut">
				<td align="right"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="exp_pds_net">
				<td align="right"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="uf_vente">
				<td  align="right"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="uf_achat">
				<td align="right"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="ach_pu">
				<td align="right"><xsl:value-of select="."/></td>
			</xsl:for-each>
			<xsl:for-each select="geo_ordlig_cq_ref">
				<td><xsl:value-of select="."/></td>
			</xsl:for-each>
			</tr>
			<tr bordercolor="white">
				<!-- on affiche le reste sur une ligne (valeur cde lib, valeur exp input-->
			<xsl:for-each select="inputs/input">
									<td nowrap="nowrap" valign="bottom">
										<!-- on affiche valeur commande ou descriptif unité (si renseigné)-->
										<span style="position:relative;top:-1" class="labelInputText" >
											<xsl:value-of select="@lib" />
											<xsl:text>&#xA;</xsl:text>
										</span>
										<!-- champ à saisir avec valeur par défaut -->
										<input style="text-align:right;" class="inputText" type="text">
											<xsl:attribute name="name">
												<xsl:value-of select="@name" />
											</xsl:attribute>
											<xsl:attribute name="size">
												<xsl:value-of select="@size" />
											</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="@value" />
											</xsl:attribute>
											<xsl:attribute name="tabindex">
												<xsl:value-of select="@tabindex" />
											</xsl:attribute>
										</input>
									</td>
								</xsl:for-each>
							</tr>
						</xsl:for-each>
					</table>
					</td></tr>
			      </table>
					<!-- thats all -->
</div>
	</xsl:template>
</xsl:stylesheet>