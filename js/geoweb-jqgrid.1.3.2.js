/* variable globales pour differents contextes */
var editionLigneEnCours = false ;
var ligneEnCoursID = null;
var poidsbrutligneEnEdition = null;
var poidsnetligneEnEdition = null;
var poidspalligneEnEdition = null;


var globalAjoutLigneTraceEnCours = false;
var globalcompteur = 1;


//Fonction d'initialisation des combos dans une grille.
//Le corps est sorti de la fonction de création de la grille 
//car sinon la liste ne s'affiche pas ????????
// augmentation du timeout de 100 é 500 (pour couvrir le cas de liste assez longue
// PAS UILISE DANS GEOWEB, la seule liste étant celle des palette qui n'est pas longue
function geoGridComboInitData(elem)
{
	setTimeout(function()
	{
		$(elem).combobox({displayButton:false},{jqgrid:true},{minLength:1},{inputSize:18});
	},1);
}



/*********************************************************/

function beginEdition(rowid) {
	editionLigneEnCours = true;
	ligneEnCoursID = rowid ;
}

function beginEditionChoixArticles(rowid) {
	
	editionLigneEnCours = true;
	ligneEnCoursID = rowid;

	$("#" + rowid + "_" + "nbcol","#geoGridChoixArticles").change(function() {
		
		/* la cellule nb col a changé : on calcul le reste */
		var nbcolnew = $("#" + rowid + "_" + "nbcol").val();
		var row = jQuery("#geoGridChoixArticles").getRowData(rowid);	
		
		if( row.tare == "O") {
			var pdsnetunit = row.pdsnetunit.replace(",",".");
			var pdsbrutunit = row.pdsbrutunit.replace(",",".");
			
			var pdsnetcalcul = Math.round((nbcolnew * pdsnetunit)*100)/100;
			pdsnetcalcul = pdsnetcalcul + ""; /* pour transformer en string */
			var pdsnetcalculstring = pdsnetcalcul.replace(".",",");
			
			jQuery("#geoGridChoixArticles").setCell(rowid,'pdsnet',pdsnetcalculstring);
			
			var pdsbrutcalcul = Math.round((nbcolnew * pdsbrutunit)*100)/100;
			pdsbrutcalcul = pdsbrutcalcul + ""; /* pour transformer en string */
			var pdsbrutcalculstring = pdsbrutcalcul.replace(".",",");
			jQuery("#geoGridChoixArticles").setCell(rowid,'pdsbrut',pdsbrutcalculstring);		
		}
	});
		
}

function beginEditionTraceabilite(rowid) {
	editionLigneEnCours = true;
	ligneEnCoursID = rowid ;
	
	var row = jQuery("#geoGridTraceabilite").getRowData(rowid);
	poidsbrutligneEnEdition = $("#" + rowid + "_" + "poidsbrut").val();
	poidsnetligneEnEdition = $("#" + rowid + "_" + "poidsnet").val();
	poidspalligneEnEdition = $("#" + rowid + "_" + "arboOupoidspal").val();
	
	$("#" + rowid + "_" + "sol_colis","#geoGridTraceabilite").change(function() {
		
		/* la cellule sol_colis a changé : on calcul le reste */
		var sol_colisnew = $("#" + rowid + "_" + "sol_colis").val();
			
		
		if( row.tare == "O") {
			var poidsnetavant = row.poidsnet;
			var poidsbrutavant = row.poidsbrut;
			
			var pdsnetunit = row.pdsnetunit.replace(",",".");
			var pdsbrutunit = row.pdsbrutunit.replace(",",".");
			
			var pdsnetcalcul = Math.round((sol_colisnew * pdsnetunit)*100)/100;
			pdsnetcalcul = pdsnetcalcul + ""; /* pour transformer en string */
			var pdsnetcalculstring = pdsnetcalcul.replace(".",",");
			
			jQuery("#geoGridTraceabilite").setCell(rowid,'poidsnet',pdsnetcalculstring);
			
			var pdsbrutcalcul = Math.round((sol_colisnew * pdsbrutunit)*100)/100;
			pdsbrutcalcul = pdsbrutcalcul + ""; /* pour transformer en string */
			var pdsbrutcalculstring = pdsbrutcalcul.replace(".",",");
			jQuery("#geoGridTraceabilite").setCell(rowid,'poidsbrut',pdsbrutcalculstring);		
			geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidsbrutavant,pdsnetcalcul,pdsbrutcalcul);

		}
		});
		
}



/* utilisable pour grille sans spécificité */
function aftersaverow(rowid,rep) {
	editionLigneEnCours = false;
	ligneEnCoursID = null;
	
	// alert("fin edition");
}

/* utilisable pour de choix des articles*/
function aftersaverowChoixArticles(rowid,rep) {
	editionLigneEnCours = false;
	ligneEnCoursID = null;
	var row = jQuery("#geoGridChoixArticles").getRowData(rowid);	
	
	if( row.tare == "O") {
		var pdsnetunit = row.pdsnetunit.replace(",",".");
		var pdsbrutunit = row.pdsbrutunit.replace(",",".");
		
		var pdsnetcalcul = Math.round((row.nbcol * pdsnetunit)*100)/100; /* arrondi é 2 decimales */
		pdsnetcalcul = pdsnetcalcul + ""; /* pour transformer en string */
		var pdsnetcalculstring = pdsnetcalcul.replace(".",",");
		
		jQuery("#geoGridChoixArticles").setCell(rowid,'pdsnet',pdsnetcalculstring);

		
		var pdsbrutcalcul = Math.round((row.nbcol * pdsbrutunit)*100)/100;
		pdsbrutcalcul = pdsbrutcalcul + ""; /* pour transformer en string */
		var pdsbrutcalculstring = pdsbrutcalcul.replace(".",",");
		jQuery("#geoGridChoixArticles").setCell(rowid,'pdsbrut',pdsbrutcalculstring);
	}
	else
	{
		var pdsnet = row.pdsnet;
		var pdsbrut = row.pdsbrut;
		
		//jQuery("#geoGridChoixArticles").setCell(rowid,'pdsnet',pdsnet);
		//jQuery("#geoGridChoixArticles").setCell(rowid,'pdsbrut',pdsbrut); 
	}
	// alert("fin edition");
}

function aftersaverowTraceabilite(rowid,rep) {
	editionLigneEnCours = false;
	ligneEnCoursID = null;
	var row = jQuery("#geoGridTraceabilite").getRowData(rowid);	
	
	if( row.typeligne == "detail_data" && row.tare == "O") { /* c'est une ligne article pre-pesé */
		var pdsnetunit = row.pdsnetunit.replace(",",".");
		var pdsbrutunit = row.pdsbrutunit.replace(",",".");
		
		var poidsnetavant = row.poidsnet;
		var poidsbrutavant = row.poidsbrut;
		
		var pdsnetcalcul = Math.round((row.sol_colis * pdsnetunit)*100)/100; /* arrondi é 2 decimales */
		pdsnetcalcul = pdsnetcalcul + ""; /* pour transformer en string */
		var pdsnetcalculstring = pdsnetcalcul.replace(".",",");
		
		jQuery("#geoGridTraceabilite").setCell(rowid,'poidsnet',pdsnetcalculstring);

		
		var pdsbrutcalcul = Math.round((row.sol_colis * pdsbrutunit)*100)/100;
		pdsbrutcalcul = pdsbrutcalcul + ""; /* pour transformer en string */
		var pdsbrutcalculstring = pdsbrutcalcul.replace(".",",");
		jQuery("#geoGridTraceabilite").setCell(rowid,'poidsbrut',pdsbrutcalculstring);
		
		geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidsbrutavant,pdsnetcalcul,pdsbrutcalcul);

	} 
	
	if( row.typeligne == "detail_data" && row.tare != "O") { /* c'est une ligne article non pré-pesé */
		
		var poidsnetavant = poidsnetligneEnEdition;
		var poidsbrutavant = poidsbrutligneEnEdition;
		
		/* on prend les poids qui ont été rentrés à la main */
		var nouveaupoidsbrut = row.poidsbrut;
		var nouveaupoidsnet = row.poidsnet;
		
		geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidsbrutavant,nouveaupoidsnet,nouveaupoidsbrut);

	} 
	
	if( row.typeligne == "detail_pal_inter") {

		/* seul le poids palette  peut avoir été modifié, le poids net vaut toujours zéro*/
		/* donc le poids net avant modification c'est le poids brut actuel */		
		var poidsnetavant =  "0";
		var poidspalavant = poidspalligneEnEdition ; /* valeur memorisée quand on est rentré en edition */
		
		var nouveaupoidsnet = "0";
		var nouveaupoidspal = row.arboOupoidspal; /* nouveau poids de la palette */ 
		
		
		geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidspalavant,nouveaupoidsnet,nouveaupoidspal);

	}
	
	// alert("fin edition");
}

