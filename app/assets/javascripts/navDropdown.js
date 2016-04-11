

$(function(){

  /**
  * 'throttles' the execution of a funtion.
  * will only call the function passed to throttle
  * once every @threshold milliseconds
  *
  * @example
  * window.addEventListener('resize', throttle(someFunction, 150, window));
  */
  window.throttle = function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
      var context = scope || this;

      var now = +new Date,
          args = arguments;
      if (last && now < last + threshhold) {
        // hold on to it
        clearTimeout(deferTimer);
        deferTimer = setTimeout(function () {
          last = now;
          fn.apply(context, args);
        }, threshhold);
      } else {
        last = now;
        fn.apply(context, args);
      }
    };
  }

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

    var resizeDropdown = function resizeDropdown(button) {
        var buttonHeight = button.height(),
            buttonWidth = button.width();

        $('.header-account .nav-menu .sub-nav-group').css('margin-top', 3 + buttonHeight);
        $('.header-account .nav-menu .sub-nav').css('width', 14 + buttonWidth);
    };

    var onResize = function onResize () {
      resizeDropdown(profileButton);
    };

    onResize();

    window.addEventListener('resize', window.throttle(onResize, 200, window));

});

