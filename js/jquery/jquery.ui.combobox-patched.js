// Extra JQuery Extensions and Widgets
(function($) {
	$.widget("ui.combobox", 
		{options:{
			inputSize:0, // PATCH  si > 0 permet de limiter la taille affich�e de l'input
		    minLength:0, // PATCH option standard de autocomplete
			displayButton:true, // PATCH option permettant de ne pas afficher de bouton
			jqgrid:false // PATCH indique si la combobox est dans une jqgrid ou pas
			}, 
		_create: function() {
			var self = this;
			this.select = this.element.hide();
			var select = this.select;
			var id = select.attr('id');
			var initial = $(select).find(":selected").text();
			if (!initial){
				initial = '';
			}
			
			var optionMinLength = this.options.minLength;
			
			var topButton = "-1px";
			var widthButton = "16px";
			var heightButton = "16px";
			var margin_bottom = "0px"
						
			/* PATCH taille et position du bouton et de l'input sont ajust�es pour jqgrid */
			if(this.options.jqgrid == true) {
				topButton = "-1px";
				widthButton = "16px";
				heightButton = "16px";
				/* marge pour l'input seulement s'il y a un bouton */
				if( this.options.displayButton == true) {
					margin_bottom = "0px";
					}
			}
			
			var input = $("<input/>")
				.insertAfter(select)
				.val(initial)
				.autocomplete({
					last_item:null,
					source: function(request, response) {
					// PATCH : ajout de "^" pour matcher une chaine commen�ant
					// par l'expression recherch�e au lieu de contenant cette expression
						// Avril 2015 : pour geoweb, le matcher est de nouveau "contient l'expression
						var matcher = new RegExp(request.term, "i");
						response(select.children("option").map(function() {
							var text = $(this).text();
							if (this.value && (!request.term || matcher.test(text)))
								var last_item = {
										id: this.value,
										label: text.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + $.ui.autocomplete.escapeRegex(request.term) + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>"),
										value: text
									};
								this.last_item = last_item;
								return last_item;
						}));
					},
					delay: 0,
					change: function(event, ui) {
						if (!ui.item) {
							// remove invalid value, as it didn't match anything
							$(this).val("");
							return false;
						}
						
						$(select).val(ui.item.id);
						if (select.val() == '' || select.val() == null){
							select.val(ui.item.value);
						}
						self._trigger("selected", event, {
							item: select.find("[value='" + ui.item.id + "']")
						});
						this.current_item = ui.item;
						
					},
				/* PATCH : on rajoute la methode select */
				select: function(event, ui) {
						// PATCH : on appelle la fonction qui leve un flag
						// pour dire que la valeur du  champ a chang�
						geoFormChange();
						if (!ui.item) {
							// remove invalid value, as it didn't match anything
							$(this).val("");
							return false;
						}
						//alert('select');
						select.val(ui.item.id);
						self._trigger("selected", event, {
							item: select.find("[value='" + ui.item.id + "']")
						});
						/* PATCH : on stoppe la propagation des evenements pour ne pas */
						/* propager le "enter key" sur un select ce qui provoque */
						/* la sauvegarde de ligne dans le cas du jqgrid */
						event.stopPropagation();
						input.autocomplete("close");
					},
					minLength: optionMinLength
				}) //PATCH : rajout d'une marge bottom
				.addClass("ui-widget ui-widget-content ui-corner-left").css("margin-bottom",margin_bottom).click(function() {
					// close if already visible
					if (input.autocomplete("widget").is(":visible")) {
						input.autocomplete("close");
						return false;
					}
					// pass empty string as value to search for, displaying all results
					// en cliquant sur l'input, on vide le champ mais on n'affiche pas la liste
					// PATCH input.autocomplete("search", "");
					input.val("");
					input.focus();
					return false;
				});	
		
			/* PATCH on donne � l'input la taille correspondant � la taille de l'option la plus longue*/
			/* +2 pour le confort */
			/*  si inputSize est > 0 c'est cette valeur qui prime */
			var lenghtForInput=0;
			this.select.children("option").each(function(){
				
				if(this.text.length > lenghtForInput) {
					lenghtForInput = this.text.length;
				}
	
			});
	
			/* limitation de la taille de l'input � inputSize si renseign�e */
			if(this.options.inputSize > 0) {
				lenghtForInput = this.options.inputSize;
			}
			input.attr("size",lenghtForInput + 2);
			this.input = input;
						
			/* le bouton est optionnel */
			if(this.options.displayButton == true) {
				/*
				$("<button>&nbsp;</button>")
					.attr("tabIndex", -1)
					.attr("title", "Show All Items")
					.insertAfter(input)
					.button({
						icons: {
							primary: "ui-icon-triangle-1-s"
						},
						text: false
					}).removeClass("ui-corner-all")
					.addClass("ui-corner-right ui-button-icon").css("top",topButton).css("height",heightButton).css("width",widthButton)
					*/
				$("<img style='position:relative;top:4px;border:1px solid #A6C9E2;' src='images/drop.gif' width='16px' height='15px'/>")
					.attr("tabIndex", -1)
					.attr("title", "Show All Items")
					.insertAfter(input)
					.click(function() {
						// close if already visible
						if (input.autocomplete("widget").is(":visible")) {
							input.autocomplete("close");
							return false;
						}
						// pass empty string as value to search for, displaying all results
						input.autocomplete("search", "");
						input.focus();
						return false;
					});
			} else {
				// PATCH si pas de bouton les coins de droite sont ronds
				this.input.addClass("ui-corner-all")
			}
		},
		set: function (value){
			if (!value) {
				return false;
			}
			var select = this.select,
				input = this.input;
			this.select.children("option").each(function(){
				if (this.text == value){
					input.val(this.text);
					select.val(this.value);
					return false;
				};
			});
			
		},
		set_empty: function (value){
			if (this.input.val() == '' || this.input.val() == '---------'){
				this.set(value);
			}
		},
		initial: function (initial){
			if (!initial){
				initial = '';
			}
			this.input.val(initial);
		}
	});

})(jQuery);