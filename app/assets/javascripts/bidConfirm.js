$(document).ready(function() {
  $('#new_bid').submit(function() {
    var stringVal = $("#bid_amount").val();
    var integerVal = parseInt(stringVal, 10);
    var currencyVal = integerVal.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,');
    var currencyString = "$" + currencyVal.toString();
    return confirm("Are you sure you want to place a bid for " + currencyString + "?");
  })
});
