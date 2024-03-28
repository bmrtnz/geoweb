/* variable globale pour les traces : determine le comportement de geoAlert*/
var GEO_TRACE = true ; /* activation des traces ou non */
var GEO_ALERT = false;  /* traces sous forme de popup ou non */
/* variable globale pour gerer l'historique  */
var globalHistory = new Array();
var geoGridInitFlag = false;
var current_element = null;


/*** pseudo classe GeoContexte ****/
function GeoContexte(nomDePage,contenu) {
	this.nom = nomDePage;
	this.contenu = contenu;
}

/* variable globale pour gerer le contexte */
var globalContexte = new Array();

/* options globales pour les requ�tes Ajax */
/* d�sactivation du cache du browser */
/* mode synchrone */
$.ajaxSetup({cache:false},{async:false}); 

/* initialisation de GEOWEB : 1er appel pour r�cup�rer la fen�tre de Login*/
function geoInit() {
geoAlert('init geoweb v6 ajax');

$.get('PBServlet?reponseAjax=yes', function(response, status, xhr) {
	//geoAlert("Reponse Servlet re�ue " + response);
	/* on va chercher dans la r�ponse qui doit etre du vrai xhtml avec balise englobantes */
	/* l'�l�ment souhait� dont on prend le contenu html */
// var selection = $(response).find('span').html();
	var selection = $(response).find('target[id="geoColonneMilieu"]').children();
//geoAlert("sel = " + selection.html());
$("#geoColonneMilieu").html(selection);
selection = $(response).find('target[id="geoEnPied"]').children();
//geoAlert("sel = " + selection.html());

$("#geoEnPied").html(selection);
$("#geoCartouche img").attr("src","images/bienvenue.gif");
	});


/* gestion  des erreurs Ajax */
gestionErreurAjax();

}

/**
 * Initialisation du cache
 * 4 valeurs possibles :
 * init: premi�re initilisation du cache , avec init des grilles
 * all : rechargement de tout le cache
 * tiers : rechargement des tiers
 * articles : rechargement des articles
 */
function geoInitCache(cache,prefix){

	/* si cache non renseign� on ne fait rien */
	if (cache == null || cache == "") {
		return;
	}
	
	geoAlert("chargement des donn�es du cache " + cache + "prefix =  " + prefix);
	
	if (cache == "init" || cache == "all" ) {
		geoGetHtmlFile('tmpxml/' + 'cache_palette.html','geoDataPalette');
	
		/* garder en dernier le chargement des pallettes qui sert de test dans geoCheckAvantGridInit */
		/* pour v�rifier que toutes les donn�es sont charg�es */
		}
	
		/* flag indiquant que les donn�es sont charg�es */
		$("#geoData").attr('title', 'loaded');	
		

}

/**
 * Lecture d'un fichier HTML contenant les donn�es statiques
 * et recopie dans le div cach� correspondant
 * @param file
 * @param divData
 * @return
 */
function geoGetHtmlFile(file,divData) {
	// geoAlert("get file " + file);
	/* on vide la zone, en cas de rechargement */
	$("#" + divData).empty();
	// oAlert("#" + divData + " vid�e");
	
	$.post(file, function(data) {
		$("#" + divData).html(data);
		  // geoAlert('chargement de ' + data);
		  $('#geoMessage').dialog('close');
		});	

}

/* Gestion d'une requete vers PB Server */
function geoRequete(requete,push) {
	geoAlert('geoRequete : ' + requete); 
	geoStoreHistory(requete,push);
	geoAfficheMessage();

	/* on regarde si l'url contient d�j� le nom de la servlet sinon on le rajoute*/
	if(requete.indexOf("PBServlet",0) == -1) {
		requete = "PBServlet?httpPBCommand=" + requete;
	}
	$.get(requete + "&nocache=" + Math.random(), function(response, status, xhr) {
		manageReponse(response, status, xhr);
	});
	
	/* gestion  des erreurs Ajax */
	gestionErreurAjax();

	}


/* Gestion d'une requete vers PB Server */
function geoRequetePost(requete,data,push) {
	geoAlert('geoRequete : ' + requete); 
	geoStoreHistory(requete,push);
	geoAfficheMessage();

	/* on regarde si l'url contient deja le nom de la servlet sinon on le rajoute*/
	if(requete.indexOf("PBServlet",0) == -1) {
		requete = "PBServlet?httpPBCommand=" + requete;
	}
	$.post(requete + "&nocache=" + Math.random(), data, function(response, status, xhr) {
		manageReponse(response, status, xhr);
		});
	
	/* gestion  des erreurs Ajax */
	gestionErreurAjax();

	}

/* Gestion d'une requete vers PB Server */
function geoRequeteDepuisFormulaire(frame,formulaire,push) {
	//alert('geoRequeteDepuisFormulaire : ' + formulaire); 
	
	//var requete = 'PBServlet?httpPBCommand=choix_perimetre&FOU_1=on&which_button=SET_REPVARCALCOL_DET';

	var requete = "PBServlet?" + $('#' + formulaire).serialize();
	geoStoreHistory(requete,push);

	//alert(requete);
	document.getElementById(frame).contentDocument.location.href = requete;
	return false;
}


