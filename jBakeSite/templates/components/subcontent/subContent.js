$(document).ready(function(){
  $(".filterElements .btn").on("click", function() {
	var clickedButton = $(this);
	var userFiltersDiv = $(this).parents(".userFilters");
	var subContentBlock = userFiltersDiv.parent();
	var allFiltersGroup = userFiltersDiv.find(".filterElements");
	
	
	
	console.log ("UserFilters : filtering using : " + allFiltersGroup.size() + " filterGroups");
	
	//init
	userFiltersDiv.find(".userFilter_all").removeClass('activeFilter');
	clickedButton.toggleClass('activeFilter');
	//reset
	var allCards = subContentBlock.find(".elementsList").children();
	console.log("UserFilters : reseting " + allCards.size() + " elements");
	allCards.removeClass("hiddenElement");
	allCards.toggle(true);
	
	var handleLast = [];
	//add class for filtering
	allFiltersGroup.each(function() {
		var currentGroup = $(this);
		var allowMultiple = false;
		var targetList = currentGroup.data('targetList');
		var multipleAttribute = currentGroup.data('allowMultiple');
		if (multipleAttribute !=null && multipleAttribute==true){
			var allowMultiple = true
		}
		var buttonsChoice = currentGroup.find(".userFilter_choices .btn");
		
		var buttonAll = currentGroup.find(".userFilter_all");
		var isAllButtonActive = buttonAll.hasClass("activeFilter");
		var numberOfButtonActive = buttonsChoice.filter(".activeFilter").size();
		var allChoiceButtonActive = buttonsChoice.size() == numberOfButtonActive
		
		
		var atLeastOneChoiceButtonActive = buttonsChoice.hasClass("activeFilter");
		console.log ("=UserFilters : mamanging class to " + targetList + " ("  + buttonsChoice.size() + " buttons, at least 1 active? " + atLeastOneChoiceButtonActive + ", all Choice button active? " + allChoiceButtonActive 
					+ ", is All button active ?"+ isAllButtonActive + " ), allow Multiple Selection :" + allowMultiple);
		
		if (!allowMultiple || isAllButtonActive) {
			buttonsChoice.removeClass('activeFilter');
			clickedButton.toggleClass('activeFilter');
		}
		
		if(isAllButtonActive || allChoiceButtonActive || !atLeastOneChoiceButtonActive){
			console.log ("====== No filters for (ignoring filtering) : " + targetList);
			allCards.removeClass("hiddenElement");
		}else{
			console.log ("=UserFilters : filters for '" + targetList + "' will be handle in the filtrer loop");
			handleLast.push(currentGroup);
		}
	});
	
	
	
	$.each(handleLast, function (){
		var currentGroup = $(this);
		var buttonsChoice = currentGroup.find(".userFilter_choices .btn");
		var targetList = currentGroup.data('targetList');
		
		$(targetList).filter(function() {
			var currentElement = $(this);
			var currentCard = currentElement.parent().parent();
			// handle Modal card
			if(currentCard.prop("tagName") == "A") {
				currentCard = currentCard.parent();
			}
			
			var cardfilterStatus = []
			buttonsChoice.each(function(buttonIndex){
				var currentButton = $(this);
				var buttonValue = currentButton.text();
				var isButtonActive = currentButton.hasClass("activeFilter");
				
				isCardShouldBeVisible = false;
				var curentElementsValues = currentElement.text().split(",");
				
				var i;
				for (i = 0; i < curentElementsValues.length; ++i) {
					var anElementValue = curentElementsValues[i];
					isCardShouldBeVisible = buttonValue.toLowerCase().indexOf(anElementValue.toLowerCase()) > -1;
					if(isCardShouldBeVisible) {
						break;
					}
				}
				
				if (isButtonActive && isCardShouldBeVisible){
					cardfilterStatus[buttonIndex] = true;
				} else {
					cardfilterStatus[buttonIndex] = false;
				}
			})
			
			var displayCard = cardfilterStatus.indexOf(true) >=0;
			var cardTitle = currentCard.find(".card_title").text();
			if(cardTitle.size == 0){
				var cardTitle = currentCard.find(".block_title").text();
			}
			console.log ("====== '" + cardTitle  + "' cardfilterStatus : " + cardfilterStatus.join(",") + ", global visible : " + displayCard);
			
			if(!displayCard){
				console.log ("======== ' Hidding element");
				currentCard.addClass("hiddenElement");
			}
		})
						
		
			
	      //$(this).parent().parent().toggle($(this).text().toLowerCase().indexOf(value) > -1)
	    
		
		//hide filtered elements
		subContentBlock.find(".hiddenElement").toggle(false);
	});
		
  });
});
  