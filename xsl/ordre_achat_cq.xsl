<xsl:stylesheet version="1.0"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="fof_general.xsl"/>
	<xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8"/>
	<xsl:decimal-format name="euro" decimal-separator="," grouping-separator="."/>
	<!--<xsl:param name="ref_doc"/>
	<xsl:param name="code_tiers"/>
	<xsl:param name="type_tiers"/>
	<xsl:param name="commentaires"/> -->
	<xsl:param name="current_date"/>
	<xsl:template match="EXP_ORDRE">
		<xsl:variable name="ref_doc" select="//root/doc/ref_doc"/>
		<xsl:variable name="code_tiers" select="//root/doc/code_tiers"/>
		<xsl:variable name="type_tiers" select="//root/doc/type_tiers"/>
		<xsl:variable name="commentaires" select="//root/doc/commentaires"/>
		<xsl:variable name="langue">FR</xsl:variable>
		<!-- impression de la récap interne d'un ordre (d'après commande station geoweb) -->
		<fo:root>
			<fo:layout-master-set>
				<!-- définition du support papier -->
				<fo:simple-page-master
					master-name="commande_station"
					page-height="21cm" page-width="29.7cm"
					margin-top="0.5cm"	margin-bottom="0.5cm"
					margin-left="0.5cm"	margin-right="0.5cm">
					<!-- Central part of page -->
					<fo:region-body
						region-name="xsl-region-body"
						column-count="1"
						margin-top="2.1cm"
						margin-bottom="1cm"
						margin-left="0.5cm"
						margin-right="0.5cm"/>
					<!-- Header -->
					<fo:region-before
						region-name="xsl-region-before"
						extent="2.1cm"/>
					<!-- Footer -->
					<fo:region-after
						region-name="xsl-region-after"
						extent="0.75cm"/>
					<!-- Gauche -->
					<fo:region-start
						region-name="xsl-region-start"
						extent="0.5cm"/>
					<!-- Droite -->
					<fo:region-end
						region-name="xsl-region-end"
						extent="0.5cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

		<!-- définition du contenu de la page (un seul type de page)  -->
			<fo:page-sequence master-reference="commande_station"
				force-page-count="no-force" initial-page-number="1">

			<!-- Bloc du header : no ordre, pagination, ref doc, time satmp -->
				<fo:static-content flow-name="xsl-region-before">
					<fo:table table-layout="fixed"  width="100%" border-collapse="collapse">
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="45%"/>
						<fo:table-column column-width="40%"/>
						<fo:table-body font-family="sans-serif" font-size="10pt"	font-weight="normal">
							<fo:table-row>
								<xsl:call-template name="id_societe"/>
								<xsl:call-template name="doc_date_page">
									<xsl:with-param name="ref_doc" select="$ref_doc"/>
									<xsl:with-param name="cur_date" select="$current_date"/>
								</xsl:call-template>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				<!-- bloc pour titre ordre pays, no ordre , date courante -->
					<fo:block font-size="12.0pt" font-family="sans-serif"
						padding-before="2.0pt" padding-after="2.0pt"
						space-before="2.0pt" text-align="center" border="1pt solid black">
						<xsl:text>commande (résumé) </xsl:text>
						<xsl:value-of select="geo_ordre/row/pay_code"/>
						<xsl:text>/</xsl:text>
						<xsl:value-of select="geo_ordre/row/nordre"/>
						<xsl:call-template name="cli_trp_date_page">
							<xsl:with-param name="dep_date" select="geo_ordre/row/depdatp"/>
						</xsl:call-template>
					</fo:block>
				</fo:static-content>

				<!-- Define the contents of the footer. -->
				<fo:static-content flow-name="xsl-region-after">
				<fo:block></fo:block>