/*Fonction activ�e uniquement si il y a une erreur dans une requete Ajax 
l'appel � cette fonction doit �tre ajout� apr�s tout requ�te Ajax sans gestion
explicite des erreurs */
function gestionErreurAjax() {
	$("#geoColonneMilieu").ajaxError(function(event, request, settings){
		   $(this).append("<li>Error requesting page " + settings.url + "</li>");
		 });
	
}

/* utilitaire pour mettre � jour la zone de contexte */
function geoUpdateContexte(valeurContexte) {
	$('#geoContexte').show();
	$('#geoContexte').html(valeurContexte);
}

/****************** Gestion des formulaire ******************/
function manageSubmit(formID,push) {
// alert("manage submit pour " + formID);

var requete = "PBServlet?" + $('#' + formID).serialize();
geoStoreHistory(requete,push);	
	
var options = { 
        success:       showResponse,
        error :        errorResponse
};

// Supprime l'attribut 'disabled' des input sinon leur valeur n'est pas prise en compte dans le formulaire
$("input").removeAttr("disabled");
$('#' + formID).ajaxSubmit(options);


}

function manageSubmitXML(formID) {
	// alert("manage submit pour " + formID);

	var options = { 
	        dataType: 	   'xml',
			success:       showResponse,
	        error :        errorResponse
	};

	// Supprime l'attribut 'disabled' des input sinon leur valeur n'est pas prise en compte dans le formulaire
	$("input").removeAttr("disabled");
	$('#' + formID).ajaxSubmit(options);


	}

function errorResponse(responseText, statusText, xhr, $form)  { 
	geoAlert("errorResponse " + statusText);
}

function showResponse(responseText, statusText, xhr, $form)  { 
	// alert("showResponse " + responseText);
	manageReponse(responseText, statusText, xhr);
}

function manageReponse (response, status, xhr) {
	// geoAlert("reponse servlet recue, responseXML = : \n" +  "'" + xhr.responseXML + "'");
	// geoAlert("reponse servlet recue, responseText = : \n" +  "'" + xhr.responseText + "'");

	var reponseHTML = true; /* par d�faut, on consid�re qu'on re�oit du HTML */
	
	// On traite d'abord le cas d'une grille
	/* on va d'abord chercher s'il y a du pur XML dans la reponse */
	if (xhr.responseXML != null) {
		/* il peut s'agir d'une grille sous onglet ('grille')*/
		var typeDonnees = $(response).find('type');
		
		geoAlert("type = " + typeDonnees.text());
		if (typeDonnees.text() === 'grille' || typeDonnees.text() === 'grillepop' ) {
			/* flag pour ne pas s'embarquer ensuite dans la gestion HTML */
			reponseHTML = false;
			/* gerer la reponse de type grille */
			geoGridManageReponse(response, status, xhr);			
		} 
		else { // ce n'est pas une grille, juste du XML
				manageReponseXML(response, status, xhr);
			}
		
	}
	
	
	/* on exploite ensuite les donn�es HTML (sauf si on a re�u une grille)*/
	if(reponseHTML == true) {
		manageReponseHTML(response, status, xhr);
	}
	
	/* on cache la fenetre d'attente */
	$("#geoMessage").hide();
	
	/* on active les eventuels composant $ */
	rechargerComposants(response);
}

function manageReponseXML(response, status, xhr) {
	 // alert("manageReponseXML :\n " + response + " \n status = " + status);

	/* on cherche d'abord les champs inputs � modifier */
	var inputs = $(response).find('input');
	//geoAlert(inputs.length);
	
	/* Pour chaque input  */
	/* on lit l'attribut "ok" et l'attribut "id" */	
	/* on modifie la classe de l'input qui a le meme id en fonction de la valeur */
	/* de l'attribut ok */
	$(inputs).each(function(index) {
	    // geoAlert(index + ' : ' + $(this).text());
	    var idCible = $(this).attr("id");
	    var ok = $(this).attr("ok");
	    // geoAlert("idCible " + idCible + " ok = " + ok);
	    
	    if(ok == 'false') {
	    	/* le champ est en erreur */
//	    	$("#" + idCible).removeClass().addClass('inputTextError');

	    } else {
	    	/* le champ est OK */
//	    	$("#" + idCible).removeClass().addClass('inputText');
	    } 
	  });		
	
	
	geoChercheMessage(response);
	
}

function geoChercheMessage(response) {
	
	/* on cherche les messages � afficher */
	var msgs = $(response).find('msg');
	
	if(msgs.length == 0) {
		/* pas de message */
		/* on cache le div des messages au cas o� */
		$("#geoErreur").dialog('close');
	} else {
		//alert(msgs.length + " messages");
		/* on vide la table des messages */
		$("#geoTableMessages").empty();
		/* on met � jour le titre */
		$("#geoErreur").dialog("option","title","Information");

			/* Pour chaque message  */
			/* on prend le contenu */	
			/* et on cree une ligne dans la table des messages */
		$(msgs).each(function(index) {
			    // geoAlert(index + ' : ' + $(this).text());		
			$("#geoTableMessages").append("<tr><td>" + $(this).text()+ "</td></tr>");
			});
			/* cacher la fenetre d'attente et montrer la fenetre des erreurs */
		    $("#geoMessage").hide();
			$("#geoErreur").dialog('open');
			}	
	
}

