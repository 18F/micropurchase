describe('Utility', function () {
  var stardardizeUrl,
    format

  describe('microp.format.stardardizeUrl', function(){

    beforeEach(function(){
      stardardizeUrl = microp.format.stardardizeUrl
    })

    var a = 'https://google.com/';
    var b = 'https://google.com';
    var c = 'https://google.com//';

    it("removes a forward slash at the end", function(){
      expect(stardardizeUrl(a)).toBe(b);
      expect(stardardizeUrl(a)).not.toBe(a);
      expect(stardardizeUrl(a)).not.toBe(c);
      expect(stardardizeUrl(b)).toBe(b);
    });

    it("it only removes the last forward slash", function(){
      expect(stardardizeUrl(c)).toBe(a);
      expect(stardardizeUrl(a)).not.toBe(c);
      expect(stardardizeUrl(c)).not.toBe(b);
    });
  });

  describe('microp.format.date', function(){

    beforeEach(function(){
      format = microp.format;
    })

    var april20 = 'Wed Apr 20 2016 17:42:46 GMT-0500 (CDT)'
    var april20Date = new Date('Wed Apr 20 2016 17:42:46 GMT-0500 (CDT)')

    it("defaults to a dash delimiter", function(){
      expect(format.date('10/14/1988')).toBe('1988-10-14');
      expect(format.date('10/14/1988')).not.toBe('10/14/1988');
      expect(format.date('10/14/1988')).not.toBe('1988-14-10');
      expect(format.date(april20Date)).toBe('2016-4-20');
    });

    it("formats a date object", function(){
      expect(format.date(april20Date)).toBe('2016-4-20');
    });

    it("formats a date string", function(){
      expect(format.date(april20)).toBe('2016-4-20');
    });

    it("has a / seperator option", function(){
      expect(format.date('10/14/1988', '/')).not.toBe('1988-10-14');
      expect(format.date('10/14/1988', '/')).toBe('10/14');
      expect(format.date('10/14/1988', '/')).not.toBe('10/15');
      expect(format.date(april20, '/')).toBe('4/20');
      expect(format.date(april20Date, '/')).toBe('4/20');
      expect(format.date(april20Date, '/')).not.toBe('2016-4-20');
    });

  });

  describe('microp.format.commaSeparatedDollars', function(){
    beforeEach(function(){
      commaSeparatedDollars = microp.format.commaSeparatedDollars;
    })

    it("rounds to integers", function(){
      expect(commaSeparatedDollars(1000.00945)).toBe('$1,000');
      expect(commaSeparatedDollars(5.00945)).toBe('$5');
      expect(commaSeparatedDollars(5000005.90)).not.toBe('$5,000,005');
      expect(commaSeparatedDollars(5000005.90)).toBe('$5,000,006');
    });

    it("prefixes a dollar to strings", function(){
      expect(commaSeparatedDollars('5')).toBe('$5');
      expect(commaSeparatedDollars('5')).not.toBe('5');
    });

    it("handles negative numbers", function(){
      expect(commaSeparatedDollars('-5')).toBe('-$5');
      expect(commaSeparatedDollars('-500.06')).toBe('-$500');
    });

    it("reformats strings and numbers to strings", function(){
      expect(commaSeparatedDollars('5')).toBe('$5');
      expect(commaSeparatedDollars(5)).not.toBe('5');
      expect(commaSeparatedDollars(-15)).toBe('-$15');
      expect(commaSeparatedDollars(-15)).not.toBe('-15');
    });

    it("adds a comma delimiter every thousand", function(){
      expect(commaSeparatedDollars('1000000')).toBe('$1,000,000');
      expect(commaSeparatedDollars(1000000)).toBe('$1,000,000');
      expect(commaSeparatedDollars('1000000')).not.toBe('$10,000,000');
      expect(commaSeparatedDollars(1000000)).not.toBe('$10,000,000');
      expect(commaSeparatedDollars(1000000)).not.toBe(1000);
      expect(commaSeparatedDollars('10000,00')).not.toBe('10000,00');
      expect(commaSeparatedDollars('10000,00')).not.toBe('$1,000,000');
      expect(commaSeparatedDollars(1000)).toBe('$1,000');
    });
  });

  describe('microp.format.transformDollars', function(){
    beforeEach(function(){
      transformDollars = microp.format.transformDollars;
    })

    it("prefixes a dollar to strings", function(){
      expect(transformDollars('5')).toBe('$5');
      expect(transformDollars('5')).not.toBe('5');
    });

    it("handles negative numbers", function(){
      expect(transformDollars('-5')).toBe('-$5');
      expect(transformDollars('-500')).toBe('-$500');
      expect(transformDollars('-500.06')).not.toBe('-$500');
    });

    it("reformats strings and numbers to strings", function(){
      expect(transformDollars('5')).toBe('$5');
      expect(transformDollars(5)).not.toBe('5');
      expect(transformDollars(-15)).toBe('-$15');
      expect(transformDollars(-15)).not.toBe('-15');
    });
  });

  describe('microp.format.removeGitPrefix', function(){
    var calc = 'https://github.com/18f/calc'
    var accordion = 'https://github.com/18f/accordion'

    beforeEach(function(){
      removeGitPrefix = microp.format.removeGitPrefix;
    })

    it("removes git prefix from URL", function(){
      expect(removeGitPrefix(calc)).toBe('18f/calc');
      expect(removeGitPrefix(accordion)).toBe('18f/accordion');
      expect(removeGitPrefix(calc)).not.toBe('https://github.com/18f/calc');
    });

    it("is case sensitive", function(){
      expect(removeGitPrefix(calc)).not.toBe('18F/calc');
      expect(removeGitPrefix(accordion)).not.toBe('18f/ACCORDION');

    });

    it("only supports https", function(){
      expect(removeGitPrefix(calc)).toBe('18f/calc');
      expect(removeGitPrefix('http://github.com/18f')).not.toBe('18f');
    });

  });


  describe('microp.throttle', function(){
    var timerCallback,
      Ticker,
      ticker

    beforeEach(function(){
      timerCallback = jasmine.createSpy("timerCallback");

      Ticker = function () {
        this.count = 0;
        this.up = function() {
          this.count++;
          timerCallback();
        }
      }

      spyOn(microp, 'throttle');
      ticker = new Ticker();
      jasmine.clock().install();
    })

    afterEach(function(){
      jasmine.clock().uninstall();
    })

    it("throttles the ticker", function(){
      microp.throttle(ticker.up, 1000)
      ticker.up()

      expect(ticker.count).toEqual(1)
      expect(microp.throttle).toHaveBeenCalled();
      expect(timerCallback).toHaveBeenCalled();
      jasmine.clock().tick(1001)
      ticker.up();
      expect(ticker.count).toEqual(2)
      expect(timerCallback).toHaveBeenCalled();
    });
  });
});
