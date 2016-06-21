$(document).ready(function() {
  $(".auction-header a").on("click", function(event) {
    event.preventDefault();
    $('.js-auction-view').toggle();
    $('.auction-header a').toggleClass('active');
  });
});