function manageReponseHTML(response, status, xhr) {
	//geoAlert("manageReponseHTML :\n " + response + " \n status = " + status);

 /* on va chercher dans la r�ponse qui doit etre du vrai xhtml avec balise englobantes */
/* l'�l�ment souhait� dont on prend le contenu html */

/* etape 1 : on affecte la string contenue dans response au div geoDOMConversion */
/* => la string est convertie en objet DOM */
/* semble necessaire pour IE 6 par pour IE7 ni IE8*/
// geoAlert("IE = " + getInternetExplorerVersion());
	
	var ieVersion = getInternetExplorerVersion();

	if(ieVersion == 6) {
		geoAlert('IE6 : geoDOMConversion');
	$('#geoDOMConversion').html(response);
	}

// geoAlert("GeoCOnversion: " + document.getElementById('geoDOMConversion').innerHTML);
/* on cherche tous les elements target, */
	
	/* etape 1.1  : chargement de donn�es dans le cache */
	/* il y a un div  de classe geoCache. Si l'attribut "cache" de ce div est renseign� alors */
	/* on d�clenche le chargement correspondant � la valeur de l'attribut */
	
	/**
	 *  PAS ACTIF : pour activer d�commenter les appels � geoInitCache geoCheckAvantGridInit
	 *  et enlever  l'appel direct � geoGridInit 
	 *  Le cache est initialis� en meme temps que geoGridInit en lisant le fichier qui est mis � jour � la main
	 **/
	var cache = $(response).find('div.geoCache'); /* recherche directe dans la response */
	$(cache).each(function(index) {
	var cacheValue  = $(this).attr("cache"); 
	var prefix  = $(this).attr("cacheprefix"); 

		// geoAlert("cache (PAS ACTIF)= " + cacheValue + " prefix=" + prefix);
		/* le chargement est d�clench� seulement si le prefix est renseign� */
		/* ce pr�fixe donne le num�ro de la station (? � v�rifier) */
		if(cacheValue == "init" && prefix != "") {
			geoAlert("Chargement initial");
			
			 	//geoInitCache(cacheValue,prefix);

				/* lors de la toute premi�re initialisation de cache, il faut */
				/* aussi initialiser les grilles */
				/* concr�tement : lors de la premi�re connexion */
				if(cacheValue == "init") {
					/* s'assurer que les donn�es sont dispo avant de lancer */
					/* l'init des grilles avec une tempo */
						/* premiere init */
						//geoCheckAvantGridInit(false,cacheValue);
				} else {
						/* reinit apres chargement cache */
						//geoCheckAvantGridInit(true,cacheValue);
				}
			}
	    });
	

/* etape 2 : on cherche les div qui ont la classe geoTarget */
/* ils identifient des cibles */
var targets;
if(ieVersion == 6) {
	targets = $('#geoDOMConversion').find('div.geoTarget'); /* recherche dans geoDOMConversion */
} else {
	targets = $(response).find('div.geoTarget'); /* recherche directe dans response */
}
// geoAlert("targets length : " + targets.length)


/* etape 3 : pour chaque target : on prend le contenu  de l'�l�ment */
/* et on l'affecte  � l'�l�ment qui a le m�me id que la target */		
$(targets).each(function(index) {
    // geoAlert(index + ' : ' + $(this).text());
    var idCible = $(this).attr("id");
    // geoAlert("idCible " + idCible);
    var contenu = $(this).children();
    $("#" + idCible).html(contenu);
  });	

/* y a t'il une target pour un div flottant */
var targetsF = $(response).find('div.geoTargetFlottant');
var titre;
var width; /* largeur du dialogue flottant */
$(targetsF).each(function(index) {
    // geoAlert(index + ' : ' + $(this).text());
    var idCible = $(this).children("div").attr("id");
     titre = $(this).children("div").attr("title");
     width = $(this).children("div").attr("width");
    // geoAlert("idCible " + idCible);
    var contenu = $(this).children();
    
    /* le div flottant est ajoute au body */
    $("#geoBody").append(contenu);
    
    /* on rend le contenu  visible */
    // alert("cible " + idCible);
    $("#" + idCible).show();
  });

/* les div flottants (un seul � la fois!) sont des dialogues depla�able */
if(targetsF.length > 0) {
		$(".geoContainerFlottant").dialog({
			close: function(event, ui) {
				$(this).dialog('destroy');
				$(this).remove(); /* � v�rifier */
			}
		});
		// $( ".geoContainerFlottant" ).dialog( "option", "position", [200,200] );
		// pas de position particuli�re : le dialogue est centr� par d�faut
		$( ".geoContainerFlottant" ).dialog( "option", "title", titre );
		/* taille du container en fonction de son utilisation */
		if(width == undefined) {
			/* taille par defaut */
			width=600;
		}
		$( ".geoContainerFlottant" ).dialog( "option", "width", width );
		$( ".geoContainerPourMessage" ).dialog( "option", "width", 400 );

    }


	/* si parmi les targets, il y a la colonne de gauche ou du milieu */
	/* les onglets doivent apparaitre et le div de login doit etre vid�*/
	/* et inversement */
	if (response.indexOf('geoColonne') != -1 ) {
		$("#geoOnglets").fadeIn("slow");
		$("#geoColonneMilieu").show();
		$(".geoColonneMilieuGrille").hide();
		$("#geoIframeContainer").dialog('close');
		$("#geoLogin").empty();
	} else if (response.indexOf('geoLogin') != -1 ) {
		//geoAlert("sho login");
		$("#geoLogin").fadeIn("slow");
		$("#geoOnglets").hide();
		
		/* initialisation des grilles la premiere fois */
		if(geoGridInitFlag == false) {
			geoInitCache("init","");
			geoCheckAvantGridInit(false,"");
		}
	} else if (response.indexOf('geoContainerTraceabilite') != -1 ) {
		/*cas du container flottant : on l'affiche sans toucher au reste*/
		$("#geoTraceabiliteDialog").dialog("open");
	} else if (response.indexOf('geoContainerChoixOrdre') != -1 ) {
		/*cas du container flottant : on l'affiche sans toucher au reste*/
		$("#geoChoixOrdreDialog").dialog("open");
		/* on s'assure que tous les choix sont deselectionn�s */
		 $(".listeMultiCheck").multiselect("uncheckAll");
		 $(".listeMultiCheck").multiselect("open");
		 alert("OK");
		 $(".listeMultiCheck").multiselect("open");

    }
}

