var user_params = { user: ['first_name', 'last_name', 'gender', 'number', 'birthdate', 'city', 'latitude', 'longitude'], device: [ 'device_id', 'device_type', 'notification_id', 'can_notify' ] };
var api = [
  { 
    path: "POST /api/v1/authenticate.json",
    params: { user: ['number'], device: ['device_id'] },
    token: false,
    comment: '.fn-comment-authenticate'
  },
  { 
    path: "POST /api/v1/me.json",
    params: user_params,
    token: false,
    comment: '.fn-comment-user'
  },
  { 
    path: "GET /api/v1/me.json",
    params: { extend: null },
    comment: '.fn-comment-me'
  },
  { 
    path: "PUT /api/v1/me.json",
    params: user_params,
    comment: '.fn-comment-user'
  },
  { 
    path: "GET /api/v1/cards.json",
    params: { scope: ['latitude', 'longitude', 'just_mine'] },
    comment: '.fn-comment-cards'
  },
  { 
    path: "POST /api/v1/me/cards/punch.json",
    params: { card: ['ucode'] }
  },
  { 
    path: "POST /api/v1/me/cards/use.json",
    params: { card: ['ucode'] }
  },
  { 
    path: "POST /api/v1/me/coupons/mark.json",
    params: { coupon: ['id'], mark: null }
  },
  { 
    path: "POST /api/v1/me/messages.json",
    params: { message: ['to_user_id', 'body'] }
  },
  { 
    path: "GET /api/v1/me/conversations.json",
    params: { scope: ['page'] }
  },
  {
    path: "GET /api/v1/me/messages/:with_user_id.json",
    params: { scope: ['message_id', 'is_read'] },
    comment: '.fn-comment-messages'
  },
  {
    path: "POST /api/v1/me/messages/viewed.json",
    params: { ids: null },
    comment: '.fn-comment-view-messages'
  },
  { 
    path: "POST /api/v1/me/photos.json",
    params: { photo: ['source', 'uid', 'image_url'] }
  },
  { 
    path: "GET /api/v1/venues.json",
    params: { scope: ['latitude', 'longitude', 'name'] }
  },
  { 
    path: "POST /api/v1/venues/suggest.json",
    params: { venue: ['name', 'phone', 'address', 'latitude', 'longitude', 'image'] }
  },
  { 
    path: "PUT /api/v1/me/location.json",
    params: { location: ['latitude', 'longitude'] }
  },
  { 
    path: "POST /api/v1/photos/:id/flagged.json",
    params: { flag: ['body'] }
  },
  { 
    path: "POST /api/v1/users/:id/flagged.json",
    params: { flag: ['body'] }
  }
]

