'use strict';

(function (window) {


  window.winners = {
    onReady: function(){
      // Retrieve data
      var MP = 'https://micropurchase.18f.gov/auctions.json'
      var relative = '/auctions.json'
      $.getJSON(MP).success(function(data){
        var auctions = _.sortBy(data.auctions, 'id');

        window.winners.metrics = new Metrics(auctions);

        window.winners.charts = new Charts(auctions);

      })
      .error(function(error){
        throw "Error retrieving auction data";
      });

    }
  }

  $(document).ready(window.winners.onReady);

})(this);