/**
 * cacher l'element pass� en param�tre si hideornot n'est pas null
 */
function hideElement(element,hideOrNot) {
	if (hideOrNot != null && hideOrNot == "true") {
		element.style.display="none";
	}
}

/**
 * Preparation de l'iframe destin�e � accueilir un document PDF ou fichier quelconque
*/
function geoPrepareIframe(targetIframe,push) {
	//alert("prepare iframe " + targetIframe);
	//geoStoreHistory(push);
	// geoAfficheMessage();	
/* si PDF , l'iframe devient visible */
if(targetIframe == 'geoIframe') {
	//alert("montre iframe");
	/* on cache le milieu et on montre l'iframe */
	// $('#geoColonneMilieu').hide();	
	$('#geoIframeContainer').dialog('open');
	}
}

/**
 * Affichage du composant de message
 */
function geoAfficheMessage(message) {
/* si un message est pass� en param�tre, on le met � jour */
/* en utilisant le composant pour afficher les messages d'erreur */
if(message != null) {
	// $('#geoErreur').attr("title","Information");

	$("#geoTableMessages").empty();
	
	/* on prend le message */	
	/* et on cree une ligne dans la table des messages */
		
	$("#geoTableMessages").append("<tr><td>" + message + "</td></tr>");

	$('#geoErreur').dialog( "option", "title", "Information" );
	$('#geoErreur').dialog('open');
	}
	else {
		/* pas de message, on montre juste le composant d'attente */
		$('#geoMessage').show();
		}
	
}

function geoIframeChangeEtat() {
	geoAlert("iframe nouvel etat" + document.getElementById('geoIframe').readyState);
    if(document.getElementById('geoIframe').readyState == 'complete') 
    { 
        geoAlert("iframe charg�e");
        $('#geoMessage').hide();
    } 
} 

/** tentative malheureuse de scrutation de l'iframe */
/* non utilis�e */
function nonutilisee_geoOpenIframe(iframe) {
	geoAlert('openIframe' + iframe);
	/* montrer le message d'attente */
	$('#geoMessage').show();
	/* cacher le milieu */
	$('#geoColonneMilieu').hide();	
	
	var targetIframe = document.getElementById(iframe);
	/* on vide l'iframe */
	targetIframe.src="html/empty.html";
	
	/* on lance l'analyse */
	geoAnalyseIframe();
}

function nonutilisee_geoAnalyseIframe() {
	//geoAlert('analyseIframe');
	var targetIframe = document.getElementById('geoIframe');
	var docIframe = targetIframe.contentDocument || targetIframe.contentWindow.document; // standard ou IE
	//geoAlert(docIframe.body.innerHTML);
	var inner = docIframe.body.innerHTML ;
	var flagEmpty =  inner.indexOf("DIV_EMPTY") || inner  == "" ;
	
	if(flagEmpty != -1 ) {
		/* l'iframe est encore vide */
		/* on continue � scruter */
		setTimeout(geoAnalyseIframe,1000);
	}
	else {
		/* sinon */
		 /* on masque le message d'attente */
		$('#geoMessage').hide();
		 /* on analyse le contenu */	
			 /* si on trouve un code d'erreur */
		if(inner.indexOf("404") != -1 ) {
			/* on masque l'iframe */
			$('#geoIframeContainer').dialog('close');
			 /* on affiche la fenetre des erreurs */
			geoAlert('erreur 404');
		} else {
			/* on regarde le contenu de l'iframe : si c'est du PDF, on affiche l'iframe */
			// geoAlert("inner = " + inner);
			/* pas d'erreur : on affiche l'iframe */
			$('#geoIframeContainer').dialog('open');
		}
	}
}



/************** Gestion de l'historique *************/

function geoStoreHistory(requete,push) {
	if(undefined == requete) {
		geoAlert("requete undefined non stockee");
		return;
	}
	/* stockage de l'historique si le parametre n'est pas renseign� ou s'il vaut true ou blanc */
	if(push != "false") {
		geoAlert('storeHistory : ' + requete);
		globalHistory.push(requete);
	}
}
/**
 * remise � zero de l'history
 */
function geoCleanHistory() {
	while(globalHistory.length) {
		globalHistory.pop();
	}
}

