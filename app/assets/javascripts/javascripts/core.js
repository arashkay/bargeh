var core = {};

$(function(){

core = {
  security: { authenticity_token: $('[name=csrf-token]').attr('content') },
  /*
    * if data-busy no re-submit
    * i tag inside the element will be faded
    * 
    <span class='btn' data-remote='YOUR_SUBMIT_URL' data-busy='true' data-method='DELETE' data-form='.fn-form' data-parent='li' data-target='#target' data-success='system.namespace.success_method'>ajax submit button</span>
  */
  init: function(){
    $.ajaxSetup( { headers: { 'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content') } } );
    core.form.init();
  },
  form: {
    init: function(){
      core.form.files();
      $('[data-remote]:not([data-on])').bind('click', core.form.remote );
      $('[data-remote][data-on=type]').bind('input', function(){
        var $t = $(this);
        var action = $t.data('remote.timeout');
        if(action!=undefined)
          clearTimeout(action);
        action = setTimeout(function(){core.form.remote.call($t)}, 1000);
        $t.data('remote.timeout', action);
      });
      $('[data-updatable=remote]').on('click', '[data-remote]', core.form.remote );
    },
    remote: function() {
      var $t = $(this);
      if($t.data('busy')) return;
      var data = {};
      if($t.is('[data-method]')) data._method = $t.data('method');
      if($t.is('[data-form]')) $.extend(data, core.form.read($t.data('form')));
      if($t.is('[data-parent]')) $.extend(data, core.form.read($t.parents($t.data('parent')+':first')));
      var target = $($t.is('[data-target]')? $t.data('target') : $t);
      $t.data('busy', true);
      core.loader.show($t);
      $.post( $t.data('remote'), data ).success( function(d){
        $t.data('busy', false);
        core.loader.hide($t);
        if($t.is('[data-success]')) eval($t.data('success')).call( target, d);
      });
    },
    read: function(form){
      form = $(form);
      var data = {};
      $('input:not([type=radio]), select, textarea', form).each(function(){
        data[$(this).attr('name')] = $(this).val();
      });
      $('input[type=radio]:checked', form).each(function(){
        data[$(this).attr('name')] = $(this).val();
      });
      return data;
    },
    files: function(){
      if(!$.isFunction($.fn.fileupload)) return;
      $('[data-uploader]').fileupload({
        dataType: 'json',
        formData: core.security,
        send: function(){
          core.loader.show();
        },
        done: function (e, data) {
          core.loader.hide();
          var $this = $(e.target);
          eval($this.data('callback')).call($this, data.result);
        }
      });
    }
  },
  loader: {
    count: 0,
    show: function($this){
      if(core.loader.count!=0) return;
      $('i', $this).animate( { opacity: 0.1 } );
      $('.fn-loading').fadeIn()
      core.loader.count++;
    },
    hide: function($this){
      core.loader.count--;
      if(core.loader.count>0) return;
      core.loader.count=0;
      $('i', $this).animate( { opacity: 1 } );
      $('.fn-loading').fadeOut()
    }
  }
}
core.init();

});
