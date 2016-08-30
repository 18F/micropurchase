'use strict';

(function (window) {
  window.winners = {
    onReady: function(){
      $.getJSON('api/v0/auctions.json').success(function(data) {
        var auctions = _.sortBy(data.auctions, 'id');
        window.winners.charts = new Charts(auctions);
      })
      .error(function(error){
        throw "Error retrieving auction data";
      });
    }
  }

  $(document).ready(window.winners.onReady);
}(this));