function geoRestoreHistory() {
	/* on enl�ve la derniere requete */
	var derniere_requete = globalHistory.pop();
	
	/* on recupere la requete precedente */
	var hist = globalHistory.pop();
	geoAlert("restoreHistory : " + hist);
	if(hist != undefined) {
		geoRequete(hist,"false"); /* execution de la derniere requete sans stockage */
		globalHistory.push(hist);
	} else {
		geoAlert("requete undefined non restoree");
		/* on remet la derniere requete */
		globalHistory.push(derniere_requete);
		
	}
	 /* on masque le message d'attente au cas o�*/
	//$('#geoMessage').hide();
	
	//rechargerComposants();
}

/****************************************************/
/************** Gestion du contexte *************/

function storeContexte(nom) {
	geoAlert('storeContexte');
	var newContexte = new GeoContexte(nom,$("#geoBody").html());
	globalContexte.push(newContexte);
}

/**
 * declaration des onglets, triable pour le fun
 */
/*
$(function() {
	// geoAlert("chargement onglet")
	$("#tabs").tabs().find(".ui-tabs-nav").sortable({axis:'x'});
	// geoAlert("onglet charg�s");
});*/

/* fonction de rechargement � utiliser lors d'un "back" */
function rechargerComposants(response) {
		/* rechargement systematique de certains composants */
		$("#geoOnglets").tabs(); 
		$(":button").button();
		/* activation des eventuels boutons */
		$("button, a", ".desBoutons").button();
		/* la fenetre des erreurs est un div flottant depla�able */
		/* avec un bouton OK */
		$("#geoErreur").dialog({
			    modal:true,
				autoOpen:false,
				buttons: {
				OK: function() {
					$(this).dialog('close');
					}
				}
		});
		
	    $("#geoIframeContainer").dialog({
	        modal:true,
	        autoOpen:false,
	        resizable:true,
	        minHeight:600,
	        width:800,
	        dialogClass:'geoIframeContainerDialog',
	        close: function( event, ui ) {
	        	$('#geoMessage').hide(); // on cache le patienteur pour �viter qu'il reste inopportun�ment
	        	
	        }

	});
		
	    $("#geoTraceDialog").dialog({
    	    modal:false,
            width:600,
            minHeight: 100,
    		autoOpen:false,
    		buttons: {
    			Effacer: function() {
    				$("#geoTraceContainer").empty()
    				}
    			}
    });
	    
		/* les elements de classe "listeDrop" sont transformes en combobox autocomplete */
		$(".listeDrop").combobox({inputSize:30}); /* limitation de la taille en largeur */


    
		    $(".jcalendrier").datepicker( {dateFormat: 'dd/mm/yy'});
		    $.datepicker.setDefaults($.datepicker.regional['fr']);
		    
			/* activation eventuelle des time picker */
			/* voir http://labs.perifer.se/timedatepicker/ */
			$(".timePicker").timePicker({step:1});
		
		/* rechargement de l'accordeon seulement si present dans la reponse ou */
		 /* si pas de reponse (cas du back */
		if(response == null || response.indexOf('geoListeAccordeon') != -1){
			$("#geoListeAccordeon").accordion({ animated: 'bounceslide' },{ autoHeight: false },{collapsible: true},{active:"none"});
			} 	
}


/* utilitaire pour tester la version IE */
function getInternetExplorerVersion() {

    var rv = -1; // Return value assumes failure.

    if (navigator.appName == 'Microsoft Internet Explorer') {

        var ua = navigator.userAgent;

        var re = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");

        if (re.exec(ua) != null)

            rv = parseFloat(RegExp.$1);

    }

    return rv;

}

/* fonction de trace */
function geoAlert(message) {
	if(GEO_TRACE == false) {
		/* mecanisme de trace desactiv� */
		return ;
	}
	
	// alert("geoAlert = " +GEO_ALERT);
	
	if(GEO_ALERT == true) {
		//alert(message);
	} else {
		var oDate = new Date();
		var current = $.format.date(oDate,"dd/MM/yyyy HH:mm:ss");
		//alert("date OK");
		var traceContainer = top.document.getElementById("geoTraceContainer");
		//alert(traceContainer);
		traceContainer.innerHTML = traceContainer.innerHTML +  "<pre class='geoTrace'>" + current + " => " + message + "</pre>";
	}
}
/*********************************************************/



