$(document).ready(function() {
  $("#auction_purchase_card").on("change", function(event) {
    c2_status = $("#auction_c2_status").val()
    published_select_element = $("#auction_published")

    published_option = "<option value='published'>published</option>"
    unpublished_option = "<option value='unpublished'>unpublished</option>"

    if(this.value === "default" && c2_status !== "budget_approved") {
      published_select_element.empty().append(unpublished_option)
    } else {
      published_select_element.empty().append(unpublished_option, published_option)
    }
  });
});
