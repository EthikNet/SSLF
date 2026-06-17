$(document).ready(function() {
  var navbar = $(".navbar");
  var body = $('body');
  
  AdjustHeader(); // Incase the user loads the page from halfway down (or something);
  $(window).scroll(function() {
      AdjustHeader();
  });
  
  function AdjustHeader(){
	var stayOnTopFormPixel = ${webleger.site.menu.stayOnTop.from};
	var onTopCunstomClass = "  ${webleger.site.menu.stayOnTop.customClass}";
	var isMobileMode = $(window).width() < 640;
    if (isMobileMode || (stayOnTopFormPixel >= 0 && $(window).scrollTop() >= stayOnTopFormPixel)) {
      navbar.addClass("navbar-fixed-top"+onTopCunstomClass);
	  body.css("padding-top", navbar.height());
    } else {
      navbar.removeClass("navbar-fixed-top"+onTopCunstomClass);
 	  body.css("padding-top", "unset");
	}
  }
});