/**
 * Recalculer le poids total de la palette aprés la modification des poids d'un article
 * @param rowid
 */
function geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidsbrutavant,pdsnetnouveau,pdsbrutnouveau) {
	
	// récupérer la liste des ids de la grille
	var dataIDs = jQuery("#geoGridTraceabilite").getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	// on cherche la palette qui contient l'article
	var palette_courante_id;
	var palette_courante_row_data;
	for (var i = 0; i < dataIDs.length; i += 1) {
		var row = jQuery("#geoGridTraceabilite").getRowData(dataIDs[i]);
		/* si on est sur une ligne palette on memorise ses id et data */
		if(row.typeligne == "pal_data") {
			palette_courante_id = dataIDs[i];
			palette_courante_row_data = row;
		}
		
		if(dataIDs[i] == rowid) {
			/* on a trouvé l'article pour lequel les poids ont été recalculé*/
			/* pas la peine de continuer*/
			break;
		}

	}
	
	/* on recalcule le poids de la palette et on l'affecte */
	
	/* on passe les valeurs des poids en numérique */
	var poidsnetavant_num = poidsnetavant.replace(",",".");
	var poidsbrutavant_num = poidsbrutavant.replace(",",".");
	
	var pdsnetnouveau_num = parseFloat(pdsnetnouveau.replace(",","."));
	var pdsbrutnouveau_num = parseFloat(pdsbrutnouveau.replace(",","."));
	
	var difference_poidsnet = pdsnetnouveau_num - poidsnetavant_num;
	var difference_poidsbrut = pdsbrutnouveau_num - poidsbrutavant_num;
	
	/* valeurs actuelles de la palette en numerique */
	var poidsnetpaletteavant = parseFloat(palette_courante_row_data.poidsnet.replace(",","."));
	var poidsbrutpaletteavant = parseFloat(palette_courante_row_data.poidsbrut.replace(",","."));
	
	var poidsnetpaletteapres = poidsnetpaletteavant + difference_poidsnet;
	var poidsbrutpaletteapres = poidsbrutpaletteavant + difference_poidsbrut;
	
	/* on arrondi é 2 décimales */
	poidsnetpaletteapres = Math.round(poidsnetpaletteapres*100) / 100 ;
	poidsbrutpaletteapres= Math.round(poidsbrutpaletteapres*100) / 100 ;
	
	/* transformation en string */
	poidsnetpaletteapres = poidsnetpaletteapres + ""; /* pour transformer en string */
	var poidsnetpaletteapresstring = poidsnetpaletteapres.replace(".",",");

	poidsbrutpaletteapres = poidsbrutpaletteapres + ""; /* pour transformer en string */
	var poidsbrutpaletteapresstring = poidsbrutpaletteapres.replace(".",",");
	
	/* mise é jour avec les nouvelles valeur */
	jQuery("#geoGridTraceabilite").setCell(palette_courante_id,'poidsbrut',poidsbrutpaletteapresstring);
	jQuery("#geoGridTraceabilite").setCell(palette_courante_id,'poidsnet',poidsnetpaletteapresstring);
	
	/* on passe la statut à Modifié */
	$("#geoGridTraceabilite").setCell(palette_courante_id,'statut','M');

}

/* commun é toute les grilles */
function afterRestore(rowid) {
	editionLigneEnCours = false;
	ligneEnCoursID = null;
	// alert("fin edition");
}

/** on recoit des données XML correspondant é la grille é charger 
 * fonction generique 
 */
function geoGridManageReponse(response, status, xhr,serieOnglets) {
	geoAlert("geoGridManageReponse xhr = "+ xhr.responseXML + " status = " + status);
	
	/* on reinitialise les variables de contexte concernant l'édition des grilles */
	editionLigneEnCours = false ;
	ligneEnCoursID = null;
	
	/* gestion des message d'avertissement ou d'erreur */
	var nbMsg = manageReponseXML(response, status, xhr);
	if(nbMsg == -1) {
		/* le serveur a signale des erreurs sur la grille (code -1)*/
		/* one ne fait rien d'autre que masquer le composant d'attente*/
		  $('#geoMessage').dialog('close');
	} else {
		/* on s'assure d'avoir l'identifiant de la grille et de l'onglet */
		/* s'il ne sont pas passés en parametre, on les cherche dans le XML */
		
		var ongletID = $(response).find('onglet');
		geoAlert("ongletID.length = " + ongletID.length);
		if(ongletID.length > 0) {
			divContenuOngletId = ongletID.text();
		}
		geoAlert("ongletID = " + divContenuOngletId);
		
		
		var grille = $(response).find('grille');
		geoAlert("grille.length = " + grille.length);	
		
		var gridId = grille.text();
		geoAlert("gridId = " + gridId);
		
		var ordref = $(response).find('ordref');
		$("#ordref").val(ordref.text());

		 /* on vide le formulaire general */
		//$("#geoFormulaireGeneral").empty();
		
		/* on vide les champs cachés et la grille */
		/* car la reponse du serveur va les modifier */
		//$("#" +gridId + "Rows").val("");
		
		 
		$("#" + gridId).clearGridData();
		
		var pbcommande = $(response).find('pbcommande');
		
		// on met é jour le champ caché contenant la valeur de httpCommande
		$("#httpPBCommand").val(pbcommande.text());
		geoAlert("httpPBCommand = " +pbcommande.text());
		
		
		/* gestion de l'entete de grille et autres cibles html*/
		/*on cherche les div qui ont la classe geoTarget */
/* ils identifient des cibles (dans le cas de grille peut avoir geoEnteteGrille mais aussi le formulaire general, le contexte*/
var targets = $(response).find('div.geoTarget'); /* recherche directe dans response */
//alert("targets length : " + targets.length)


/* pour chaque target : on prend le contenu  de l'élément */
/* et on l'affecte  é l'élément qui a le méme id que la target */		
$(targets).each(function(index) {
    // geoAlert(index + ' : ' + $(this).text());
    var idCible = $(this).attr("id");
    geoAlert("idCible " + idCible);
    var contenu = $(this).children();
	//alert("content = " + contenu)
	//geoAlert("content = " + contenu.text());
	//geoAlert("contenu= " + contenu.html());
	
	$("#" + idCible).html(contenu.html());
	geoAlert("cible remplie (" + $("#" + idCible) + ")" );
	
	/* on recharge les composants eventuels */
	rechargerComposants(null);
	
    /* on rend la target visible */
	geoAlert("show target = " + idCible)
    $("#" + idCible).show();
	geoAlert("show target OK  " + idCible)

	
  });	

	/* affichage de la grille aprés affichage de l'entete */
	$("#" + gridId)[0].addXmlData(xhr.responseXML);
	geoAlert("addXmlData OK");
	
	/* si la grille est de type grille pop on affiche le container flottant associé et c'est tout */
	/* sinon on gére les différents d'affichage de grille sur l'écran principal */

	var type = $(response).find('type');
	var typeGrille=type.text()
		
	
	var gridId = grille.text();
	geoAlert("gridId = " + gridId);	
	
	if(typeGrille == "grillepop") {
		var divPopContainer = gridId + "ContainerPop" ;
		$("#" + divPopContainer).dialog('open');
	} else {

			$("#geoOnglets").fadeIn("slow");
			$("#geoColonneMilieu").hide();
			
			if(gridId == "geoGridStockPreca") {
				$("#geoColonneMilieuGrilleDem").hide();
				$("#geoColonneMilieuGrilleTraceabilite").hide();
				$("#geoColonneMilieuGrilleCommandesEmballages").hide();
				$("#geoColonneMilieuGrillePreca").show();
				$("#geoColonneMilieuGrilleControleQualite").hide();		

			} else if(gridId == "geoGridStockDem"){
				$("#geoColonneMilieuGrillePreca").hide();
				$("#geoColonneMilieuGrilleCommandesEmballages").hide();
				$("#geoColonneMilieuGrilleDem").show();
				$("#geoColonneMilieuGrilleTraceabilite").hide();
				$("#geoColonneMilieuGrilleControleQualite").hide();		

			} else if(gridId == "geoGridCommandesEmballages"){
				$("#geoColonneMilieuGrillePreca").hide();
				$("#geoColonneMilieuGrilleDem").hide();
				$("#geoColonneMilieuGrilleTraceabilite").hide();
				$("#geoColonneMilieuGrilleCommandesEmballages").show();
				$("#geoColonneMilieuGrilleControleQualite").hide();		

			}
			else if (gridId == "geoGridTraceabilite"){
				$("#geoColonneMilieuGrillePreca").hide();
				$("#geoColonneMilieuGrilleDem").hide();
				$("#geoColonneMilieuGrilleCommandesEmballages").hide();
				$("#geoColonneMilieuGrilleTraceabilite").show();	
				$("#geoColonneMilieuGrilleControleQualite").hide();		
			} 
			else if (gridId == "geoGridControleQualite"){
				$("#geoColonneMilieuGrillePreca").hide();
				$("#geoColonneMilieuGrilleDem").hide();
				$("#geoColonneMilieuGrilleCommandesEmballages").hide();
				$("#geoColonneMilieuGrilleTraceabilite").hide();		
				$("#geoColonneMilieuGrilleControleQualite").show();		
			}		
			else {
				alert("Grille inconnue");
			}
			 
			
			$("#geoIframeContainer").dialog('close');
			$("#geoLogin").empty();
			}
	}
}

