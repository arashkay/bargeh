var geo = {};
var defaults = { facebook: {} };

$(function(){

$.extend( geo, {
  init: function(){
    $('select').select2();
    geo.menu();
    $('[data-toggle="popover"]').popover();
    $('[data-toggle="tooltip"]').tooltip();
    geo.autoSubmit();
  },
  autoSubmit: function(){
    $('[data-auto-submit]').keypress(function(e){
      if(e.keyCode != 13) return;
      location.href = $(this).data('auto-submit')+'?q='+$(this).val();
    });
  },
  menu: function(){
    var sub = $('.fn-submenu');
    if(sub.size()==0) return;
    sub.css({position: 'fixed'});
    $('.main').css({paddingTop:'51px'});
  },
  reload: function(){
    location.href = location.href;
  }
});

geo.init();

});
