$(function(){

$.extend( geo, {
  charts: {
    stack: [],
    willRedraw: null,
    init: function(){
      $(window).resize(geo.charts.redraw);
    },
    redraw: function(){
      if(geo.charts.willRedraw!=null) clearTimeout(geo.charts.willRedraw);
      geo.charts.willRedraw = setTimeout(function(){
        $.each(geo.charts.stack, function(){
          this.redraw();
        });
      }, 500);
    },
    cities: function(data){
      var points = [];
      $.each(data,function(){
        points.push( { location: new google.maps.LatLng(this.latitude, this.longitude), weight: this.cnt*10 } );
      });
      new google.maps.LatLng()
      var heatmap = new google.maps.visualization.HeatmapLayer({ data: points });
      heatmap.setMap(geo.map);
    },
    line: function(data, id, labels){
      geo.charts.stack.push(Morris.Line({
        element: id,
        data: data,
        xkey: 'reg_date',
        ykeys: ['cnt'],
        labels: labels
      }));
    }
  }
});

geo.charts.init();

});
