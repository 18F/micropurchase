'use strict';

(function (window) {
  // import microp utility object
  var microp = window.microp;

  // Global winners settings
  // used throughout winners page
  var winners = microp.winners = {
    textRotation: 60,
    scale: d3.scale.sqrt(),
    linear: d3.scale.linear(),
    selectMetric: function selectMetric (metricName) {
      return $('[data-metric][data-name="'+metricName+'"]')
    },
    setSelectorText: function setSelectorText (name, text, formatter) {
      if (formatter == "$") {
        text = microp.format.commaSeparatedDollars(text);
      } else if (formatter == '#') {
        text = Math.round(text * 10) / 10;
      } else if (formatter == 'days') {
        text = Math.round(text * 10) / 10 + ' days';
      }
      this.selectors[name].text(text);
      this.metrics[name] = text;
    },
    metrics: {}
  }

  var charts = winners.charts = {
    load: {},
    create: {}
  };

  charts.load.chart2 = function loadChart2 (settings) {
    // Chart 2
    charts.chart2 = c3.generate({
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
            rotate: winners.textRotation
          },
          label: {
            text: 'Auction date',
            position: 'outer-center',
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
            return value == null ? 'no bid' : microp.format.commaSeparatedDollars(value);

          }
        }
      }
    });
  };

  charts.load.chart4 = function loadChart4 (settings) {

    var today = new Date();
    var twoWeeksAgo = new Date(today - (1000 * 60 * 60 * 24 * 14)); // 14 days ago
    var dateExtent = [twoWeeksAgo,today];

    charts.chart4 = c3.generate({
      bindto: '#chart4',
      axis: {
        x: {
          type: 'timeseries',
          label: {
            text: 'Date',
            position: 'outer-center',
          },
          tick: {
            rotate: winners.textRotation,
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
            position: 'outer-middle',
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
  };

  charts.load.chart5 = function loadChart5 (settings) {

    charts.chart5 = c3.generate({
      bindto: '#chart5',
      axis: {
        x: {
          type: 'timeseries',
          label: {
            text: 'Auction date',
            position: 'outer-center',
          },
          tick: {
            rotate: winners.textRotation,
            multiline: false
          }
        },
        y: {
          label: {
            text: '# Bids',
            position: 'outer-middle',
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
          if (settings.z[d.id] === 'undefined' || settings.z[d.id] === undefined) { return; }
          var scaledValue = winners.linear(winners.scale(settings.z[d.id]));
          return scaledValue <= 3 ? 3 : scaledValue;
        }
      }
    });

  };

  /* Project by repo
    * We need to have tags attached to auctions
  */
  charts.load.donut1 = function loadDonut1 (settings) {
    charts.donut1 = c3.generate({
      bindto: "#donut-by-repo",
      data: {
        columns: settings.cols ? settings.cols : [
          ['software', 0],
          ['non-software', 120],
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
  };

  /* Project by language
    * We need to have tags attached to auctions
  */
  charts.load.donut2 = function loadDonut2 (settings) {
    charts.donut2 = c3.generate({
      bindto: "#donut-by-language",
      data: {
        columns: settings.cols ? settings.cols : [
          ['software', 0],
          ['non-software', 120],
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
  };

  ///////////////////////////////////////////////////////////
  // Create Charts Data (charts 2-4)
  ///////////////////////////////////////////////////////////

  var getWinningBids = function getWinningBids(auctions) {
    return _.pluck(auctions, 'winning_bid');
  }

  var getWinningBidAmounts = function getWinningBidAmounts(auctions) {
    var winningBids = getWinningBids(auctions);
    return _.pluck(winningBids, 'amount')
  }

  var meanWinningBids = function meanWinningBids(auctions) {
    var winningBids = getWinningBidAmounts(auctions);
    return d3.mean(winningBids);
  }

  var getAllBidders = function getAllBidders(auctions) {
    return _.pluck(auction.bids, 'bidder_id');
  }

  var getNumberUniqueWinners = function getNumberUniqueWinners(auctions, unique) {
    var winningBids = getWinningBids(auctions);
    winningBids = _.filter(_.pluck(winningBids, 'bidder_id'), function(num) {
      if (_.isNumber(num)) {
        return num;
      }
    });
    if (unique) {
      winningBids = _.uniq(winningBids);
    }
    return winningBids.length;
  }

  var getBidsPerAuction = function(auctions) {
    var bidsPerAuction = _.map(auctions, function(auction, key){
      return auction.bids.length
    })
    return d3.mean(bidsPerAuction);
  }

  var getBiddingVendors = function(auctions) {
    var biddingVendors = _.map(auctions, function(auction, key){
      return _.pluck(auction.bids, 'bidder_id')
    });
    return _.uniq(_.flatten(biddingVendors)).length;
  }

  var getUniqueRepos = function getUniqueRepos(auctions) {


    var repos = _.pluck(auctions, 'github_repo')

    repos = _.map(repos, function(value,key) {
      return microp.format.stardardizeUrl(value);
    })

    return repos = _.uniq(repos).length;
  }

  var getAuctionLength = function getAuctionLength(auctions) {
    var auctionL =  _.map(auctions, function(auction){
      var timeDiff = new Date(auction.end_datetime) - new Date(auction.start_datetime);
      var dayUTF = 1000 * 60 * 60 * 24;
      return (timeDiff / dayUTF);
    });

    return d3.mean(auctionL)
  }



  charts.create.metrics = function createMetrics(auctions) {

    var uniqueWinners = getNumberUniqueWinners(auctions, true)

    var avgWinningBids = meanWinningBids(auctions);

    var repos = getUniqueRepos(auctions)

    var bidsPerAuction = getBidsPerAuction(auctions)

    var biddingVendors = getBiddingVendors(auctions)

    var auctionLength = getAuctionLength(auctions)

    console.log('ALL AUCTIONS           :', auctions)
    console.log('unique winning bidders :', uniqueWinners)
    console.log('average winning bid    :', avgWinningBids)
    console.log('number of repos        :', repos)
    console.log('bids per auction       :', bidsPerAuction)
    console.log('# of bidding vendors   :', biddingVendors)
    console.log('average auction length :', auctionLength)


    winners.setSelectorText('$auctions_total', auctions.length);
    winners.setSelectorText('$unique_winners', uniqueWinners);
    winners.setSelectorText('$bids', bidsPerAuction, '#');
    winners.setSelectorText('$bidding_vendors', biddingVendors, '#');
    winners.setSelectorText('$auction_length', auctionLength, 'days');
    winners.setSelectorText('$winning_bid', avgWinningBids, '$');
  };


  charts.create.metrics2 = function createMetrics2(auctions) {
    var bidsPerAuction = [],
      winningBids = [],
      uniqueBidders = [],
      repos = [],
      uniqueWinners = [],
      auctionLength = [];

     _.each(auctions, function(auction){
      var auction_bids = _.sortBy(auction.bids, 'created_at');

      // for unique vendors
      var bidders = _.pluck(auction.bids, 'bidder_id');
      //

      var timeDiff = new Date(auction.end_datetime) - new Date(auction.start_datetime);
      var dayUTF = 1000 * 60 * 60 * 24;

      auctionLength.push(timeDiff / dayUTF);

      // for unique winners
      var auctionsByWinners = d3.nest()
        .key(function(d){ return d.amount; })
        .key(function(d){ return d.bidder_id; })
        .entries(auction_bids);
      if (auctionsByWinners[0]) {
        var winnerId = auctionsByWinners[0].values[0].key;
        uniqueWinners.push(winnerId)
      }

      var bid_amts = _.pluck(auction.bids, 'amount');

      bidsPerAuction.push(bid_amts.length);

      uniqueBidders.push(bidders);

      repos.push(auction.github_repo);
    });

    var pairedDates = _.zip(settings.cols[0],settings.cols[1]);
    pairedDates = _.groupBy(pairedDates, function(num){
      return num[0];
    });
    var bidList = _.values(pairedDates);

    _.forEach(bidList, function(bidGrouping, i) {
      if (i === 0) {
        return;
      }
      var winningBidGroup = _.map(bidGrouping, function(num) {
        return num[1];
      });
      winningBids.push(winningBidGroup);
    });

    winners.setSelectorText('$winning_bid', d3.mean(_.flatten(winningBids)), '$');
    winners.setSelectorText('$bids', d3.mean(bidsPerAuction), '#');

    uniqueBidders = _.uniq(_.flatten(uniqueBidders)).length;
    winners.setSelectorText('$bidding_vendors', uniqueBidders);

    repos = _.uniq(repos).length;
    winners.setSelectorText('$projects', repos);

    uniqueWinners = _.uniq(uniqueWinners).length;

    winners.setSelectorText('$unique_winners', uniqueWinners);

    auctionLength = d3.mean(auctionLength);

    winners.setSelectorText('$auction_length', auctionLength, 'days');

    winners.setSelectorText('$auctions_total', auctions.length, '#');

  }

  charts.create.chart2 = function createChartData2(auctions) {
    var settings = {};

    settings.cols = [['bids_dates'], ['bids'], ['means_dates'],['means']];

     _.each(auctions, function(auction){
      var auction_bids = _.sortBy(auction.bids, 'created_at');

      if (auction.bids.length > 0) {
        settings.cols[0].push(microp.format.date(auction.end_datetime));
      }

      var auctionsByWinners = d3.nest()
        .key(function(d){ return d.amount; })
        .key(function(d){ return d.bidder_id; })
        .entries(auction_bids);
        if (auctionsByWinners.length > 0) {
          settings.cols[1].push(+auctionsByWinners[0].key);
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
  };


  // returns object { cols: [ [ ] ]}
  charts.create.chart2_old = function createChartData2_old(auctions) {
    var settings = {};

    settings.cols = [['bids_dates'], ['bids'], ['means_dates'],['means']];

    // for bids/auction
    var bidsPerAuction = [];
    //

    // for winning bids metric
    var winningBids = [];
    //

    // for unique vendors
    var uniqueBidders = [];
    //

    // for unique repos
    var repos = [];
    //

    // for unique winners
    var uniqueWinners = [];
    //

    // for auction length
    var auctionLength = [];

     _.each(auctions, function(auction){
      var auction_bids = _.sortBy(auction.bids, 'created_at');

      // for unique vendors
      var bidders = _.pluck(auction.bids, 'bidder_id');
      //

      var timeDiff = new Date(auction.end_datetime) - new Date(auction.start_datetime);
      var dayUTF = 1000 * 60 * 60 * 24;

      auctionLength.push(timeDiff / dayUTF);

      settings.cols[0].push(microp.format.date(auction.end_datetime));

      // for unique winners
      var auctionsByWinners = d3.nest()
        .key(function(d){ return d.amount; })
        .key(function(d){ return d.bidder_id; })
        .entries(auction_bids);
      if (auctionsByWinners[0]) {
        settings.cols[1].push(+auctionsByWinners[0].key)
        var winnerId = auctionsByWinners[0].values[0].key;
        uniqueWinners.push(winnerId)
      }

      var bid_amts = _.pluck(auction.bids, 'amount');

      // for bids/auction
      bidsPerAuction.push(bid_amts.length);
      //

      // for unique vendors
      uniqueBidders.push(bidders);
      //

      // for unique repos
      repos.push(auction.github_repo);
      //

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

      // for winning bids metric
      winningBids.push(winningBidGroup);
      //

      var mean = d3.mean(winningBidGroup);
      settings.cols[3].push(mean);
    });

    // for winning bids metric
    winners.setSelectorText('$winning_bid', d3.mean(_.flatten(winningBids)), '$');
    //

    // for winning bids metric
    winners.setSelectorText('$bids', d3.mean(bidsPerAuction), '#');
    //

    // for unique vendors
    uniqueBidders = _.uniq(_.flatten(uniqueBidders)).length;
    winners.setSelectorText('$bidding_vendors', uniqueBidders);
    //

    // for unique repos
    repos = _.uniq(repos).length;
    winners.setSelectorText('$projects', repos);
    //

    // for unique repos
    uniqueWinners = _.uniq(uniqueWinners).length;

    winners.setSelectorText('$unique_winners', uniqueWinners);
    //

    // for unique repos
    auctionLength = d3.mean(auctionLength);

    winners.setSelectorText('$auction_length', auctionLength, 'days');
    //

    // for # auctions
    winners.setSelectorText('$auctions_total', auctions.length, '#');
    //
    return { cols: settings.cols };
  };


  charts.create.chart4 = function createChartData4(auctions) {
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
  };

  charts.create.chart5 = function createChartData5(auctions) {
    var settings = {};
    settings.cols = [];
    settings.z = {};
    settings.xs = {};

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
        var winningBid = auction.values[0].bids.length
          ? d3.min(_.pluck(auction.values[0].bids, 'amount'))
          : undefined;
        settings.cols.push([auction.key, auction.values[0].bids.length]);
        settings.xs[auction.key] = dateString;
        settings.z[auction.key] = winningBid; // $ amount
      });
    });

    return settings;
  };

  // Donut by repo
  charts.create.donut1 = function createDonutSettings1(auctions) {
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
  };

    // Donut by repo
  charts.create.donut2 = function createDonutSettings2(auctions) {
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
      {'name': '18F/deduplicate-tock-float', 'language': undefined}
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
  };

  charts.settings = function setChartSettings(data) {
    var auctions = _.sortBy(data.auctions, 'id');
    var settings = {};
    settings.metrics = charts.create.metrics(auctions)
    settings.chart2 = charts.create.chart2(auctions);
    // settings.chart2 = charts.create.chart21(auctions)
    settings.chart4 = charts.create.chart4(auctions);
    settings.chart5 = charts.create.chart5(auctions);
    settings.donut1 = charts.create.donut1(auctions);
    settings.donut2 = charts.create.donut2(auctions);

    return settings;
  };


  charts.run = function runVisualizations (data, settings) {
    settings = settings ? settings : setChartSettings(data);

    charts.load.chart2(settings.chart2);
    charts.load.chart4(settings.chart4);
    charts.load.chart5(settings.chart5);
    charts.load.donut1(settings.donut1);
    charts.load.donut2(settings.donut2);
  };

  window.mpWinners = {};
  var mpWinners = window.mpWinners = {};


  winners.onReady = function(){

    winners.selectors = {
      $success: winners.selectMetric('success'),
      $bidding_vendors: winners.selectMetric('bidding_vendors'),
      $bids: winners.selectMetric("bids"),
      $vendors: winners.selectMetric("vendors"),
      $projects: winners.selectMetric("projects"),
      $winning_bid: winners.selectMetric("winning_bid"),
      $unique_winners: winners.selectMetric('unique_winners'),
      $auction_length: winners.selectMetric('auction_length'),
      $auctions_total: winners.selectMetric('auctions_total')
    }

    // Retrieve data
    $.getJSON('/auctions.json').success(function(data){

      var settings = charts.settings(data);
      charts.run(data, settings);
    })
    .error(function(error){
      throw "Error retrieving auction data";
    });

  }

  $(document).ready(winners.onReady);

})(this);
