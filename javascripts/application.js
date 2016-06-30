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

});