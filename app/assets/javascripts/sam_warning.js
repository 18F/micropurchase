'use strict';

(function (root) {
  var SamWarner = function () {
    this.$warning = $('.auction-alert');
    this.$hideTrigger = $('.warning-hide-trigger');
    this.$showTrigger = $('.warning-show-trigger');
  };

  SamWarner.prototype.setup = function () {
    if (Cookies.get('hideWarning')) {
      this.hide();
    } else {
      this.show();
    }
    this.listen();
  };

  SamWarner.prototype.show = function () {
    if (this.$warning.is(':visible')) { return; }

    this.$warning.show();
    this.$showTrigger.hide();

    Cookies.remove('hideWarning');
  };

  SamWarner.prototype.hide = function () {
    if (!this.$warning.is(':visible')) { return; }

    this.$warning.hide();
    this.$showTrigger.show();

    Cookies.set('hideWarning', true);
  };

  SamWarner.prototype.listen = function () {
    var that = this;

    this.$hideTrigger.on('click', function () {
      that.hide();
    });

    this.$showTrigger.on('click', function () {
      that.show();
    });
  };

  root.SamWarner = SamWarner; // gotta do this for the tests :(
  // would prefer all the globals for this app under one global

  // also this combines the start of the js evented system with
  // the components that build the system ... which is bad form
  $(document).ready(function () {
    var warner = new SamWarner();
    warner.setup();
  });

})(this);