/** equivalent � : $(document).ready(function() **/
$(function() {
	//geoAlert("chargement onglet")
	$("#geoOnglets").tabs({ selected: 2 },{success:function(){geoAlert('hello world')}}); 
	$(":button").button();
	/* activation des eventuels boutons */
	$("button, a", ".desBoutons").button();
	/* accordeon  pouvant n'avoir aucune section ouverte et ferm� au d�marrage */
	$("#geoListeAccordeon").accordion({ animated: 'bounceslide' },{ autoHeight: false },{collapsible: true},{active:"none"});

	/* les elements de classe "listeDrop" sont transformes en combobox autocomplete */
	$(".listeDrop").combobox({inputSize:30});
	
	/* les elements de classe "listeMultiCheck" sont transformes en combobox avec multi check */
	// $(".listeMultiCheck").multiselect();
	
	/* la fenetre des erreurs est un div flottant depla�able */
	/* avec un bouton OK */
	$("#geoErreur").dialog({
		    modal:true,
			autoOpen:false,
			buttons: {
			OK: function() {
				$(this).dialog('close');
				}
			}
	});

    $("#geoIframeContainer").dialog({
        modal:true,
        autoOpen:false,
        resizable:true,
        minHeight:600,
        width:800,
        dialogClass:'geoIframeContainerDialog'
});
	// document.getElementById('geoIframe').onreadystatechange = geoIframeChangeEtat; 	
	
    /* container flottant pour la traceabilit� */
	$("#geoTraceabiliteDialog").dialog({
			modal:true,
			autoOpen:false,
			buttons: {
				"Fermer": function() {
					$(this).dialog('close');

					},
				"Sauver": function() {
						geoGridSauverTraceabilite("geoTraceabiliteDialog");
						$(this).dialog('close');
						}
				},
			close: function(event, ui) {
				$(this).dialog('close');
			},
			resizable:true,
			width:930
			});		

    /* container flottant pour le choix des article (sous forme de grille) */
	$("#geoGridChoixArticlesContainerPop").dialog({
			modal:true,
			autoOpen:false,
			buttons: {
				"Fermer": function() {
					$(this).dialog('close');

					},
				"Valider": function() {
					geoGridValiderChoixArticles("geoGridChoixArticles"); /* on passe l'id de la grille */
						$(this).dialog('close');
						}
				},
			close: function(event, ui) {
				$(this).dialog('close');
			},
			resizable:true,
			width:900
			});		
	

	
    /* la fenetre des traces est un div flottant depla�able */
    /* avec un bouton OK */
    $("#geoTraceDialog").dialog({
    	    modal:false,
            width:600,
            minHeight: 100,
    		autoOpen:false,
    		buttons: {
    			Effacer: function() {
    				$("#geoTraceContainer").empty()
    				}
    			}
    });

});

/** analyser le changement de valeur d'un champ input d'un detail **/
function analyseChange(name,value) {
	
	var erreur = false;
	var elementCourant = document.getElementById(name);
	
	// verification de la saisie : champs numeriques
	// si pas numerique, aucun calcul et champ pass� en rouge
	// le champ doit etre non vide
	// si vide, on lui affecte la valeur 0
	if(value == "") {
		value = "0";
		elementCourant.value = "0";
	}
	if(isNaN(value)) {
		elementCourant.className = "inputTextError" ;
		erreur = true;
	} else {	
		elementCourant.className = "inputText" ;
	}
	
	
// alert("change value : " + name + "value = " + value);

var lettre = name.charAt(0);
var numero = name.substring(2);

// alert("lettre " + lettre + "numero " + numero);

// on ne fait rien pour les champs qui ne sont pas totalisable
// (nb palette, nb colis, poids brut, poids net
if( lettre != "O" && lettre != "N" && lettre !="M" && lettre !="P" && lettre !="Q") {
	return;
}


// si la modification concerne le nombre de colis
// on recalcule les autres champs si pas d'erreur
if(lettre == "N" && erreur == false) {
	var nbColis = document.getElementById("N_" + numero).value;	
	calculPoids(nbColis,numero,true);
	}

/* si la modification concerne le nombre de palette */
/* on calcule le nombre de colis si le nb de colis par palette est renseign�*/
/* et on recalcule les poids */
else if(lettre == "M" && erreur == false) {
	var nbColisParPalette = document.getElementById("O_" + numero).value;
	//alert(nbColisParPalette);
	if(nbColisParPalette != "" && nbColisParPalette != "0") {
		var nbColis = parseInt(value)*parseInt(nbColisParPalette);
		document.getElementById("N_" + numero).value = nbColis;
		calculPoids(nbColis,numero,true);
		// focus sur nombre de colis
		document.getElementById("N_" + numero).focus();
	}
}
/* si la modification concerne le nombre de colis par palette */
/* on calcule le nombre de colis */
/* et on recalcule les poids */
else if(lettre == "O" && erreur == false) {
	var nbPalettes = document.getElementById("M_" + numero).value;
	if( nbPalettes != "" && nbPalettes != "0") {
		var nbColis = parseInt(value)*parseInt(nbPalettes);
		document.getElementById("N_" + numero).value = nbColis;
		calculPoids(nbColis,numero,true);
		// focus sur nombre de colis
		document.getElementById("N_" + numero).focus();
	}
} 

/* si la modification concerne les poids net */
else if(lettre == "Q" && erreur == false) {
	var nbColis = document.getElementById("N_" + numero).value;	
	calculPoids(nbColis,numero,false);
} 
// mettre � jour les totaux 
calculTotal();


// on met le focus sur le champ palette suivant
// si il y en a un et si le chmap courant est le nombre de colis
// et si il n'y a pas d'erreur
if(erreur == false) {
	if(lettre == "N"){
		var numeroSuivant = parseInt(numero) + 1 ;
		var paletteSuivant = "M_" + numeroSuivant;
		if(document.getElementById(paletteSuivant) != null) {
			document.getElementById(paletteSuivant).focus(); 
		}
	}
} else {
	// focus sur champ en erreur
	// alert("focus sur champ courant");
	elementCourant.focus();
}

}


