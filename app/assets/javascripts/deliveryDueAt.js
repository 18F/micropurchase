$(document).ready(function() {
  calculateNewDate = function() {
    $('.estimated-delivery-date').text("Save your changes to see updated delivery date and time");
  };

  $( ".auction_due_in_days").change(function() {
    calculateNewDate();
  });

  $( ".auction_ended_at").change(function() {
    calculateNewDate();
  });
});
