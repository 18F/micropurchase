$(document).ready(function() {
  $(".auction-subnav a").on("click", function(event) {
    event.preventDefault();
    $('.js-auction-view').toggle();
    $('.auction-subnav a').toggleClass('active');
  });
});
