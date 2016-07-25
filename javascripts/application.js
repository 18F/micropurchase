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

  $('.nav-page select').change(function(){
    window.location.href = $(this).find('option:selected').attr("value");
  });

  $('.auction-workflow').hide();

  $('.field-auction-status select').change(function(){
    $('.auction-workflow').hide();
    statusCode = $(this).find('option:selected').attr("value");
    console.log(statusCode);
    userType = $(this).find('option:selected').parent('optgroup').attr('label');
    $('.nav-user select').find('option[value="' + userType + '"]').prop('selected', true);
    $('.nav-user select').change();
    workflowClass = "auction-workflow-" + statusCode;
    window.location.search = "auctionWorkflowState=" + statusCode;
    console.log(workflowClass);
    $('.' + workflowClass).show();
  });

  var auctionWorkflowState = getQueryVariable("auctionWorkflowState");
  console.log(auctionWorkflowState);
  if (auctionWorkflowState != null) {
    $('.field-auction-status select').find('option[value="' + auctionWorkflowState + '"]').prop('selected', true);
  }
  $('.field-auction-status select').change();

  var userType = Cookies.get('mpp-user-type');
  if (userType) {
    $('.nav-user select option[value="'+userType+'"]').prop('selected', true);
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

  $('.nav-user select').change();

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
      $('body').removeClass('signed-in');
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
  });


});