'use strict';

(function (window) {
	var microp = {};

	/**
  * 'throttles' the execution of a funtion.
  * will only call the function passed to throttle
  * once every @threshold milliseconds
  *
  * @example
  * window.addEventListener('resize', throttle(someFunction, 150, window));
  */
  microp.throttle = function throttle(fn, threshhold, scope) {
    threshhold || (threshhold = 250);
    var last,
        deferTimer;
    return function () {
      var context = scope || this;

      var now = +new Date(),
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
  };

  microp.format = function(format) {
    return (typeof format === 'function') ? format : d3.format(format);
  };

  microp.format.transform = function(format, transform) {
    format = microp.format(format);
    return function(d) {
      return transform(format(d) || '');
    };
  };

  microp.format.stardardizeUrl = function(str) {
    var lastChar = str.length - 1;
    if (str.charAt(lastChar) === '/') {
      str = str.substring(0, lastChar);
    }
    str = str.toLowerCase();
    return str;
  };

  microp.format.removeGitPrefix = function(str) {
    return str.includes('https')
      ? str.split("https://github.com/").join("")
      : str;
  };

  microp.format.transformDollars = function(str) {
    str = String(str);
    if (str.charAt(0) === '-') {
      return '-$' + str.substr(1, str.length);
    } else {
      return '$' + str;
    }
  };

  microp.format.commaSeparatedDollars = microp.format.transform(
    ',.0f',
    microp.format.transformDollars
  );

  // Input: string of a date or Date Object
  // Outputs a date object formatted like so: %Y-%m-%d
  // Or like so %m/%d if a separator is included
  microp.format.date = function (date, seperator) {
    var dateObj,
      date;
    if (typeof(date) === 'string') {
      dateObj = new Date(date);
    } else if (typeof(date) === 'object') {
      dateObj = date;
    }

    var day = dateObj.getDate(),
      month = dateObj.getMonth() + 1,
      year = dateObj.getFullYear();

    if (seperator === '/') {
      date = [month,day].join('/');
    } else {
      date = [year,month,day].join('-');
    }

    return date;
  };

  window.microp = microp;

})(this);
