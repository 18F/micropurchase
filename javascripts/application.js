function initBody() {
  $('body').removeClass('no-js');
}

$(document).ready(function() {
  initBody();
  
  $('body').removeClass('no-js');

  $('input').focus(function(){
    $(this).parents('.field').addClass('is-focused')
  });
  $('input').blur(function(){
    $(this).parents('.field').removeClass('is-focused')
  });

  $('.site-header .signed-in').hide();
  if (Cookies.get('mpp-signed-in')) {
    $('.site-header .signed-in').show();
    $('.site-header .signed-out').hide();
  }

  $('.site-header .a-sign-in, .site-header .a-sign-up').click(function(){ Cookies.set('mpp-signed-in', 'true'); });
  $('.site-header .a-sign-out').click(function(){ Cookies.remove('mpp-signed-in'); });

});