/**
 * Destruction d'une ligne dans une grille stock preca sans confirmation et 
 * envoi de la demande au serveur
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowStockPreca(gridID, rowid){

	$('#' + gridID).delRowData(rowid);
	// on verifie si cette ligne n'était pas en edition
	if(editionLigneEnCours === true && rowid == ligneEnCoursID ) {
		editionLigneEnCours = false;
		ligneEnCoursID = "";
	}
	var requete ="suppression_ligne_stock_preca&ref=" + rowid;
	geoAlert("demande de suppression : " + requete)
	geoRequete(requete,0);
}

/**
 * Destruction d'une ligne dans une grille traceabilite sans confirmation et 
 * envoi de la demande au serveur
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowTracabilite(gridID, rowid){

	$('#' + gridID).delRowData(rowid);
	// on verifie si cette ligne n'était pas en edition
	if(editionLigneEnCours === true && rowid == ligneEnCoursID ) {
		editionLigneEnCours = false;
		ligneEnCoursID = "";
	}
	var requete ="suppression_ligne_traceabilite&ref=" + rowid;
	geoAlert("demande de suppression : " + requete)
	geoRequete(requete,0);
}


/**
 * Destruction d'une ligne dans une grille stock preemb sans confirmation et 
 * envoi de la demande au serveur
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */
function geoGridDeleteRowStockDem(gridID, rowid){

	$('#' + gridID).delRowData(rowid);
	// on verifie si cette ligne n'était pas en edition
	if(editionLigneEnCours === true && rowid == ligneEnCoursID ) {
		editionLigneEnCours = false;
		ligneEnCoursID = "";
	}
	var requete ="suppression_ligne_stock_dem&ref=" + rowid;
	geoAlert("demande de suppression : " + requete)
	geoRequete(requete,0);
}

/**
 * Destruction d'une ligne dans une grille en local sans confirmation
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRow(gridID, rowid){

	$('#' + gridID).delRowData(rowid);
	// on verifie si cette ligne n'était pas en edition
	if(editionLigneEnCours === true && rowid == ligneEnCoursID ) {
		editionLigneEnCours = false;
		ligneEnCoursID = "";
		}
}

/**
 * Destruction d'une ligne dans une grille en local sans confirmation
 * on ne detruit pas réellement la ligne on la masque en mettant le statut é D
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowHide(gridID, rowid){

	$('#' + gridID).setCell(rowid,'statut','D');

	
	$("#" + rowid,"#" + gridID).css({display:"none"});
	

	// on verifie si cette ligne n'était pas en edition
	if(editionLigneEnCours === true && rowid == ligneEnCoursID ) {
		editionLigneEnCours = false;
		ligneEnCoursID = "";
		}
}


/**
 * Destruction d'une ligne de tracabilite dans le detail des articles
 * sans envoi de la demande au serveur
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowChoixArticles(gridID, rowid){

	geoAlert("demande de suppression : " + rowid);
	
	var row = jQuery("#geoGridTraceabilite").getRowData(rowid);	

	var poidsnetavant = row.poidsnet;
	var poidsnetnouveau="0";
	
	var poidsbrutavant = row.poidsbrut;
	var poidsbrutnouveau = "0";
	
	/* on recalcule le poids de la palette */
	geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidsbrutavant,poidsnetnouveau,poidsbrutnouveau);

	geoGridDeleteRowHide(gridID, rowid); 
}

/**
 * Destruction d'une ligne de tracabilite au niveau palette 
 * sans envoi de la demande au serveur
 * il faut détruire aussi les lignes d'articles qui sont en dessous
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowPalette(gridID, rowid){

	geoAlert("demande de suppression de palette et articles : " + rowid);
	
	
	/* on récupére l'ensemble des row */
	var fullGridId = $("#" + gridID)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	var allonsy = false;
	for (var i = 0; i < dataIDs.length; i += 1) {
		if(dataIDs[i] == rowid) {
			allonsy = true ; /* on a atteint le row é détruire */
			geoGridDeleteRowHide(gridID, rowid); /* on le détruit */
			continue; /* on revient au début de la boucle */
		}
		
		var row = $(fullGridId).getRowData(dataIDs[i]);
		if(row.typeligne == "pal_data" && allonsy == true) {
			/*on a atteint la palette suivante : on arrete */
			break;
		} else if(allonsy == true){
			geoGridDeleteRowHide(gridID, dataIDs[i]);
		}
	}	
	
}


/**
 * Destruction d'une ligne de tracabilite au niveau palette intermédiare
 * sans envoi de la demande au serveur
 * aucun article associé : on détruit juste la ligne courante
 * @param requete : requete a appeler pour suppression
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowPaletteInter(gridID, rowid){

	geoAlert("demande de suppression de palette intermédiaire : " + rowid);

	var row = jQuery("#geoGridTraceabilite").getRowData(rowid);	

	/* pas de poids net pour une palette intermédiaire */
	var poidsnetavant = "0";
	var poidsnetnouveau="0";
	
	var poidspalavant = row.arboOupoidspal;
	
	if(ligneEnCoursID == rowid) {
		/* si la ligne est en edition on prend la valeur courante */
		poidspalavant = poidspalligneEnEdition;
	}
	
	var poidspalnouveau = "0"; /* car palette supprimée*/
	
	/* on recalcule le poids de la palette */
	geoGridRecalculerPoidsPalette(rowid,poidsnetavant,poidspalavant,poidsnetnouveau,poidspalnouveau);

	geoGridDeleteRowHide(gridID, rowid); 
	
}

/**
 * Initialisation de toutes les grilles de l'application
 * @return
 */
function geoGridInit(){
	geoAlert('init des grilles');
	geoGridCreerStockPreca();
	geoGridCreerStockDem();
	geoGridCreerTraceabilite();
	geoGridCreerChoixArticles();
	geoGridCreerCommandesEmballages();
	geoGridCreerControleQualite();
}

/**
 * fonction commune gérant la selection de cellule dans une grille
 * modifiable comportant la colonne Action
 */
