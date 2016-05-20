'use strict';

(function (window) {

  var microp = window.microp

  var Metrics = function (auctions) {
    this.auctions = auctions;

    this.selectors = {
      $bidding_vendors: this.selectMetric('bidding_vendors'),
      $bids: this.selectMetric("bids"),
      $winning_bid: this.selectMetric("winning_bid"),
      $unique_winners: this.selectMetric('unique_winners'),
      $auction_length: this.selectMetric('auction_length'),
      $auctions_total: this.selectMetric('auctions_total')
    };

    this.generate();
  }

  Metrics.prototype = {
    selectMetric: function selectMetric(metricName) {
      return $('[data-metric][data-name="'+metricName+'"]')
    },
    setSelectorText: function setSelectorText(name, text, formatter) {
      if (formatter === "$") {
        text = microp.format.commaSeparatedDollars(text);
      } else if (formatter === '#') {
        text = Math.round(text * 10) / 10;
      } else if (formatter === 'days') {
        text = Math.round(text * 10) / 10 + ' days';
      }
      this.selectors[name].text(text);
    },
    getWinningBids: function getWinningBids() {
      return _.pluck(this.auctions, 'winning_bid');
    },
    getWinningBidAmounts: function getWinningBidAmounts() {
      var winningBids = this.getWinningBids();
      return _.pluck(winningBids, 'amount');
    },

    meanWinningBids: function meanWinningBids() {
      var winningBids = this.getWinningBidAmounts();
      return d3.mean(winningBids);
    },

    getAllBidders: function getAllBidders() {
      return _.map(this.auctions, function(auction){
        return _.pluck(auction.bids, 'bidder_id');
      });
    },

    getNumberUniqueWinners: function getNumberUniqueWinners(unique) {
      var winningBids = this.getWinningBids(this.auctions);
      winningBids = _.filter(_.pluck(winningBids, 'bidder_id'), function(num) {
        if (_.isNumber(num)) {
          return num;
        }
      });
      if (unique) {
        winningBids = _.uniq(winningBids);
      }
      return winningBids.length;
    },

    getBidsPerAuction: function() {
      var bidsPerAuction = _.map(this.auctions, function(auction, key){
        return auction.bids.length
      })
      return d3.mean(bidsPerAuction);
    },

    getBiddingVendors: function() {
      var biddingVendors = _.map(this.auctions, function(auction, key){
        return _.pluck(auction.bids, 'bidder_id');
      });
      biddingVendors = _.uniq(_.flatten(biddingVendors)).length;
      return biddingVendors;
    },

    getUniqueRepos: function getUniqueRepos() {
      var repos = _.pluck(this.auctions, 'github_repo')
      repos = _.map(repos, function(value,key) {
        return microp.format.stardardizeUrl(value);
      })
      repos = _.uniq(repos).length;
      return repos;
    },

    getAuctionLength: function getAuctionLength() {
      var auctionL =  _.map(this.auctions, function(auction){
        var timeDiff = new Date(auction.ended_at) - new Date(auction.started_at);
        var dayUTF = 1000 * 60 * 60 * 24;
        return (timeDiff / dayUTF);
      });
      return d3.mean(auctionL);
    },
    generate: function () {
      this.uniqueWinners = this.getNumberUniqueWinners(true);
      this.avgWinningBids = this.meanWinningBids();
      this.repos = this.getUniqueRepos();
      this.bidsPerAuction = this.getBidsPerAuction();
      this.biddingVendors = this.getBiddingVendors();
      this.auctionLength = this.getAuctionLength();

      this.setSelectorText('$auctions_total', this.auctions.length);
      this.setSelectorText('$unique_winners', this.uniqueWinners);
      this.setSelectorText('$bids', this.bidsPerAuction, '#');
      this.setSelectorText('$bidding_vendors', this.biddingVendors, '#');
      this.setSelectorText('$auction_length', this.auctionLength, 'days');
      this.setSelectorText('$winning_bid', this.avgWinningBids, '$');
    }
  }

  window.Metrics = Metrics;

}(this));
