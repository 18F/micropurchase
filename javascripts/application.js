function initBody() {
  $('body').removeClass('no-js');
}

$(document).ready(function() {
  initBody();
  
  $('body').removeClass('no-js');

  $('.nav-page select').change(function(){
    window.location.href = $(this).find('option:selected').attr("value");
  });

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
      $('.site-header .signed-in').show();
      $('.site-header .signed-out').hide();
    } else {
      $('.site-header .signed-in').hide();
      $('.site-header .signed-out').show();
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