function  geoGridCellSelect(gridID,iDColonneInactive1,iDColonneInactive2,id,iCol,cellcontent,aftersaverowfunction,begineditionfunction) {
	/* si on a cliqué dans une des  colonnes inactives (en generale la colonne Action), on ne fait rien */
	if(iCol == iDColonneInactive1 || iCol == iDColonneInactive2 ) {
		return ;
	}
	/* si row id est bien renseigne */
	if(id) {
		
		/* cas 1 : edition en cours et ligne selectionnée == celle en edition */
		/* on ne fait rien */
		if(editionLigneEnCours === true && id == ligneEnCoursID) {
			geoAlert("rien");
		} 
		/* cas 2 : edition en cours et click sur une autre ligne */
		else if (editionLigneEnCours === true){
			/* on sauve la ligne en edition, et on passe en edition */
			/* la ligne qui a été cliquée */
			$('#' + gridID).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverowfunction,null);
			
			
			if(gridID == "geoGridTraceabilite")
			{
				var readonly = $("#cloture").val();
				
				if(readonly == 'O') return;
				
				if( $("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'pal_data' )
				{	
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:true}); 
				}
				else if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'detail_pal_inter') 
				{
					
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:false}); 
				}
				else if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'detail_data')
				{
					
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:true});
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:true}); 

				}				
				else
				{
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:true});
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:true}); 
				}
	
				
				/* A VERIFIER changer la propriété des colonnes de poids en fonction de la colonne tare sauf si la ligne est de type detail_pal_inter*/
				if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') != 'detail_pal_inter') {
					if( $("#geoGridTraceabilite").jqGrid('getCell',id,'tare') == "O") {
					jQuery("#geoGridTraceabilite").setColProp('poidsnet',{editable:false}); 
					jQuery("#geoGridTraceabilite").setColProp('poidsbrut',{editable:false}); 
					} else {
						jQuery("#geoGridTraceabilite").setColProp('poidsnet',{editable:true}); 
						jQuery("#geoGridTraceabilite").setColProp('poidsbrut',{editable:true}); 				
					}	
				}
			}	
			
			if(gridID == "geoGridChoixArticles") {
				/ changer la propriété des colonnes de poids en fonction de la colonne tare avant de passer en edition */
				var row = jQuery("#geoGridChoixArticles").getRowData(id);			
				if(row.tare == "O") {
				jQuery("#geoGridChoixArticles").setColProp('pdsnet',{editable:false}); 
				jQuery("#geoGridChoixArticles").setColProp('pdsbrut',{editable:false}); 
				} else {
					jQuery("#geoGridChoixArticles").setColProp('pdsnet',{editable:true}); 
					jQuery("#geoGridChoixArticles").setColProp('pdsbrut',{editable:true}); 				
				}
			}
			
			
			$('#' + gridID).jqGrid('editRow',id,true,begineditionfunction,null,'clientArray',"",aftersaverowfunction,null,afterRestore);
			/* lorsque on selectionne une ligne pour edition */
			/* son statut passe é M, modifié, sauf pour les nouvelles lignes N  ou en les lignes en statut D*/
			if($('#' + gridID).getCell(id,'statut') != 'N' && $('#' + gridID).getCell(id,'statut') != 'D' ) {
				$('#' + gridID).setCell(id,'statut','M');
			}
			
		} 
		else {
			/* on n'est pas en edition, la ligne  cliquée passe en edition */
			
			
			if(gridID == "geoGridTraceabilite")
			{
				var readonly = $("#cloture").val();
				if(readonly == 'O') return;

				if( $("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'pal_data' ) {	
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:true}); 
				} else if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'detail_pal_inter') {
					
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:false}); 
				}
					else if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') == 'detail_data') {
					
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:false}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:true}); 
				}				
				else {
					$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("sol_colis",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("demipal",{editable:true}); 
					$("#geoGridTraceabilite").setColProp("poidsnet",{editable:true});
					$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:true}); 
				}
	
				/* A VERIFIER  changer la propriété des colonnes de poids en fonction de la colonne tare sauf si la ligne est de type detail_pal_inter*/
				if ($("#geoGridTraceabilite").jqGrid('getCell',id,'typeligne') != 'detail_pal_inter') {		
					if( $("#geoGridTraceabilite").jqGrid('getCell',id,'tare') == "O") {
					jQuery("#geoGridTraceabilite").setColProp('poidsnet',{editable:false}); 
					jQuery("#geoGridTraceabilite").setColProp('poidsbrut',{editable:false}); 
					} else {
						jQuery("#geoGridTraceabilite").setColProp('poidsnet',{editable:true}); 
						jQuery("#geoGridTraceabilite").setColProp('poidsbrut',{editable:true}); 				
					}	
				}
			}	
			
			
			if(gridID == "geoGridChoixArticles") {
				/ changer la propriété des colonnes de poids en fonction de la colonne tare avant de passer en edition */
				var row = jQuery("#geoGridChoixArticles").getRowData(id);			
				if(row.tare == "O") {
				jQuery("#geoGridChoixArticles").setColProp('pdsnet',{editable:false}); 
				jQuery("#geoGridChoixArticles").setColProp('pdsbrut',{editable:false}); 
				} else {
					jQuery("#geoGridChoixArticles").setColProp('pdsnet',{editable:true}); 
					jQuery("#geoGridChoixArticles").setColProp('pdsbrut',{editable:true}); 				
				}
			}	
			
			
			$('#' + gridID).jqGrid('editRow',id,true,begineditionfunction,null,'clientArray',"",aftersaverowfunction,null,afterRestore);				
			/* lorsque on selectionne une ligne pour edition */
			/* son statut passe é M, modifié, sauf pour les nouvelles lignes N */
			if($('#' + gridID).getCell(id,'statut') != 'N' && $('#' + gridID).getCell(id,'statut') != 'D' ) {
				$('#' + gridID).setCell(id,'statut','M');
			}
	
		}
		
	}
}

/**
 *  détermine si au moins une ligne a été modifiée dans la grille courante
 *  ou si l'entete a été modifié
 */
function  geoIsCurrentGridModified(gridId) {

	var fullGridId = $("#" + gridId)[0];
    //alert("grille courante " + fullGridId);

	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	//alert("grille courante data IDs " + dataIDs);
	//alert("Nombre de lignes : " + dataIDs.length);
	// pour chaque IDs, récupérer la valeur du statut
	for (var i = 0; i < dataIDs.length; i += 1) {
		var row = $(fullGridId).getRowData(dataIDs[i]);
		if (i > 100) {
			//alert("dataIDs " + i + " = " + dataIDs[i]);
			//alert("row.statut = " + row.statut);

		}
		if (row.statut == 'M' || row.statut =='N') {
				// alert("return true");
			return true;
		}
	}
	//alert("return false");
	return false;
}

/* Remarque générale pour la création des grilles : on peut avoir besoin de déclencher une action aprés l'insertion d'un row dans
 * une grille :
 * pour que la fonction afterInsertRow soit déclenchée il faut que l'attribut gridview soit égal é false */
/* cet attribut optimize la vitesse d'affichage de la grille quand il est é true mais dans ce cas */
/* la fonction afterInsertRow n'est pas déclenchée */

/**
 * Creation de la grille stock precalibre
 */
