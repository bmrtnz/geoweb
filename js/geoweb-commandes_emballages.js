/**
 * Fonctions javascript pour les commandes d'emnballages
 */

/**
 * Creation de la grille des commandes d'emballages
 */
function geoGridCreerCommandesEmballages() {

	
	$("#geoGridCommandesEmballages").jqGrid({
	datatype: "local",
	height: 300,
	rowNum:1000,
   	multiselect:false,
   	//multiboxonly:true,
   	//shrinkToFit:true,
	gridview:true,
	//autowidth: true,
   	colNames:['','No','Article','Quantité','Unité','Livraison souhaitée','Livraison prévue','Etat','Fournisseur','Lieu',''],
   	colModel:[
   	{name:'act1',index:'act1', width:50, sortable:false,editable: false,resizable:false,title:false,hidden:false},
   	{name:'refcommande',index:'refcommande', width:50, editable: false,hidden:false},
	{name:'article',index:'article', width:150, editable: false},
	{name:'qtt',index:'qtt', width:50, editable: false},
	{name:'unite',index:'unite', width:50, editable: false},
	{name:'datelivsouh',index:'datelivsouh', width:110, editable: false},
	{name:'datlivprev',index:'datlivprev', width:110, editable: false},
	{name:'etat',index:'etat', width:100, editable: false},
	{name:'fourni',index:'fourni', width:100, editable: false},	
	{name:'lieu',index:'lieu', width:100, editable: false},
	{name:'act2',index:'act2', width:50, editable: false}
	],

	editurl:"clientArray",
	caption: "Commandes emballages"

});	

}

/**
 * Destruction d'une ligne dans une grille commande emballage avec  confirmation et 
 * envoi de la demande au serveur
 * @param gridID
 * @param rowid
 * @return
 */

function geoGridDeleteRowEmballage(gridID, rowid){
	
	
	/* dialogue de confirmation */
	$("#geoConfirmMessage").html("Confirmez vous la suppression de cette commande d'emballage ?");
	$("#geoConfirm").dialog({

			buttons: {
			Oui: function() {
				// $('#' + gridID).delRowData(rowid); c'est le serveur qui détruit
				$(this).dialog('close');
				var requete ="supprime_commande_emballage&ref_cmd=" + rowid;
				geoRequete(requete,0);

			},
			Non: function() {
				$(this).dialog('close');
			}
		},
		width:420,
		modal:true
	});

	
	
}

/**
 * Demande de la grille des commandes d'emballages
 * @param datemin
 * @param datemax
 */
function geoCommandesEmballages(datemin,datemax) {
var requete = 'PBServlet?httpPBCommand=ask_commandes_emballages&date_min=' + datemin +"&date_max=" + datemax; 
geoRequete(requete,false);
}

/**
 * Modification d'une commande d'emballages
 * même commande pour consulter / modifier : c'est le serveur qui fait la différence
 * @param ref_commande
 */
function geoModifierCommandeEmballages(ref_commande) {
	
	var requete ="formulaire_commandes_emballages" + "&ref_cmd=" + ref_commande;	
	geoRequete(requete);
	}
	

/**
 * Consultation d'une commande d'emballages
 *  même commande pour consulter / modifier : c'est le serveur qui fait la différence
 * @param ref_commande
 */
function geoConsulterCommandeEmballages(ref_commande) {
	var requete ="formulaire_commandes_emballages" + "&ref_cmd=" + ref_commande;	
	geoRequete(requete);
	
}

/**
 * Ajouter une commande
 */
function geoGridCommandesEmballagesAjouter() {
	var requete ="formulaire_commandes_emballages&ref_cmd=''";	
	geoRequete(requete);
}


/**
 * Filter commande selon les dates
 */
function geoGridCommandesEmballagesFiltrer() {
	/* on recupere les dates */
	var date_min = $("#date_min").val();
	var date_max = $("#date_max").val();


	geoCommandesEmballages(date_min,date_max);
}

