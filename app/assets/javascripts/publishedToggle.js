$(document).ready(function() {
  $("#auction_purchase_card").on("change", function(event) {
    published_select_element = $("#auction_published")

    published_option = "<option value='published'>published</option>"
    unpublished_option = "<option value='unpublished'>unpublished</option>"

    if(this.value == "default") {
      published_select_element.empty().append(unpublished_option)
    } else {
      published_select_element.empty().append(published_option, unpublished_option)
    }
  });
});
