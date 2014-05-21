geo.map = null;
function initialize() {
  navigator.geolocation.getCurrentPosition(function(position) {
    var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    var style = [
      {
        featureType: "landscape",
        stylers: [ { visibility: "off" } ]
      },{
        featureType: "road",
        stylers: [ { visibility: "off" } ]
      },{ 
        featureType: "all",
        elementType: "geometry.fill", 
        stylers: [ { "gamma": 1.46 }, { "color": "#666666" }, { "hue": "#0091ff" }, { "saturation": -54 }, { "lightness": 5 } ] 
      },{
        featureType: "all",
        elementType: "labels",
        stylers: [ { saturation: -100 }, { invert_lightness: true }, { gamma: 0.8 }, { visibility: "on" } ]
      }
    ];
    var mapOptions = {
      zoom: 12,
      center: pos,
      scrollwheel: false,
      mapTypeId: 'clean',
      mapTypeControlOptions: {
        mapTypeIds: ['clean', google.maps.MapTypeId.TERRAIN]
      }
    };
    geo.map = new google.maps.Map($('.fn-map')[0], mapOptions);
    geo.map.mapTypes.set('clean', new google.maps.StyledMapType(style, { name: 'Clean' }));
    if(geo.api){
      var marker = new google.maps.Marker({
        position: pos,
        map: geo.map,
        icon: '/assets/marker.png',
        draggable:true
      });
      google.maps.event.addListener(marker, 'dragend', function(event){
        geo.api.map.current(event.latLng);
      });
    }
    if(geo.api)
      geo.api.map.current(pos);
    if(geo.charts)
      geo.charts.loadedMap();
  });
}

function loadScript() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyCBSzBDmJekpUpguBOTcUTL_6s6f3zKNiA&sensor=true&libraries=visualization&' +'callback=initialize';
  document.body.appendChild(script);
}

window.onload = loadScript;
