function getQueryVariable(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split("&");
    for (var i = 0; i < vars.length; i++) {
        var pair = vars[i].split("=");
        if (pair[0] == variable) {
            return pair[1];
        }
    }
    return null;
}

function initBody() {
  $('body').removeClass('no-js');
}

$(document).ready(function() {
  initBody();
  
  $('body').removeClass('no-js');

  $('.layout-customers-index main').addClass('overthrow');

  if ($('body').hasClass('layout-auctions-show')) {
    $('.field-auction-status select').change(function(){
      statusCode = $(this).find('option:selected').attr("value");
      userType = $(this).find('option:selected').parent('optgroup').attr('label');
      $('.nav-user select').find('option[value="' + userType + '"]').prop('selected', true);
      $('.nav-user select').change();
      window.history.pushState('Test', 'Title', '?auctionWorkflowState=' + statusCode);
      workflowClass = "auction-workflow-" + statusCode;
      $('body').removeClass (function (index, css) {
        return (css.match (/(^|\s)auction-workflow-\S+/g) || []).join(' ');
      });
      $('body').addClass(workflowClass);
    });

    var auctionWorkflowState = getQueryVariable("auctionWorkflowState");
    console.log(auctionWorkflowState);
    if (auctionWorkflowState != null) {
      $('.field-auction-status select').find('option[value="' + auctionWorkflowState + '"]').prop('selected', true);
    }
    $('.field-auction-status select').change();

    $('.auction-workflow form').submit(function(e){
      e.preventDefault();
      var auctionWorkflowState = $(this).data('auction-workflow-state');
      if (auctionWorkflowState) {
        $('.field-auction-status select').find('option[value="' + auctionWorkflowState + '"]').prop('selected', true);
        $('.field-auction-status select').change();
        workflowClass = "auction-workflow-" + auctionWorkflowState;
        $('body').removeClass (function (index, css) {
          return (css.match (/(^|\s)auction-workflow-\S+/g) || []).join(' ');
        });
        $('body').addClass(workflowClass);
      } else {
        var bidVal = $(this).find('input').val();
        confirm("Are you sure you want to place a bid for $" + bidVal + "?");
      }
    })
  }

  var userType = Cookies.get('mpp-user-type');
  if (userType) {
    $('.nav-user select option[value="'+userType+'"]').prop('selected', true);
    $('body')
      .removeClass('user-type-vendor')
      .removeClass('user-type-admin')
      .addClass('user-type-' + userType);
  } else {
    Cookies.set('mpp-user-type', 'admin');
    $('.nav-user select option[value="admin"]').prop('selected', true);
  }

  $('.nav-user select').change(function(){
    var userType = $(this).find('option:selected').attr("value");
    Cookies.set('mpp-user-type', userType);
    $('body')
      .removeClass('user-type-vendor')
      .removeClass('user-type-admin')
      .addClass('user-type-' + userType);
    Cookies.set('mpp-signed-in', 'true');
    renderSiteHeaderSignIn()
  });

  $('input').focus(function(){
    $(this).parents('.field').addClass('is-focused')
  });
  $('input').blur(function(){
    $(this).parents('.field').removeClass('is-focused')
  });

  function renderSiteHeaderSignIn(){
    if (Cookies.get('mpp-signed-in')) {
      $('body').addClass('signed-in');
    } else {
      $('body')
        .removeClass('signed-in')
        .removeClass('user-type-vendor')
        .removeClass('user-type-admin');
    }
  }

  renderSiteHeaderSignIn();

  $('.site-header .a-sign-in, .site-header .a-sign-up').click(function(){ 
    Cookies.set('mpp-signed-in', 'true'); 
    renderSiteHeaderSignIn()
  });
  $('.site-header .a-sign-out').click(function(){ 
    Cookies.remove('mpp-signed-in');
    renderSiteHeaderSignIn()
  });

  $('.fieldset-start-date-time .field-date input').change(function(){
    var startDate = $(this).val();
    console.log(startDate);
    $('.fieldset-end-date-time .fieldset-date-time-summary .date')
      .text(startDate);
    $('.fieldset-delivery-date-time .fieldset-date-time-summary .date')
      .text(startDate);
  });

    $('.fieldset-start-date-time .field-time-hours select').change(function(){
    var startTime = $(this).find('option:selected').attr("value");
    $('.fieldset-end-date-time .fieldset-date-time-summary .time-hours')
      .text(startTime);
    $('.fieldset-delivery-date-time .fieldset-date-time-summary .time-hours')
      .text(startTime);
  });

  $('.fieldset-start-date-time .field-time-minutes select').change(function(){
    var startTime = $(this).find('option:selected').attr("value");
    $('.fieldset-end-date-time .fieldset-date-time-summary .time-minutes')
      .text(startTime);
    $('.fieldset-delivery-date-time .fieldset-date-time-summary .time-minutes')
      .text(startTime);
  });

  $('.fieldset-start-date-time .field-time-meridiem select').change(function(){
    var startTime = $(this).find('option:selected').attr("value");
    $('.fieldset-end-date-time .fieldset-date-time-summary .time-meridiem')
      .text(startTime);
    $('.fieldset-delivery-date-time .fieldset-date-time-summary .time-meridiem')
      .text(startTime);
  });

  $('.a-customize-timeline').click(function(){
    $('body').addClass('with-customized-timeline');
    $('.auction-workflow-ready-to-publish-admins p.p-date-time-defaults').text("This auction is ready to publish! Please select a start date, end date, and delivery period for this auction.")
    $('.auction-workflow-ready-to-publish-admins p.p-customize-timeline').text("As a point of reference, auctions are usually listed for two days and vendors have five business days to deliver.");
    return false;
  });


});