function geoGridCreerStockPreca() {

	
	$("#geoGridStockPreca").jqGrid({
	datatype: "local",
	height: 400,
	rowNum:1000,
   	multiselect:false,
   	//multiboxonly:true,
   	//shrinkToFit:true,
	gridview:true,
	//autowidth: true,
   	colNames:['Statut','Actions','Catégorie','Coloration','Quantité','cal1','cal2','cal3','cal4',
   	          'cal5','cal6','cal7','cal8','cal9','cal10','cal11','cal12','cal13','cal14', 'Commentaires'],
   	colModel:[
   	          // colonne statut permettant de savoir si une ligne est modifiée ou pas (cote client
   	          // ou cote serveur
   	{name:'statut',index:'statut', width:50, editable: false,hidden:true},
   	{name:'actions',index:'actions', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
	{name:'cat',index:'cat', width:75, editable: false,editoptions:{maxlength:"35",size:"35"}, classes:'GreyBackground'},
	{name:'color',index:'color', width:75, editable: false,editoptions:{maxlength:"35",size:"35"}, classes:'GreyBackground'},
	{name:'qtt',index:'qtt', width:70, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal1',index:'cal1', width:45, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal2',index:'cal2', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal3',index:'cal3', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal4',index:'cal4', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal5',index:'cal5', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal6',index:'cal6', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal7',index:'cal7', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal8',index:'cal8', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal9',index:'cal9', width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal10', index:'cal10',  width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal11', index:'cal11',  width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal12', index:'cal12',  width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal13', index:'cal13',  width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'cal14', index:'cal14',  width:30, editable: true,editoptions:{maxlength:"35",size:"35"}},
	{name:'commentaire', index:'commentaire',  width:300, editable: true,editoptions:{maxlength:"140",size:"140"}}
	],
	
onCellSelect: function(id,iCol,cellcontent){
	geoGridCellSelect("geoGridStockPreca",1,-1,id,iCol,cellcontent,aftersaverow,beginEdition);
},

gridComplete: function () {
	geoAlert("grid stock preca complete");
	var index_premier_calibre = 5 ; /* a changer si on rajoute des colonnes avant les colonnes de calibre */
	/* on cache toutes les colonnes de calibre  : attention é modifer ce tableau si le modéle de la grille est modifié */
	$(this).hideCol(['cal1','cal2','cal3','cal4','cal5','cal6','cal7','cal8','cal9','cal10','cal11','cal12','cal13','cal14', 'commentaire']);
	
	/* On montre les colonnes specifiques au cas courant*/
	var col=$("#colonnes").val();
	
	geoAlert("Colonnes à afficher : " + col);

	var model = $(this).jqGrid('getGridParam','colModel');
	
	if(col !== undefined) {
		var colonnes = col.split(",");
	
		for(i=0;i<colonnes.length;i++) {
			$(this).showCol(model[i+index_premier_calibre].name);
			$(this).setLabel(i+index_premier_calibre,colonnes[i]);
			}
		}
		
	},
	editurl:"clientArray",
	caption: "Stock Precalibré"
});	


}

/**
 * Creation de la grille stock préemballé
 */
function geoGridCreerStockDem() {

	 var choixpalette=geoGridInitChoix("geoDataPalette");
	
	$("#geoGridStockDem").jqGrid({
	datatype: "local",
	height: 300,
	rowNum:1000,
   	multiselect:false,
   	//multiboxonly:true,
   	//shrinkToFit:true,
	gridview:true,
	//autowidth: true,
   	colNames:['Statut','Actions','Article','Quantité', 'Age','Date de fabrication', 'Type palette','Commentaire'],
   	colModel:[
   	          // colonne statut permettant de savoir si une ligne est modifiée ou pas (cote client
   	          // ou cote serveur
   	{name:'statut',index:'statut', width:50, editable: false,hidden:true},
   	{name:'actions',index:'actions', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:false},
	{name:'ref',index:'ref', width:75, editable: true, align:'center',editoptions:{maxlength:"35",size:"35"}},
	{name:'qtt',index:'qtt', width:75, editable: true, align:'right',editoptions:{maxlength:"35",size:"35"}},
	{name:'age',index:'age', width:50, editable: true, align:'right',editoptions:{maxlength:"35",size:"35"}},
	{name:'date_fab',index:'date_fab', width:110, resizable:true,sortable:true, search: false, editable: true,
   		editoptions:{dataInit: function (elem) {
   			$(elem).addClass("jcalendrier ui-widget ui-widget-content ui-corner-all");
   			$(elem).datepicker({dateFormat: 'dd/mm/yy'},{
				onClose: function(dateText, inst){
					$(this).focus();
				}
			});
   			}
   		} },	
		
	{name:'typepal',index:'typepal', width:300, editable: true,  resizable:false, edittype:"select",
		editoptions:{dataInit: function (elem) {
		setTimeout(function() {
				$(elem).combobox({jqgrid:true},{inputSize:30});
				},100);
		},
		value:choixpalette}
	},	
	{name:'desc',index:'desc', width:100, editable: true,editoptions:{maxlength:"35",size:"35"}}
	],
	
onCellSelect: function(id,iCol,cellcontent){
	geoGridCellSelect("geoGridStockDem",1,-1,id,iCol,cellcontent,aftersaverow,beginEdition);
},
	editurl:"clientArray",
	caption: "Stock Préemballé"

});	

}



/**
 * Creation de la grille controle qualite
 */
function geoGridCreerControleQualite() {

	
	$("#geoGridControleQualite").jqGrid({
	datatype: "local",
	height: 300,
	rowNum:1000,
   	multiselect:false,
	gridview:true,
   	colNames:['Ligne','Article','Controleur', 'Ref',''],
   	colModel:[
	{name:'ligne',index:'ligne', width:75, align:'center', editable: false},
	{name:'article_desc',index:'article_desc', width:350, editable: false},
	{name:'controleur',index:'controleur', width:100, editable: false},
	{name:'ref',index:'ref', width:75, editable: false, align:'center'},
   	{name:'actions',index:'actions', width:30, sortable:false,editable: false,resizable:false,title:false,hidden:false},
	],
	editurl:"clientArray",
	caption: "Controle Qualité"

});	

}



/**
 * Creation de la grille des palettes
 */
function geoGridCreerTraceabilite() {
	
	$("#geoGridTraceabilite").jqGrid({
	datatype: "xml",
	height: 400,
	rowNum:1000,
   	multiselect:false,
   	//multiboxonly:true,
   	shrinkToFit:true,
	gridview:false, /* false pour compatibilité avec sous grille et déclenchement afterinsertrow*/
	//autowidth: true,
	colNames:['Statut','Type ligne','Ref Traca','','','Descriptif','Au sol','1/2 Pal','Pds brut','Pds net','Poids pal','Articles','Orl Ref','tare','poids net unit','poids brut unit',''],
   	colModel:[
   	          // colonne statut permettant de savoir si une ligne est modifiée ou pas (cote client
   	          // ou cote serveur
   	{name:'statut',index:'statut', width:50, editable: false,hidden:true,sortable:false},
   	{name:'typeligne',index:'typeligne', width:50, editable: false,hidden:true,sortable:false},
   	{name:'reftraca',index:'reftraca', width:50, editable: false,hidden:true,sortable:false},
   	{name:'numpal',index:'numpal', width:20, sortable:false,editable: false, align:'center',sortable:false,resizable:false,title:false,hidden:false, classes:''},
   	{name:'actions',index:'actions', width:20, sortable:false,editable: false, align:'center',sortable:false,resizable:false,title:false,hidden:false, classes:''},
	{name:'desc',index:'desc', width:350, editable: true,sortable:false, align:'left', classes:'', editoptions:{maxlength:"35",size:"35"}},
	{name:'sol_colis',index:'sol_colis', width:45, editable: true,sortable:false, align:'center',classes:''},
	{name:'demipal',index:'demipal', width:45, editable: true,edittype:"checkbox",editoptions: { value:"1:0" },align:'center',classes:''},
   	{name:'poidsbrut',index:'poidsbrut', width:60, sortable:false, align:'center',editable: true,sortable:false,resizable:false,title:false,hidden:false, classes:''},
   	{name:'poidsnet',index:'poidsnet', width:60, sortable:false, align:'center',editable: true,sortable:false,resizable:false,title:false,hidden:false, classes:''},
   	{name:'arboOupoidspal',index:'arboOupoidspal', width:80, sortable:false, align:'center',editable: true,sortable:false,resizable:false,title:false,hidden:false, classes:''},
   	{name:'articles',index:'articles', width:200, editable: false,sortable:false,hidden:true, classes:''},
   	{name:'orlref',index:'orlref', width:50, editable: false,hidden:true,sortable:false},
   	{name:'tare',index:'tare', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	{name:'pdsnetunit',index:'pdsnetunit', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
	{name:'pdsbrutunit',index:'pdsbrutunit', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	{name:'addarticle',index:'addarticle', width:75, sortable:false, align:'center',editable: false,resizable:false,title:false,hidden:false, classes:''},
	],
	
onCellSelect: function(id,iCol,cellcontent){
	
	var rowid = id ;
	
	/* si on clique sur une ligne de titre on ne fait rien */
	if( $(this).jqGrid('getCell',rowid,'typeligne') == 'detail_titre' ) {
		return;
	}
	
	/* la colonne 4 et la 15 sont inactives car contiennent des boutons d'action */
	geoGridCellSelect("geoGridTraceabilite",4,16,id,iCol,cellcontent,aftersaverowTraceabilite,beginEditionTraceabilite);

},

	editurl:"clientArray",
	caption: "Traçabilité",

    afterInsertRow: function(rowid, rowData,rowElem){
    	geoAlert("afterInsertRow");

		if(rowData.typeligne == "pal_data") {
	    	geoAlert("ligne de type palette - row = " + rowid);

			$(this).jqGrid('setCell',rowid,'numpal', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'actions', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'desc', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'sol_colis', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'demipal', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'poidsbrut', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'poidsnet', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'arboOupoidspal', '', 'GreyBackground');
			$(this).jqGrid('setCell',rowid,'addarticle', '', 'GreyBackground');
			}
		else if(rowData.typeligne == "detail_titre") {
	    	geoAlert("ligne de type detail titre - row = " + rowid);

			$(this).jqGrid('setCell',rowid,'actions', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'desc', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'sol_colis', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'demipal', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'poidsbrut', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'poidsnet', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'arboOupoidspal', '', 'ui-state-default ui-th-column ui-th-ltr');
			$(this).jqGrid('setCell',rowid,'addarticle', '', 'ui-state-default ui-th-column ui-th-ltr');
			}
		else if(rowData.typeligne == "detail_pal_inter") {
	    	geoAlert("ligne de type palette intermédiaire - row = " + rowid);

			$(this).jqGrid('setCell',rowid,'actions', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'desc', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'sol_colis', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'demipal', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'poidsbrut', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'poidsnet', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'arboOupoidspal', '', 'PalInterBackground');
			$(this).jqGrid('setCell',rowid,'addarticle', '', 'PalInterBackground');
			}
		},	
	
	/* quand la grille principale est chargée on déclenche des changements de propriete en fonction du type de ligne*/
	gridComplete: function () {
		
		/* si la grille est read only */
		var readonly = $("#cloture").val();
		geoAlert("readonly = " + readonly);
		
		if(readonly == "O") {
		/* on masque la colonne action */
			$("#geoGridTraceabilite").hideCol("actions");
			$("#geoGridTraceabilite").hideCol("addarticle");
			/* on rends les colonnes non editables */
			$("#geoGridTraceabilite").setColProp("desc",{editable:false}); 
			$("#geoGridTraceabilite").setColProp("sol_colis",{editable:false}); 
			$("#geoGridTraceabilite").setColProp("demipal",{editable:false}); 
			$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:false}); 
			$("#geoGridTraceabilite").setColProp("poidsnet",{editable:false});
			$("#geoGridTraceabilite").setColProp("arboOupoidspal",{editable:false}); 
			} else {
				$("#geoGridTraceabilite").showCol("actions");
				$("#geoGridTraceabilite").showCol("addarticle");
				/* on rends les colonnes  editables */
				/* sscc est editable seulement pour certains fournisseurs : voir champ caché 'sscc_auto'*/
				var sscc_auto = $("#sscc_auto").val();
				if(sscc_auto == "O") { /* saisie automatique donc non editable */
					$("#geoGridTraceabilite").setColProp("desc",{editable:false});
				} else {
					$("#geoGridTraceabilite").setColProp("desc",{editable:true});
				}
				$("#geoGridTraceabilite").setColProp("sol_colis",{editable:true}); 
				$("#geoGridTraceabilite").setColProp("demipal",{editable:true}); 
				$("#geoGridTraceabilite").setColProp("poidsbrut",{editable:true}); 
				$("#geoGridTraceabilite").setColProp("poidsnet",{editable:true}); 	
				$("#geoGridTraceabilite").setColProp("arboOuPoidspal",{editable:true}); 
			}
    }
});	

	/* on masque le header de la grille puisqu'il ne sert pas */
	/*$("#geoGridTraceabilite").parents("div.ui-jqgrid-view").children("div.ui-jqgrid-hdiv").hide();	*/
}

/*
 * Grille pour sélectionner un ou plusieurs articles
 * et pour éditer les détails associés é l'article (poids ...)
 */
function geoGridCreerChoixArticles() {


$("#geoGridChoixArticles").jqGrid({
	datatype: "local",
	height: 200,
	rowNum:100,
	gridview:false,
   	colNames:['Ref','Description','Nb colis','Poids brut','Poids net','Code Arbo','tare','Poids brut unité','Poids net unité','reftraca','reftracaligne',''],
   	colModel:[
   	    {name:'refart',index:'refart', width:80,hidden:false},
   		{name:'desc',index:'desc',width:450,resizable:true,sortable:true,editable: false},
   	   	{name:'nbcol',index:'nbcol', width:50, sortable:false,editable: true,resizable:false,title:false,hidden:false},
   	   	{name:'pdsbrut',index:'pdsbrut', width:65, sortable:false,editable: true,resizable:false,title:false,hidden:false},
   	   	{name:'pdsnet',index:'pdsnet', width:65, sortable:false,editable: true,resizable:false,title:false,hidden:false},
   		{name:'codearbo',index:'codearbo', width:70, sortable:false,editable: true,resizable:false,title:false,hidden:false},
  	   	{name:'tare',index:'tare', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	   	{name:'pdsnetunit',index:'pdsnetunit', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	   	{name:'pdsbrutunit',index:'pdsbrutunit', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	   	{name:'reftraca',index:'reftraca', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
   	   	{name:'reftracaligne',index:'reftracaligne', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:true},
    	{name:'addart',index:'addart', width:50, sortable:false, align:'center',editable: false,resizable:false,title:false,hidden:false},	 
   	],
   	
		onCellSelect: function(id,iCol,cellcontent){
			/* colonne inactive*/
			geoGridCellSelect("geoGridChoixArticles",0,10,id,iCol,cellcontent,aftersaverowChoixArticles,beginEditionChoixArticles);


			
		},
	gridComplete: function () {
		
	},
	editurl:"clientArray",
   	multiselect:false, /* on abandonne le multiselect */
   	multiboxonly:false,
   	shrinkToFit:true
   	
});


}


/* Sauvegarde de la grille des stocks : on va extraite les lignes de la grille */
/* et les envoyer directement la requete au serveur */
function geoGridSauverStockPreca() {
	geoAlert("geoSauverStockPreca");
	var gridId = "geoGridStockPreca";
	
	
	/* on recupere le fournisseur selectionné */
    var fournisseur = $('#combo_fourni').val();
	
	if(editionLigneEnCours) {
		// alert("Edition en cours, sauvegarde automatique de la ligne " + ligneEnCoursID);
		$("#" + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverow,null);
		}
	
	geoAfficheMessage();
	
	var fullGridId = $("#" + gridId)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	for (var i = 0; i < dataIDs.length; i += 1) {		
		var row = $(fullGridId).getRowData(dataIDs[i]);
		if(row.commentaire == "") row.commentaire = " ";
		dataValue = dataValue + dataIDs[i] + "|"  +  row.statut + "|"  +  row.cat    + "|" + row.color +  "|" + row.qtt    + "|" + row.cal1 + "|" + row.cal2 + 
											 "|"  +  row.cal3 + "|"  +  row.cal4 + "|" + row.cal5 + "|" + row.cal6 +
											 "|"  +  row.cal7 + "|"  +  row.cal8 + "|" + row.cal9 + "|" + row.cal10  +
											 "|"  +  row.cal11  + "|"  +  row.cal12  + "|" + row.cal13  + "|" + row.cal14  + "|" + row.commentaire  + "^"  ;
		dataValue = dataValue.replace('+', 'car_plus');
	}
	
	if(dataValue == "") {
		dataValue = "none"; /* expliciter le fait qu'il n'y a pas de ligne */
	}
	
	/* et il faut  récupérer le commentaire saisi */
	var commentaire = "commentaire de test";
	
	geoRequete("update_stock_preca&value=" +  dataValue + "&commentaire=" + commentaire +  "&fou_code=" + fournisseur,0);
	
	
	geoAlert("fin geoSauverStockPreca");	
}

/* Sauvegarde de la grille des stocks Dem: on va extraite les lignes de la grille */
/* et les envoyer directement la requete au serveur */
function geoGridSauverStockDem() {
	geoAlert("geoSauverStockDem");
	var gridId = "geoGridStockDem";
		
	/* on recupere le fournisseur selectionné */
    var proprio = $('#combo_proprio').val();
	
	if(editionLigneEnCours) {
		// alert("Edition en cours, sauvegarde automatique de la ligne " + ligneEnCoursID);
		$("#" + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverow,null);
		}
	
	geoAfficheMessage();
	
	var fullGridId = $("#" + gridId)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	for (var i = 0; i < dataIDs.length; i += 1) {		
		var row = $(fullGridId).getRowData(dataIDs[i]);
		dataValue = dataValue + dataIDs[i] + "|" +  row.statut + "|" +  row.ref  + "|" + row.qtt +  "|" + row.age + "|" + row.typepal + "|" + row.desc + "|" + row.date_fab  + "^"  ;	
	}
	
	if(dataValue == "") {
		dataValue = "none"; /* expliciter le fait qu'il n'y a pas de ligne */
	}
	
	geoRequete("update_stock_dem&proprio=" + proprio + "&value=" +  dataValue,0);
	
	
	geoAlert("fin geoSauverStockDem");	
}

function geoGridValiderStockDem() {
	geoAlert("geoGridValiderStockDem");
	var gridId = "geoGridStockDem";
		
	if(editionLigneEnCours) {
		// alert("Edition en cours, sauvegarde automatique de la ligne " + ligneEnCoursID);
		$("#" + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverow,null);
		}
	
	geoAfficheMessage();
	
	var fullGridId = $("#" + gridId)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	for (var i = 0; i < dataIDs.length; i += 1) {		
		var row = $(fullGridId).getRowData(dataIDs[i]);
		dataValue = dataValue + dataIDs[i] + "|" +  row.statut + "|" +  row.ref  + "|" + row.qtt +  "|" + row.age + "|" + row.typepal + "|" + row.desc + "|" + row.date_fab  + "^"  ;	
		
	}
	
	if(dataValue == "") {
		dataValue = "none"; /* expliciter le fait qu'il n'y a pas de ligne */
	}
	
	geoRequete("valider_stock_dem&value=" +  dataValue,0);
	
	geoAlert("fin geoGridValiderStockDem");	
}

/**
 * ajout d'une ligne dans la grille des stock
 * @param {Object} gridId
 */
function geoGridAjouterLigneStockPreca() {

var dynamicId = Math.random();
var gridId = "geoGridStockPreca";

/* bouton supprimer ligne */
var b_del = "<img onclick=\"geoGridDeleteRowStockPreca('" + gridId + "','" + dynamicId + "')\" class=\"geoImageAction\" src=\"images/delete.gif\"> </img>";

var myrow = [
	{statut:"N",actions:b_del,cat:"",color:"",qtt:"",cal216:"",cal198:"",cal175:"",cal163:"",cal150:"",cal138:"",cal125:"",cal113:"",cal100:"",cal88:"",cal80:"",cal72:"",cal64:"",cal56:"",commentaire:""}
			];
/* l'id du row est généré dynamiquement */ 

$("#" + gridId).addRowData(dynamicId,myrow[0]);

/* si pas d'edition en cours on passe la ligne en edition */
if (editionLigneEnCours != true) {
	$('#' + gridId).jqGrid('editRow',dynamicId, true, beginEdition, null, 'clientArray', "", aftersaverow, null, afterRestore);
	}			
}

/**
 * ajout d'une ligne dans la grille des stock Dem
 * @param {Object} gridId
 */
function geoGridAjouterLigneStockDem() {

var dynamicId = Math.random();
var gridId = "geoGridStockDem";

/* bouton supprimer ligne */
var b_del = "<img onclick=\"geoGridDeleteRowStockDem('" + gridId + "','" + dynamicId + "')\" class=\"geoImageAction\" src=\"images/delete.gif\"> </img>";

var myrow = [
	{statut:"N",actions:b_del,ref:"",qtt:"",age:"",date_fab:"",typepal:"",desc:""}
			];
/* l'id du row est généré dynamiquement */ 

$("#" + gridId).addRowData(dynamicId,myrow[0]);

/* si pas d'edition en cours on passe la ligne en edition */
if (editionLigneEnCours != true) {
	$('#' + gridId).jqGrid('editRow',dynamicId, true, beginEdition, null, 'clientArray', "", aftersaverow, null, afterRestore);
	}			
}

/**
 * ajout d'une ligne dans la grille articles
 * aprés la ligne courante en reprenant les valeurs refart et description
 * @param {Object} gridId
 */
function geoGridAjouterArticles(gridId,rowId) {

	
	if (editionLigneEnCours == true){
		/* on sauve la ligne en edition,  */
		$('#' + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverowChoixArticles,null);	
	}
	
var rowdata = $("#" + gridId).getRowData(rowId);	
	
var dynamicId = rowId + "_" + globalcompteur;
globalcompteur = globalcompteur+1;
/* bouton ajouter  ligne */
var b_add = "<img onclick=\"geoGridAjouterArticles('" + gridId + "','" + dynamicId + "')\" class=\"geoImageAction\" src=\"images/plus.gif\"> </img>";


var myrow = [
	{refart:rowdata.refart,desc:rowdata.desc,nbcol:"",pdsnet:"",pdsbrut:"",codearbo:"",tare:rowdata.tare,pdsnetunit:rowdata.pdsnetunit,pdsbrutunit:rowdata.pdsbrutunit,reftraca:"",reftracaligne:"",addart:b_add}
			];
/* l'id du row est généré dynamiquement */ 

$("#" + gridId).addRowData(dynamicId,myrow[0],"after",rowId);

/* on passe la ligne en édition */
$('#' + gridId).jqGrid('editRow',dynamicId,true,begineditionChoixArticles,null,'clientArray',"",aftersaverowChoixArticles,null,afterRestore);

		
}

/**
 * Ajout palette intermediaire
 * @param gridId grille appelante
 * @param rowId numero de la ligne qui est la reference tracabilité
 */
function geoGridAjouterPaletteInter(gridId,rowId) {

	var ordref = $('#ordref').val();
	
	//var requete ="ask_ajout_palette_inter" + "&ordref=" + ordref + "&reftraca="+rowId;
	
	geoGridTracabiliteSauver("ask_ajout_palette_inter&reftraca="+rowId,null);
	
	//geoRequete(requete);
	
}

/**
 * Lecture de la liste des données 
 * exemple : fournisseur palette unite
 * dans le div caché contenant ces données
 */
function geoGridInitChoix(divCacheData) {
	
	var choix=" : ";
	// alert("debut choix pour " + divCacheData);
	
	/* lecture des elements */
	var elements = $("#" + divCacheData + " > div");
	// alert("geoGridInitChoix  = " + elements.length);

		$(elements).each(function(index) {
			/* on recupere le code du span  courant */
			var code = $('span', this).text();
			
			/* on recupere le texte du label  courant */
			var description = $('label', this).text();
						
			choix = choix + ";" + code + ":" + description ;
		});
	//alert(choix);
	return choix;
}

/* fonctions de gestion de la tracebilite */
/**
 * Ajouter une ligne de traceabilité Old 
 * Ne sert plus
 */
function geoGridTracabiliteAjouterOld() {
	
/*geoGridDetailArticles("geoGridTraceabilite","");*/
return;
/* On ne fait pas la suite : au lieu d'ajouter une ligne vide on appelle la fonction d'ajout d'articles*/

globalAjoutLigneTraceEnCours = true; /* on est en train d'ajouter une ligne */
	var dynamicId = Math.random();
	var gridId = "geoGridTraceabilite";

	/* bouton supprimer ligne */
	var b_del = "<img onclick=\"geoGridDeleteRowPalette('" + gridId + "','" + dynamicId + "')\" class=\"geoImageAction\" src=\"images/delete.gif\"> </img>";

	
	/* bouton ajouter  article */
	var b_add = "<img onclick=\"geoGridDetailArticles('" + gridId + "','" + dynamicId + "')\" class=\"geoImageAction\" src=\"images/plus.gif\"> </img>";

	var myrow = [
		{statut:"N",typeligne:"pal_data",reftraca:"",actions:b_del,desc:"",sol_colis:"",poidsnet:"",poidsbrut:"",arbo:"",articles:"",addarticle:b_add}
				];
	/* l'id du row est généré dynamiquement */ 

	$("#" + gridId).addRowData(dynamicId,myrow[0]); /* cette fonction déclenche l'événement gridcomplete */

	/* si pas d'edition en cours on passe la ligne en edition */
	if (editionLigneEnCours != true) {
		$('#' + gridId).jqGrid('editRow',dynamicId, true, beginEdition, null, 'clientArray', "", aftersaverow, null, afterRestore);
		}
	globalAjoutLigneTraceEnCours = false; /* la ligne est ajoutee */

}

/**
 * Ajouter une palette
 */

function geoGridTracabiliteAjouter() {
	var ordref = $('#ordref').val();
	var requete ="ask_nouvelle_palette" + "&ordref=" + ordref;
	
geoRequete(requete);
}


/**
 * Quitter le controle qualité
 */
function geoGridControleQualiteQuitter() { 
	geoRestoreHistory() ; /* retour sur le détail*/
}

/**
 * Quitter la traceabilité
 */
function geoGridTracabiliteQuitter() {
	/* retour aux expéditions */
	//geoRequete("ask_exped",0); 
	geoRestoreHistory() ; /* retour sur le détail*/
}
/**
 * Sauver la traceabilité
 */
function geoGridTracabiliteSauver(libelle_requete,param) {
	geoAlert("geoTraceabiliteSauver libelle_requete = " + libelle_requete);
	var gridId = "geoGridTraceabilite";
	
	if (editionLigneEnCours == true){
		/* on sauve la ligne en edition,  */
		$('#geoGridTraceabilite').jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverowTraceabilite,null);
	}
	
	
	if(libelle_requete == null ) {
		libelle_requete = "update_traceabilite";
	}
	
	if(param == null) {
		param = "&cloture=N";
	}
	
	
	/* on recupere les champs de l'entete */
    var document = $('#ref_doc').val();
    var immat = $('#ref_log').val();
    var bonstation = $('#fou_ref_doc').val();
    
    /* on recupere la reference de l'ordre */
    var ordref = $('#ordref').val();
	
	if(editionLigneEnCours) {
		// alert("Edition en cours, sauvegarde automatique de la ligne " + ligneEnCoursID);
		$("#" + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverow,null);
		}
	
	geoAfficheMessage();
	
	var fullGridId = $("#" + gridId)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	// alert("Nombre de lignes : " + dataIDs.length);
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	for (var i = 0; i < dataIDs.length; i += 1) {		
		var row = $(fullGridId).getRowData(dataIDs[i]);
		
		
		/* on ne prend que les lignes de type detail_data detail_pal_inter ou pal_data et status a changé*/
		if (("detail_pal_inter" == row.typeligne || "pal_data" == row.typeligne || "detail_data" == row.typeligne)) {
		
			geoAlert("poids net = " + row.poidsnet);
			
			if(row.poidsnet == "") {
				row.poidsnet="0";
			}
			if(row.poidsbrut == "") {
				row.poidsbrut="0";
			}
			var arrayDesc = row.desc.split(" - ");
			row.desc = arrayDesc[0];
			
			var poidsbrut = row.poidsbrut.replace(".",",");
			var poidsnet  = row.poidsnet.replace(".",",");
			
			dataValue = dataValue + dataIDs[i] + "|" +  row.statut +  "|" +  row.typeligne +  "|"  +  row.reftraca +  "|"   +  row.desc +  "|"  +  row.sol_colis 
			+ "|" +  row.demipal + "|" +  poidsnet  + "|" + poidsbrut +  "|" + row.arboOupoidspal  +  "|" + row.orlref  +  "^"  ;
		
		}
	}
	
	if(dataValue == "") {
		dataValue = "none"; /* expliciter le fait qu'il n'y a pas de ligne */
	}
	
	/* construction des data à passer avec la requete post */
	/* il s'agit d'un objet contenant des paires /key/value */
	var data = {value:dataValue,ref_doc:document,ref_log:immat,fou_ref_doc:bonstation,ordref:ordref};
	
	//alert(libelle_requete);
	//alert(data);
	geoRequetePost(libelle_requete + param,data,0)
	//geoRequete(libelle_requete + param + "&value=" +  dataValue + "&ref_doc=" + document +  "&ref_log=" + immat  +  "&fou_ref_doc=" + bonstation +  "&ordref=" + ordref,0);
	
	geoAlert("fin geoSauverTraceabilite");
}
/**
 * Automatiser la traceabilité : 1ère étape qui va renvoyer un  formulaire de saisie flottante pour déterminer
 * la répartition des articles sur les palettes
 * la soumission du formulaire appelera automatiquement la fonction côté serveur "automatiser_tracabilite"
 */
function geoGridTracabiliteAutomatiser() {
   var ordref = $('#ordref').val();

	var requete ="ask_automatiser_traceabilite" + "&ordref=" + ordref;

	geoAlert("automatiser : " + requete)
	geoRequete(requete,0);	
}


/**
 * Cloturer la traceabilité
 */
function geoGridTracabiliteCloturer() {
	/* sauvegarde avec cloture */
	geoGridTracabiliteSauver(null,"&cloture=O");	
}

/**
 * ajout de ligne au détail d'expédition : on sauve la grille
 * avec l'option detail articles pour obtenir le pop-up de choix d'articles
 */
function geoGridDetailArticles(gridId, refligne) {
	
	/* on appelle la fonction de sauvegarde avec la reference de la ligne */
	geoGridTracabiliteSauver("ask_ajout_ligne_ordre&reftraca="+refligne,"&cloture=N");
}

/**
 * valider le choix des articles pour la tracabilité 
*/
function geoGridValiderChoixArticles(gridId) {
	geoAlert("geoValiderChoixArticles");

	if(editionLigneEnCours) {
		// alert("Edition en cours, sauvegarde automatique de la ligne " + ligneEnCoursID);
		$("#" + gridId).jqGrid('saveRow',ligneEnCoursID,null,'clientArray',"",aftersaverowChoixArticles,null);
		}
	
	var fullGridId = $("#" + gridId)[0];
	
	// récupérer la liste des ids de la grille
	var dataIDs = $(fullGridId).getDataIDs();
	
	
	var dataValue = "";
	// pour chaque IDs, récupérer le contenu
	for (var i = 0; i < dataIDs.length; i += 1) {		
		var row = $(fullGridId).getRowData(dataIDs[i]);
			
		/* on récupére les lignes pour lesquelles le nombre de colis est supérieur é 0 */
		var nbcol = row.nbcol*1;
		if(nbcol > 0) {
			var pdsbrut = row.pdsbrut.replace(".",",");
			var pdsnet  = row.pdsnet.replace(".",",");

			dataValue = dataValue + dataIDs[i] + "|"  +  row.nbcol  + "|" + pdsnet +  "|" + pdsbrut  +  "|" + row.codearbo  +  "|" + row.reftraca  +  "|" + row.reftracaligne  + "^"  ;
			}
		}
	
	var requete = "update_traceabilite_ligne&" +"value="+dataValue;
	geoAlert("geoGridValiderChoixArticles - liste choix =" + dataValue);
	geoRequete(requete,0);
}

/**
 * Impression d'une fiche palette
 * @param refordre
 * @param reftraca
 */
function geoGridFichePalette (refordre, reftraca) {
	
}