// recalculer les totaux des champs palettes, colis, poids brut, poids net 
function calculTotal() {
var allInputText = new Array();
allInputText= document.getElementsByTagName("input");

var totalPalette = 0 ;
var totalColis = 0 ;
var totalBrut= 0 ;
var totalNet = 0 ;
var ignorePalette = false;
var ignoreColis = false;
var ignoreBrut = false;
var ignoreNet = false;


for(i=0 ; i < allInputText.length;i++) {
	if(allInputText[i].name.charAt(0) == "M" && ignorePalette == false) {
		//alert(allInputText[i].name);
		if(isNaN(allInputText[i].value)) {
			totalPalette = "Erreur";
			ignorePalette = true;
		} else {
			totalPalette = parseInt(allInputText[i].value) + totalPalette;
		}

	} else if (allInputText[i].name.charAt(0) == "N" && ignoreColis == false) {
		//alert(allInputText[i].name);
		
		if(isNaN(allInputText[i].value)) {
			totalColis = "Erreur";
			ignoreColis = true ;
		} else {
			totalColis = parseInt(allInputText[i].value) + totalColis;
		}

	}else if (allInputText[i].name.charAt(0) == "P" && ignoreBrut == false) {
		//alert(allInputText[i].name);
		if(isNaN(allInputText[i].value)) {
			totalBrut = "Erreur";
			ignoreBrut = true ;
		} else {
			totalBrut = parseInt(allInputText[i].value) + totalBrut;
		}

	}else if (allInputText[i].name.charAt(0) == "Q" && ignoreNet == false) {
		//alert(allInputText[i].name);
		if(isNaN(allInputText[i].value)) {
			totalNet = "Erreur";
			ignoreNet = true ;
		} else {
		totalNet = parseInt(allInputText[i].value) + totalNet;
		}

	}
	
}

document.getElementById("totpal").innerHTML = totalPalette;
if(ignorePalette == true) {
	document.getElementById("totpal").className = "inputTextError"	;
} else {
	document.getElementById("totpal").className = "inputText"	;
}
document.getElementById("totcol").innerHTML = totalColis;
if(ignoreColis == true) {
	document.getElementById("totcol").className = "inputTextError"	;
} else {
	document.getElementById("totcol").className = "inputText"	;
}
document.getElementById("totbrut").innerHTML = totalBrut;
if(ignoreBrut == true) {
	document.getElementById("totbrut").className = "inputTextError"	;
} else {
	document.getElementById("totbrut").className = "inputText"	;
}

document.getElementById("totnet").innerHTML = totalNet;
if(ignoreNet == true) {
	document.getElementById("totnet").className = "inputTextError"	;
} else {
	document.getElementById("totnet").className = "inputText"	;
}
}

function DecimalToString(nVal){
	/*
	strVal=nVal.toString();
	c=strVal.indexOf(".");
	int=strVal.substring(0,c);
	dec=strVal.substring(c+1,strVal.length);
	return int+","+dec;
	*/
	strVal = nVal + "";
	return strVal.replace('.',',');
}

function calculPoids(nbColis,numero,bCalculPds) {
// on recupere les valeurs des champs utiles pour le calcul (ici,ce sont des float)
var strUniteVte = document.getElementById("RU_" + numero).value;
var strUniteAch = document.getElementById("SU_" + numero).value;
var fPdsNet;
var hiddenW = document.getElementById("W_" + numero).value;
var hiddenX = document.getElementById("X_" + numero).value;
var hiddenY = document.getElementById("Y_" + numero).value;
var hiddenZ = document.getElementById("Z_" + numero).value;
var value = "";

// pour que les variables ci dessus soient utilisables en tant que float, la virgule
// doit etre remplacee par un point
hiddenX = hiddenX.replace(",",".");
hiddenY = hiddenY.replace(",",".");
hiddenZ = hiddenZ.replace(",",".");
hiddenW = hiddenW.replace(",",".");


//alert("X =" + hiddenX + " Y =" + hiddenY +  " Z =" + hiddenZ + " W =" + hiddenW);
oObjectQ = document.getElementById("Q_" + numero);

if( oObjectQ.disabled == true )
{
	// On rempli que dans le cas du pr�pes�, c'est � dire quand les champs sont verrouill�s.
	// calcul effectue avec arrondi a l'entier le plus proche
	document.getElementById("P_" + numero).value =  Math.round(hiddenY*nbColis);
	document.getElementById("Q_" + numero).value =  Math.round(hiddenZ*nbColis);
	document.getElementById("R_" + numero).value =  Math.round(hiddenW*nbColis);
	document.getElementById("S_" + numero).value =  Math.round(hiddenX*nbColis);
}

if( oObjectQ.disabled == false )
{
	//alert(document.getElementById("Q_" + numero).value + " - " + strUniteVte + " - " + strUniteVte);
	switch(strUniteVte)
	{
		case "TONNE":
			value = DecimalToString(document.getElementById("Q_" + numero).value / 1000);
			document.getElementById("R_" + numero).value  = value;
			break;
		case "KILO":
			document.getElementById("R_" + numero).value  = document.getElementById("Q_" + numero).value;
			break;
		default:
			if( bCalculPds == true ) document.getElementById("P_" + numero).value =  Math.round(hiddenY*nbColis);
			if( bCalculPds == true ) document.getElementById("Q_" + numero).value =  Math.round(hiddenZ*nbColis);
			if( bCalculPds == true ) document.getElementById("R_" + numero).value =  Math.round(hiddenW*nbColis);
			break;
	}
	switch(strUniteAch)
	{
		case "TONNE":
			value = DecimalToString(document.getElementById("Q_" + numero).value / 1000);
			document.getElementById("S_" + numero).value  = value;
			break;
		case "KILO":
			document.getElementById("S_" + numero).value  = document.getElementById("Q_" + numero).value;
			break;
		default:
			if( bCalculPds == true ) document.getElementById("P_" + numero).value =  Math.round(hiddenY*nbColis);
			if( bCalculPds == true ) document.getElementById("Q_" + numero).value =  Math.round(hiddenZ*nbColis);
			if( bCalculPds == true ) document.getElementById("S_" + numero).value =  Math.round(hiddenX*nbColis);
			break;
	}
}

//alert(hiddenY*nbColis + "->" + Math.round(hiddenY*nbColis));
//alert(hiddenZ*nbColis + "->" + Math.round(hiddenZ*nbColis));
//alert(hiddenW*nbColis + "->" + Math.round(hiddenW*nbColis));
//alert(hiddenX*nbColis + "->" + Math.round(hiddenX*nbColis));



}

