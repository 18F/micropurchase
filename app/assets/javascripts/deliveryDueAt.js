$(document).ready(function() {
  calculateNewDate = function() {
    auctionEndedAt = $("#auction_ended_at").val();
    dueInDays = $("#auction_due_in_days").val();
    hour = $("#auction_ended_at_1i").val();
    minute = $("#auction_ended_at_2i").val();
    amPm = $("#auction_ended_at_3i").val();
    $.getJSON(
      '/api/v0/business_day',
      { day_count: dueInDays, date: auctionEndedAt, time: (hour + ":" + minute + " " + amPm)  },
      function(data) {
        $('.delivery-date').text(data.date);
    });
  };

  $(".auction_due_in_days").change(function() {
    calculateNewDate();
  });

  $(".ended_at").change(function() {
    calculateNewDate();
  });
});
