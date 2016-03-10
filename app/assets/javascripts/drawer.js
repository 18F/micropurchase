$(function() {

  /**
   * Utilities for setting or removing tabindex on all focusable elements
   * in a parent div. Useful for hiding elements off-canvas without setting
   * display:none, while still removing from the tab order
   */
  var accessibility = {
    removeTabindex: function removeTabindex($elm) {
      $elm
        .find('a, button, :input, [tabindex]')
        .attr('tabindex', '-1');
    },
    restoreTabindex: function restoreTabindex($elm) {
      $elm
        .find('a, button, :input, [tabindex]')
        .attr('tabindex', '0');
    }
  };

  var KEYCODE_ESC = 27;

  var defaultSelectors = {
    'body': 'drawer',
    'toggle': '[data-drawer-toggle]'
  };

  /**
   * Drawer widget
   * @constructor
   * @param {Array} terms - Term objects with
   * @param {Object} selectors - CSS selectors for drawer components
   */
  var Drawer = function Drawer(selectors) {
    var self = this;

    self.selectors = $.extend({}, defaultSelectors, selectors);

    self.$body = $(self.selectors.body);
    self.$toggle = $(self.selectors.toggle);

    // Initialize state
    self.isOpen = false;

    // Remove tabindices
    accessibility.removeTabindex(self.$body);

    // Bind listeners
    self.$toggle.on('click', this.toggle.bind(this));

    // Handle tabbing
    $(document.body).on('keyup', this.handleKeyup.bind(this));
  };

  Drawer.prototype = {
    toggle: function() {
      var method = this.isOpen ? this.hide : this.show;
      method.apply(this);
    },

    show: function() {
      this.$body.addClass('is-open').attr('aria-hidden', 'false');
      this.$toggle.addClass('active');
      this.isOpen = true;
      accessibility.restoreTabindex(this.$body);
    },

    hide: function() {
      this.$body.removeClass('is-open').attr('aria-hidden', 'true');
      this.$toggle.removeClass('active');
      this.isOpen = false;
      accessibility.removeTabindex(this.$body);

    },

    /** Close drawer on escape keypress */
    handleKeyup: function(e) {
      if (e.keyCode == KEYCODE_ESC) {
        if (this.isOpen) {
          this.hide();
        }
      }
    }
  };

  var drawer = new Drawer();

});