<!--					<xsl:call-template name="conditions_fourni"/> -->
				</fo:static-content>

			<!-- le corps de page (body) -->
				<fo:flow flow-name="xsl-region-body">
					<!-- rubriques d'entete  de la commande (ce n'est pas le header fo mais le début du corps de page) -->
					<fo:table table-layout="fixed"  width="100%" border-collapse="collapse" font-family="sans-serif" >
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
						<fo:table-body font-family="sans-serif" font-size="10pt"	font-weight="normal" background-color="rgb(255,255,255)">
							<fo:table-row >
								<xsl:call-template name="livraison">
									<xsl:with-param name="langue" select="$langue"/>
								</xsl:call-template>
							</fo:table-row >
							<fo:table-row >
								<xsl:call-template name="transport">
									<xsl:with-param name="langue" select="$langue"/>
								</xsl:call-template>
							</fo:table-row>
							<xsl:if test="geo_ordre/row/ttr_desc!=''">
								<fo:table-row>
									<xsl:call-template name="type_transport">
										<xsl:with-param name="langue" select="$langue"/>
									</xsl:call-template>
								</fo:table-row>
							</xsl:if>
							<fo:table-row>
								<xsl:call-template name="incoterm">
									<xsl:with-param name="langue" select="$langue"/>
								</xsl:call-template>
							</fo:table-row>
							<xsl:if test="geo_ordre/row/ref_cli!=''">
								<fo:table-row>
									<xsl:call-template name="ref_client">
										<xsl:with-param name="langue" select="$langue"/>
									</xsl:call-template>
								</fo:table-row>
							</xsl:if>
							<fo:table-row>
								<fo:table-cell text-decoration="underline" padding="1pt">
									<fo:block>instructions</fo:block>
								</fo:table-cell>
								<fo:table-cell padding="1pt">
									<fo:block>
										<xsl:if	test="geo_ordre/row/instructions_logistiqu!=''">
											<xsl:value-of select="geo_ordre/row/instructions_logistiqu"/>
											<xsl:text> </xsl:text>
										</xsl:if>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
							<xsl:if test="geo_ordre/row/dev_code!='EUR'">
								<fo:table-row>
									<fo:table-cell text-decoration="underline" padding="1pt">
										<fo:block>devise</fo:block>
									</fo:table-cell>
									<fo:table-cell padding="1pt">
										<fo:block>
											<xsl:value-of select="geo_ordre/row/dev_code"/>
											<xsl:if test="geo_ordre/row/dev_code='USD'">
												<xsl:text> taux : </xsl:text>
												<xsl:value-of select="geo_ordre/row/dev_tx"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
							<xsl:if test="geo_ordre/row/version_ordre!='001'">
								<fo:table-row>
									<xsl:call-template name="annule_et_remplace">
										<xsl:with-param name="langue" select="$langue"/>
									</xsl:call-template>
								</fo:table-row>
							</xsl:if>
							<xsl:if test="$commentaires!=''">
								<fo:table-row>
									<xsl:call-template name="commentaires">
										<xsl:with-param name="commentaires" select="$commentaires"/>
									</xsl:call-template>
								</fo:table-row>
							</xsl:if>
							<fo:table-row >
								<fo:table-cell><fo:block color="white">.</fo:block></fo:table-cell>
							</fo:table-row >
						</fo:table-body>
					</fo:table>

				<!--- les éléments logistiques -->
					<fo:table table-layout="fixed"  width="100%" border-collapse="collapse">
						<!-- définition des colonnes -->
						<fo:table-column column-width="9%" />
						<fo:table-column column-width="11%"/>
						<fo:table-column column-width="11%"/>
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="49%"/>
						<!-- titres des colonnes -->
						<fo:table-header font-family="sans-serif" font-size="10pt" font-weight="bold">
							<fo:table-row background-color="rgb(255,246,206)">
								<!-- background-color="rgb(250,235,215)"> antique white -->
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>fournisseur</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>départ</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>cloture</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>pal sol</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>100x120</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>80x120</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>60x80</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>groupage / instructions / immatriculations / certificats</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>
						<!-- pour chaque élément logistique -->
						<fo:table-body font-family="sans-serif" font-size="10pt" font-weight="normal" background-color="rgb(255,255,255)">
							<xsl:for-each
								select="geo_ordlog/row">
								<xsl:sort select="fou_code"/>
								<fo:table-row >
									<fo:table-cell text-align="left" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:value-of select="fou_code"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:call-template name="my_date">
												<xsl:with-param name="datex" select="datdep_fou_p"/>
											</xsl:call-template>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="flag_exped_fournni='O'">
												<xsl:value-of select="datdep_fou_r"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="pal_nb_sol!='0'">
												<xsl:value-of select="pal_nb_sol"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="pal_nb_pb100x120!='0'">
												<xsl:value-of select="pal_nb_pb100x120"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="pal_nb_pb80x120!='0'">
												<xsl:value-of select="pal_nb_pb80x120"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="pal_nb_pb60x80!='0'">
												<xsl:value-of select="pal_nb_pb60x80"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="left" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="grp_code!=''">
												<xsl:text>groupage chez </xsl:text>
												<xsl:value-of select="grp_code"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:if test="trp_code!=''">
												<xsl:text>par </xsl:text>
												<xsl:value-of select="trp_code"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:if test="grp_code!=''">
												<xsl:text>le </xsl:text>
												<xsl:call-template name="my_date">
													<xsl:with-param name="datex" select="datdep_grp_p"/>
												</xsl:call-template>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:if test="ref_logistique!=''">
												<xsl:value-of select="ref_logistique"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:if test="ref_document!=''">
												<xsl:value-of select="ref_document"/>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:if test="instructions!=''">
												<xsl:value-of select="instructions"/>
												<xsl:text> </xsl:text>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:for-each>
							<fo:table-row >
								<fo:table-cell><fo:block color="white">.</fo:block></fo:table-cell>
							</fo:table-row >
						</fo:table-body>
					</fo:table>


				<!-- les lignes de commande -->
					<fo:table table-layout="fixed"  width="100%" border-collapse="collapse">
						<!-- définition des colonnes -->
						<fo:table-column column-width="24%" />
						<fo:table-column column-width="9%"/>
						<fo:table-column column-width="4%"/>
						<fo:table-column column-width="4%"/>
						<fo:table-column column-width="4%"/>
						<fo:table-column column-width="4%"/>
						<fo:table-column column-width="4%"/>
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="6%"/>
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="6%"/>
						<fo:table-column column-width="7%"/>
						<!-- titres des colonnes -->
						<fo:table-header font-family="sans-serif" font-size="10pt" font-weight="bold">
							<fo:table-row background-color="rgb(255,246,206)">
								<!-- background-color="rgb(250,235,215)"> antique white -->
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>produit</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>fournisseur</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>pal cde</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>pal exp</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>x</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>col cde</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>col exp</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>pds net</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>x</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>x</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>x</fo:block>
								</fo:table-cell>
								<fo:table-cell border="1pt solid black"	padding="1pt" text-align="center">
									<fo:block>unité</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-header>

						<fo:table-footer font-family="sans-serif" font-size="10pt" font-weight="normal" background-color="rgb(255,255,255)">
							<fo:table-row >
								<fo:table-cell text-align="center" border="0pt solid black"	padding="1pt">
									<fo:block></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:text>TOTAL</xsl:text></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:value-of select='sum(geo_ordlig/row/cde_nb_pal)'/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:value-of select='sum(geo_ordlig/row/exp_nb_pal)'/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:value-of select='sum(geo_ordlig/row/cde_nb_col)'/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:value-of select='sum(geo_ordlig/row/exp_nb_col)'/></fo:block>
								</fo:table-cell>
								<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
									<fo:block><xsl:value-of select='sum(geo_ordlig/row/exp_pds_net)'/></fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-footer>

						<!-- pour chaque ligne -->
						<fo:table-body font-family="sans-serif" font-size="10pt" font-weight="normal" background-color="rgb(255,255,255)">
							<xsl:for-each
								select="geo_ordlig/row">
								<fo:table-row keep-together.within-page="always">
									<xsl:call-template name="produit_abrege"/>
									<fo:table-cell text-align="left" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:value-of select="fou_code"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="cde_nb_pal!='0'">
												<xsl:value-of select="cde_nb_pal"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="exp_nb_pal!='0'">
												<xsl:value-of select="exp_nb_pal"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="pal_nb_col!='0'">
												<xsl:value-of select="pal_nb_col"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="cde_nb_col!='0'">
												<xsl:value-of select="cde_nb_col"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:if test="exp_nb_col!='0'">
												<xsl:value-of select="exp_nb_col"/>
											</xsl:if>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:value-of select="exp_pds_net"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block></fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block></fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block></fo:block>
									</fo:table-cell>
									<fo:table-cell text-align="center" border="1pt solid black"	padding="1pt">
										<fo:block>
											<xsl:value-of select="ach_bta_code"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:for-each>
						</fo:table-body>

						</fo:table>

					<!-- personnes à contacter -->
					<xsl:call-template name="suivi_ordre">
						<xsl:with-param name="langue" select="$langue"/>
					</xsl:call-template>
					<xsl:apply-templates/>
					<fo:block id="theEnd" />
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>