/**
 * detection d'un changement dans un formulaire (non utilis� mais appel� par jquery)
 */
function geoFormChange(oInput)
{
	var numero;
	var str;
	
	if(typeof oInput !== 'undefined')
	{
		str = oInput.id.split("_");
		numero = str[str.length - 1];
		
		if( oInput.id.substring(0, 7) == 'nb_pal_' || oInput.id.substring(0, 12) == 'nb_palinter_' || oInput.id.substring(0, 8) == 'col_pal_' )
		{
			var nb_pal      = Number(document.getElementById("nb_pal_" + numero).value);
			var nb_palinter = Number(document.getElementById("nb_palinter_" + numero).value);
			var col_pal     = Number(document.getElementById("col_pal_" + numero).value);
			
			nb_col = nb_pal * (nb_palinter + 1) * col_pal;
			
			document.getElementById("nb_col_" + numero).value = nb_col;
		}
	}
}



/**
 * Avant d'initialiser les grilles, on v�rifie que les donn�es
* du cache local sont bien renseign�es, sinon on attend
* on teste uniquement les donn�es correspondant au dernier fichier charg�
* (les palettes).
* @param {Object} reinit : boolean : est ce une reinit ou une premiere init
* @param {Object} cache : nature du cache qui a �t� charg�
*/
function geoCheckAvantGridInit(reinit, cache) {
	
	var palette = $("#geoDataPalette > div");
	
	if (palette.length > 0) {
		if(reinit == true) { /* reinit apres rechargement du cache */	 
		geoGridReInit(cache);		
		} else {
		geoGridInit(); /* premiere init */			
		}
	}
	else {		
		setTimeout(function () {geoCheckAvantGridInit (reinit,cache);},250);
	}
}

/**
 * reinitialisation des grilles (ne fait rien)
 * concern�es par le type de cache qui a �t� recharg�
 * @param {Object} cache
 */
function geoGridReInit(cache) {

}

/**
 * changer la classe d'un element non lu en lu
 * @param element
 * @param etat
 */
/*
function geoChangeClasse(element,etat) {
	
	if(etat == "non_lu") {
		$(element).removeClass("a_nonlu");
		$(element).addClass("a_lu");

	}
}
*/

var element_class = null;

function geoChangeClasse(element,etat)
{
	if( current_element != null)
	{
		$(current_element).removeClass("a_active");
		$(current_element).addClass(element_class);
	}
	
	if(etat == "non_lu") {
		$(element).removeClass("a_nonlu");
		$(element).addClass("a_lu");
	}

	element_class = $(element).attr('class');  
	$(element).removeClass(element_class);
	$(element).addClass("a_active");
	current_element = element;
}

/**
 * Acquiter
 */
function geoValiderImport() {
    var fournisseur = $('#geoContexte').text(); /* le champ contexte contient le fournisseur choisi */
    var proprio = $('#combo_proprio').val();

    var requete = "ask_stock_dem_qtt&prop_code=" + proprio + "&fou_code=" + fournisseur;
	geoRequete(requete);
	/* on ferme le dialogue appelant */
	$(".geoContainerFlottant").dialog('close');
	
}

/**
 * Changement de fournisseur
 */
function geoStockDemChangeFourni() {
    var proprio = $('#combo_proprio').val();
    var fournisseur = $('#geoContexte').text(); /* le champ contexte contient le fournisseur choisi */

	var requete ="ask_stock_dem_qtt&prop_code=" + proprio + "&fou_code=" + fournisseur;
	/* on recupere le proprio selectionné */
	geoAlert("demande de changement de proprio : " + requete);
	geoRequete(requete,0);
}

function geoStockPrecaChangeFourni() {
	/* on recupere le fournisseur selectionné */
    var fournisseur = $('#combo_fourni').val();
	var requete ="ask_stock_preca_qtt&fou_code=" + fournisseur;
	geoAlert("demande de changement de fournisseur : " + requete);
	geoRequete(requete,0);
}

/**
 * Recherche de CMR
 */
function rechercher_cmr() {

	var cmr = $('input[name$=cmr]').val()

    var requete = "ask_cmr=" + cmr;
	geoRequete(requete);
	
}
