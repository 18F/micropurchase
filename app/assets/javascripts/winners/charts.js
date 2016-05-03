'use strict';

(function (window) {

  var microp = window.microp;

  var Charts = function (auctions) {
    this.auctions = auctions;
    this.textRotation = 60;
    this.generate();
  }

  Charts.prototype = {
    scale: d3.scale.sqrt(),
    linear: d3.scale.linear(),
    load: {
      chart2: function chart2 (settings) {
        c3.generate({
          bindto: '#chart2',
          data: {
            xs: {
              bids: 'bids_dates',
              means: 'means_dates'
            },
            columns: settings.cols,
            types: {
              bids: 'scatter'
            },
            names: {
              bids: 'Winning Bid',
              means: 'Mean Winning Bid By Date'
            }
          },
          axis: {
            x: {
              type: 'timeseries',
              tick: {
                multiline: false,
                fit: true,
                rotate: Charts.textRotation
              },
              label: {
                text: 'Auction date',
                position: 'outer-center'
              }
            },
            y: {
              label: {
                text: 'Bid amount',
                position: 'outer-middle'
              },
              tick: {
                format: function(d) {
                  return microp.format.commaSeparatedDollars(d);
                }
              }
            }
          },
          point: {
            r: 7
          },
          tooltip: {
            show: true,
            format: {
              value: function (value, ratio, id, index) {
                return value === null ? 'no bid' : microp.format.commaSeparatedDollars(value);

              }
            }
          }
        });
      },
      chart4: function chart4 (settings) {

        var today = new Date();
        var twoWeeksAgo = new Date(today - (1000 * 60 * 60 * 24 * 14)); // 14 days ago
        var dateExtent = [twoWeeksAgo,today];

        c3.generate({
          bindto: '#chart4',
          axis: {
            x: {
              type: 'timeseries',
              label: {
                text: 'Date',
                position: 'outer-center'
              },
              tick: {
                rotate: Charts.textRotation,
                multiline: false
              },
              'extent': dateExtent
            },
            y: {
              tick: {
                count: 4,
                format: function (d) { return Math.round(d); }
              },
              label: {
                text: 'Count',
                position: 'outer-middle'
              }
            }
          },
          data: {
            x: settings.x,
            columns: settings.cols,
            type: 'bar'
          },
          bar: {
            width: {
              ratio: 0.3 // this makes bar width 50% of length between ticks
            }
          },
          color: {
            pattern: ['#046B99','#B3EFFF','#1C304A','#00CFFF']
          },
          zoom: {
            enabled: false
          },
          subchart: {
            show: true,
            size: {
              height: 30
            }
          }
        });
      },
      chart5: function chart5 (settings) {
        c3.generate({
          bindto: '#chart5',
          axis: {
            x: {
              type: 'timeseries',
              label: {
                text: 'Auction date',
                position: 'outer-center'
              },
              tick: {
                rotate: Charts.textRotation,
                multiline: false
              }
            },
            y: {
              label: {
                text: '# Bids',
                position: 'outer-middle'
              }
            }
          },
          data: {
              xs: settings.xs,
              columns: settings.cols,
              type: 'scatter'
          },
          tooltip: {
            contents: function(d) {
              return '<table class="c3-tooltip">' +
                '<tbody>' +
                  '<tr>' +
                    '<th colspan="1">' + microp.format.date(d[0].x, '/') + '</th>' +
                    '<th class="name" colspan="1"><span style="background-color:#1C304A"></span>' +
                    d[0].id + '</th>' +
                  '</tr>' +
                  '<tr class="c3-tooltip-name--'+ d[0].id + '">' +
                    '<td class="name">Bids</td>' +
                    '<td class="value">'+ d[0].value + '</td>' +
                  '</tr>' +
                  '<tr class="c3-tooltip-name--' + d[0].id + '">' +
                    '<td class="name">Winning bid</td>' +
                    '<td class="value">$' + settings.z[d[0].id] + '</td>' +
                  '</tr>' +
                '</tbody>' +
              '</table>';
            }
          },
          legend: {
            show: false
          },
          color: {
            pattern: ['#1C304A']
          },
          point: {
            r: function(d) {
              if ( _.isUndefined(settings.z[d.id]) ) { return; }
              var scaledValue = Charts.prototype.linear(Charts.prototype.scale(settings.z[d.id]));
              return scaledValue <= 3 ? 3 : scaledValue;
            }
          }
        });
      },
      donut1: function donut1 (settings) {
        c3.generate({
          bindto: "#donut-by-repo",
          data: {
            columns: settings.cols ? settings.cols : [
              ['software', 0],
              ['non-software', 120]
            ],
            type : 'donut'
          },
          donut: {
            title: 'Projects by repo'
          },
          color: {
            pattern: ['#1C304A','#00CFFF','#046B99','#B3EFFF']
          }
        });
      },
      donut2: function donut2 (settings) {
        c3.generate({
          bindto: "#donut-by-language",
          data: {
            columns: settings.cols ? settings.cols : [
              ['software', 0],
              ['non-software', 120]
            ],
            type : 'donut'
          },
          donut: {
            title: 'Projects by language'
          },
          color: {
            pattern: ['#046B99','#B3EFFF','#1C304A','#00CFFF']
          }
        });
      }
    },
    create: {
      chart2: function chart2 (auctions) {
        var settings = {};

        settings.cols = [['bids_dates'], ['bids'], ['means_dates'],['means']];

         _.each(auctions, function(auction){
          var auction_bids = _.sortBy(auction.bids, 'created_at');

          if (auction.winning_bid && auction.bids.length > 0) {
            settings.cols[0].push(microp.format.date(auction.end_datetime));
            settings.cols[1].push(+auction.winning_bid.amount);
          }

        });

        var pairedDates = _.zip(settings.cols[0],settings.cols[1]);


        pairedDates = _.groupBy(pairedDates, function(num){
          return num[0];
        });

        var dateList = _.keys(pairedDates);
        var bidList = _.values(pairedDates);

        settings.cols[2] = dateList;
        settings.cols[2][0] = 'means_dates';

        _.forEach(bidList, function(bidGrouping, i) {
          if (i === 0) {
            return;
          }
          var winningBidGroup = _.map(bidGrouping, function(num) {
            return num[1];
          });

          settings.cols[3].push(d3.mean(winningBidGroup));
        });
        return { cols: settings.cols };
      },
      chart4: function chart4 (auctions) {
        var settings = {};
        settings.cols = [
            ['date_community'],
            ['Bidders'],
            ['Open-source projects'],
            ['Auctions']
        ];
        settings.x = 'date_community';

        _.each(auctions, function(auction){
          auction.github_repo = microp.format.stardardizeUrl(auction.github_repo);
          auction.github_repo = microp.format.removeGitPrefix(auction.github_repo);
        })

        var byGithub = d3.nest()
          .key(function(d){return microp.format.date(d.end_datetime)})
          .key(function(d){return d.github_repo})
          .entries(auctions);

        var byAuction = d3.nest()
          .key(function(d){return microp.format.date(d.end_datetime)})
          .entries(auctions);

        _.each(byGithub, function (date, key) {
          // Dates
          settings.cols[0].push(date.key);
          // Auctions
          settings.cols[2].push(date.values.length);
        });

        _.each(byAuction, function (date, key) {
          var bidders = _.map(date.values, function (auction, key) {
            var bidder_ids = _.map(auction.bids, function (bid, key) {
              return bid.bidder_id;
            });
            return bidder_ids;
          });

          var uniqueBidders = _.uniq(_.flatten(bidders)).length;

          // Projects
          settings.cols[3].push(date.values.length);
          // Bidders
          settings.cols[1].push(uniqueBidders);
        });

        return settings;
      },
      /**
       * @function
       * @returns {Object} - to be loaded as a c3 scatterplot.
       **/
      chart5: function chart5 (auctions) {
        var settings = {};
        // set of columns for the scatterplot
        // @format [['date_#{ auction number }', '#{ date }'],['#{ auction number }', #{ number of bids }]]
        settings.cols = [];
        // object with corresponding date strings
        // @format { #{ auction number }, '#{ corresponding date string }'}
        settings.xs = {};
        // object with winning bid by auction
        // @format { #{ auction number }, #{ corresponding winning bid }}
        settings.z = {};

        // only include auctions that have a winning_bid
        auctions = _.filter(auctions, function (auction) {
          return auction.winning_bid;
        })

        var auctionsByEndtime = d3.nest()
          .key(function(d){
            return microp.format.date(d.end_datetime);
          })
          .key(function(d){ return d.id; })
          .entries(auctions);

        _.each(auctionsByEndtime, function(dateObj, i, list) {
          var dateString = 'date_'+ i;
          settings.cols.push([dateString, dateObj.key]);
          _.each(dateObj.values, function(auction, j, list) {
            var winningBid = auction.values[0].winning_bid.amount
              ? auction.values[0].winning_bid.amount
              : undefined;
            settings.cols.push([auction.key, auction.values[0].bids.length]);
            settings.xs[auction.key] = dateString;
            settings.z[auction.key] = winningBid; // $ amount
          });
        });
        return settings;
      },
      donut1: function donut1 (auctions) {
        var settings = {};
        settings.cols = [];

        _.each(auctions, function(auction){
          auction.github_repo = microp.format.stardardizeUrl(auction.github_repo);
          auction.github_repo = microp.format.removeGitPrefix(auction.github_repo);
        })

        var repos = d3.nest()
          .key(function(d){ return d.github_repo;})
          .rollup(function(d){ return d.length; })
          .map(auctions);

        settings.cols = _.map(repos, function(value, key) {
          return [key,value];
        });

        return settings;
      },
      donut2: function donut2(auctions) {
        var settings = {};
        settings.cols = [];

        var repos = [
          {'name': '18F/fedramp-micropurchase', 'language': 'google sheets'},
          {'name': '18F/micropurchase', 'language': 'ruby'},
          {'name': '18F/openopps-platform', 'language': 'ruby'},
          {'name': '18F/playbook-in-action', 'language': 'python'},
          {'name': '18F/procurement-glossary', 'language': 'yml'},
          {'name': '18F/tock', 'language': 'python'},
          {'name': '18F/travel-form', 'language':undefined},
          {'name': '18F/deduplicate-tock-float', 'language': undefined},
          {'name': '18F/aws-broker', 'language': 'go'}
        ];

        repos = d3.nest()
          .key(function(d){ return d.language; })
          .rollup(function(d) {return d.length;})
          .map(repos);

        settings.cols = _.map(repos, function(value, key) {
          if ( key !== 'undefined' &&  key !== undefined) {
            return [key,value];
          } else { return []; }
        });

        return settings;
      }
    },
    settings: function () {
      var settings = {},
        auctions = this.auctions,
        that = this;
      _.each(this.create, function(fn) {
        that.settings[fn.name] = settings[fn.name] = fn(auctions);
      });
      return settings;
    },
    generate: function () {
      var settings = this.settings();

      _.each(this.load, function(fn) {
        fn(settings[fn.name]);
      });
    }
  }

  window.Charts = Charts;

}(this));
