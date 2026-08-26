$('#basicModal').on('show.bs.modal', function (event) {
    console.log ('modal : we are showing a modal');
    
    var triggerElement = $(event.relatedTarget) // Button that triggered the modal
    //var recipient = triggerElement.data('whatever') // Extract info from data-* attributes
    
    var widgetDataPosition = triggerElement.data('content-position');
    if (typeof widgetDataPosition == 'undefined' || widgetDataPosition.length == 0){
		widgetDataPosition = "parent";
	}
	
    var widget = triggerElement.parent();
    if(widgetDataPosition == "inside"){
		widget = triggerElement;
	}
	
	var widgetContentClassPrefix = triggerElement.data('content-class-prefix');
	if (typeof widgetContentClassPrefix == 'undefined' || widgetContentClassPrefix.length == 0){
		widgetContentClassPrefix = "widget";
	}
	
	 console.log ("modal : searching for modal content with CSS class prefix : " + widgetContentClassPrefix + " in : "  + widgetDataPosition);
	
    var bodyContent = widget.find('.'+widgetContentClassPrefix+'_content').html();
    console.log ("modal : body content : " + bodyContent);
    
    var bodyTitle = widget.find('.'+widgetContentClassPrefix+'_title').html();
    console.log ("modal : body title : " + bodyTitle);
    
    var bodyImage = widget.find('.'+widgetContentClassPrefix+'_image');
    console.log ("modal : image SRC attribute : " + bodyImage.attr('src') + ", body Images exists : " + bodyImage.exists());
    
    var moreInfoLink = widget.find('.'+widgetContentClassPrefix+'_moreInfoLink').html();
    console.log ("modal : more info link attribute : " + moreInfoLink);
    
    var tags = widget.find('.'+widgetContentClassPrefix+'_tags').html();
    console.log ("modal : tags attribute : " + tags);
    
    var modal = $(this);
    modal.find('.modal-title').text(bodyTitle);
    modal.find('.modal-body-content').replaceWith('<div class="modal-body-content">' + bodyContent + '</div>');
    if (bodyImage.exists()){
    	modal.find('.modal-image').append('<img src="' + bodyImage.attr('src') + '" class="modal-image">');
    }
    var modalMoreInfoLink =  modal.find('#modalMoreInfoLink');
    var hideLinkClass = "moreInfoHidden";
    if (null != moreInfoLink && moreInfoLink.length != 0){
		console.log ("modal : more info link changing URL link add display button");
	    modalMoreInfoLink.attr("href", moreInfoLink);
	    modalMoreInfoLink.removeClass(hideLinkClass);
    }else{
		console.log ("modal : more info link : reset");
		modalMoreInfoLink.attr("href", "#");
		if(!modalMoreInfoLink.hasClass(hideLinkClass)){
			console.log ("modal : more info link : hide button");
			modalMoreInfoLink.addClass(hideLinkClass);
		 }
	}
    
    modal.find('.modal-tags').empty().append(tags);
	
	displayElement(widget, modal, widgetContentClassPrefix, "responsable");
	displayElement(widget, modal, widgetContentClassPrefix, "location");
	displayElement(widget, modal, widgetContentClassPrefix, "phone");
	displayElement(widget, modal, widgetContentClassPrefix, "email");
	displayElement(widget, modal, widgetContentClassPrefix, "hours");
	displayElement(widget, modal, widgetContentClassPrefix, "dates");
	displayElement(widget, modal, widgetContentClassPrefix, "dateTimes");
	displayElement(widget, modal, widgetContentClassPrefix, "freeDate");
	displayElement(widget, modal, widgetContentClassPrefix, "websites");
	displayElement(widget, modal, widgetContentClassPrefix, "faceBook");
	displayElement(widget, modal, widgetContentClassPrefix, "instagram");
	displayElement(widget, modal, widgetContentClassPrefix, "files", ".modal-afterHeader");

    modal.attr('aria-inert', false);
 })

function displayElement(widget, modal, widgetContentClassPrefix, elementType, hookPosition){
	var searchFor = '.'+widgetContentClassPrefix+'-'+elementType;
	var elementContent = widget.find(searchFor).html();
	var elementContentExists = null != elementContent && elementContent.length != 0;
	
	if(null == hookPosition || hookPosition.length == 0){
		var hookPosition = ".modal-beforeFooter";
	}
	console.log ("modal : '"+elementType+"' ("+searchFor+") exists ? " + elementContentExists);
	
	var modalElementSelector = 'modal-'+elementType+'';
	if(elementContentExists){
		if (modal.find('.'+modalElementSelector).length == 0){
			var metaDataSelector = hookPosition;
			if(modal.find(metaDataSelector) == 0){
				console.log ("modal : "+metaDataSelector+" does not exists in modal, cannot add element '"+modalElementSelector+"'");
			}else{
				console.log ("modal : appending content to "+metaDataSelector+" for '"+modalElementSelector+"' in '"+hookPosition+"'");
				modal.find(metaDataSelector).append('<div class="'+modalElementSelector+'">' + elementContent + '</div>');
			}
		}else{
			console.log ("modal : ."+modalElementSelector+" already exists, replacing content");
			modal.find('.'+modalElementSelector).replaceWith('<div class="'+modalElementSelector+'">' + elementContent + '</div>');
		}
	}else{
		modal.find('.'+modalElementSelector).remove();
	}
}

$('#basicModal').on('hidden.bs.modal', function () {
	console.log ("modal :is hidding");
    var modal = $(this);
    modal.attr('aria-inert', true);
	modal.find('.modal-image').empty();
});