$(function(){

$.extend( geo, {
  api: {
    time: 0,
    init: function(){
      $('.fn-login').click(function(){
        switch($('select.fn-oauth').val()){
          case 'google':
            break;
          case 'facebook':
            FB.login(geo.api.facebook.login, {scope: 'email, user_birthday, user_checkins, user_location, user_photos, user_likes, user_about_me, user_friends'} );
            break;
        }
      });
      $('.fn-profile').click(geo.api.facebook.getProfile);
      geo.api.json();
      $('.collapsable').collapsable();
      $('.fn-call').click(geo.api.request);
      $('select.fn-action').change(geo.api.form).change();
    },
    actAs: function(uid, token, source){
      $('.fn-oauth').select2('val', source).change();
      $('.fn-uid').val(uid);
      $('.fn-token').val(token);
      $('.fn-action').select2('val', 'POST /api/v1/authenticate.json').change();
    },
    form: function(){
      var val = $(this).val();
      $('.fn-params').empty();
      $('.fn-comment').hide();
      var inUrlParams = val.match(/:[\w]+/ig);
      if(inUrlParams!=null){
        $.each(inUrlParams, function(){
          geo.api.createParam(this);
        });
      }
      var item = geo.api.find(val);
      if(item!=null&&item.params!=undefined){
        $.each( item.params, function(p, a){
          if(a==null)
            return geo.api.createParam(p);
          $.each(a, function(){
            geo.api.createParam(p+'.'+this);
          });
        });
      }
      if(item!=null&&item.comment!=undefined){
        $(item.comment).show();
      }
      if(item==null||item.token!=false){
        geo.api.createParam('authentication_token');
      }
    },
    find: function(val){
      var found = null;
      $.each(api, function(k,v){
        if(v.path!=val) return true;
        found = v;
        return false;
      });
      return found;
    },
    createParam: function(name){
      var val = null;
      var field = $('<div class="param"><i class="fa fa-plus" />'+name+'<input type="text" name="'+name+'" placeholder="'+name+'"/></div>');
      if(name.indexOf('user.source')!=-1)
        val = $('select.fn-oauth').val();
      if(name.indexOf('user.uid')!=-1)
        val = $('.fn-uid').val();
      if(name.indexOf('user.token')!=-1)
        val = $('.fn-token').val();
      if(name.indexOf('authentication_token')!=-1){
        $.ajaxSetup({ headers: { 'AUTH-TOKEN': $('.fn-auth-token').val() } });
        val = $('.fn-auth-token').val();
      }
      if(name.indexOf('latitude')!=-1)
        val = geo.api.map.latlng.lat;
      if(name.indexOf('longitude')!=-1)
        val = geo.api.map.latlng.lng;
      if(val!=null) $('input', field).val(val);
      $('.fn-params').append(field);
    },
    request: function(){
      var val = $('select.fn-action').val();
      var item = geo.api.find(val);
      var action = val.split(' ');
      var method = action[0];
      action = action[1];
      var inUrlParams = action.match(/:[\w]+/ig);
      if(inUrlParams!=null){
        $.each(inUrlParams, function(i,v){
          action = action.replace(v, $('[name="'+v+'"]', '.fn-params').val());
        });
      }
      var data = { _method: method };
      $('.fn-params input').each(
        function(){
          var name = $(this).attr('name');
          var val = $(this).val();
          if(val=='') return true;
          if(name.indexOf('.')==-1)
            data[name] = val;
          else{
            name = name.split('.');
            if(data[name[0]]==undefined)
              data[name[0]] = {};
            data[name[0]][name[1]] = val;
          }
        }
      );
      var request = $.post(action, data).done( geo.api.response ).fail( geo.api.failed );
      if(item!=undefined&&item.callback!=undefined){
        request.done( eval(item.callback) );
      }
      geo.api.time = new Date();
    },
    response: function(response){
      $('.fn-speed').text(new Date()-geo.api.time);
      if(response.data!=undefined&&response.data.authentication_token!=undefined)
        $('.fn-auth-token').val(response.data.authentication_token);
      $('.fn-response').print(response, !$('.fn-response [type=checkbox]').is(':checked'));
    },
    failed: function(response){
      $('.fn-response').print({ HTTP_STATUS: response.status, DATA: response.responseJSON }, false);
    },
    json: function(){
      $('.json-view-head').click(function(){
        $(this).next('.json-view').toggle();
      });
    },
    facebook: {
      login: function(response){
        $('.fn-login-result').print(response);
        $('.fn-uid').val(response.authResponse.userID);
        $('.fn-token').val(response.authResponse.accessToken);
      },
      getProfile: function(){
        FB.api('/me/', geo.api.facebook.profile);
        FB.api('/me/picture?type=large', geo.api.facebook.picture);
      },
      profile: function(response){
        $('.fn-profile-result').print(response);
      },
      picture: function(response){
        $('.fn-picture-result').print(response);
        $('.fn-picture').attr('src', response.data.url);
      }
    },
    /*fb: function(){
        console.log('Welcome!  Fetching your information.... ');
        FB.api('/me', function(response) {
          console.log('Good to see you, ' + response.name + '.');
        });
    },*/
    map: {
      latlng: { lat: '', lng: ''},
      markers: [],
      mark: function(data){
        $.each(geo.api.map.markers, function(k,v){
          v.setMap(null);
        });
        geo.api.map.markers = [];
        $.each( data.data, function(k, v){
          var latlng = new google.maps.LatLng(v.latitude, v.longitude);
          geo.api.map.markers.push( new google.maps.Marker({ position: latlng, map: geo.map, title: v.first_name }) );
        });
      },
      current: function(latLng){
        geo.api.map.latlng.lat = latLng.lat();
        geo.api.map.latlng.lng = latLng.lng();
        $('input').each(function(){
          var name = $(this).attr('name');
          if(name==undefined) return true;
          if( name.indexOf('latitude')>-1 )
            $(this).val(geo.api.map.latlng.lat);
          if( name.indexOf('longitude')>-1 )
            $(this).val(geo.api.map.latlng.lng);
        });
      }
    }
  }
});

geo.api.init();

});
