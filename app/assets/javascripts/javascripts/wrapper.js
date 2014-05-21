(function ( $ ) {

  $.fn.print = function(data, collapsed) {
    if(collapsed==undefined)
      var collapsed = true;
    $('.json-view', this).JSONView(data, { collapsed: collapsed } );
    var $this = this.removeClass('shake');
    setTimeout(function(){$this.addClass('shake');},300);
    return this;
  };

  $.fn.collapsable = function(){
    var $this = this;
    $('.title', this).click(function(){
      $this.toggleClass('open');
    });
    return this;
  };

}( jQuery ));
