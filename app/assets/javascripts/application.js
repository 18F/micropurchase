/*
 * = require vendor/jquery-1.11.3.min.js
 * = require components.js
 * = require cookies.js
 * = require sam_warning.js
 * = require jquery-accessibleMegaMenu.js
 * = require drawer.js
 */


$(function(){
	$(".nav-login").accessibleMegaMenu({
        /* prefix for generated unique id attributes, which are required
           to indicate aria-owns, aria-controls and aria-labelledby */
        uuidPrefix: "accessible-megamenu",

        /* css class used to define the megamenu styling */
        menuClass: "nav-menu",

        /* css class for a top-level navigation item in the megamenu */
        topNavItemClass: "nav-item",

        /* css class for a megamenu panel */
        panelClass: "sub-nav",

        /* css class for a group of items within a megamenu panel */
        panelGroupClass: "sub-nav-group",

        /* css class for the hover state */
        hoverClass: "hover",

        /* css class for the focus state */
        focusClass: "focus",

        /* css class for the open state */
        openClass: "open"
    });

    var profileButton = $('.header-account .nav-menu .nav-item a');

    var resizeProfileMenu = function resizeProfileMenu(button) {
        var buttonHeight = button.height();
        $('.header-account .nav-menu .sub-nav-group').css('margin-top', 3 + buttonHeight);
    };

    resizeProfileMenu(profileButton);

    $(window).on('resize', function(){
        $('.header-account .nav-menu .sub-nav-group')
        resizeProfileMenu(profileButton)
    });

});

