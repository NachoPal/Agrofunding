$(document).ready(function(){

 var map = L.map('map').setView([41.976140, -1.640856], 16);

 L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', 
 	{
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'nachopal.cf9cd065',
    accessToken: 'pk.eyJ1IjoibmFjaG9wYWwiLCJhIjoiM2NGMTlyQSJ9.bWIEpQg8AJcz3Yumqt-MEg'

 	}).addTo(map);

	var styling = function(feature){

	  switch (feature.properties.Producto) {
	    case 'Tomate': return {color: "#F01414"};
	    case 'Uva':   return {color: "#CED65E"};
	    case 'Vino':   return {color: "#B61256"};
	    case 'Esparrago':   return {color: "#69EDF6"};
	    case 'Pimiento':   return {color: "#8E0B0B"};
	    case 'Lechuga':   return {color: "#0FC00C"};
	    case 'Judia':   return {color: "#097007"};
	    case 'Alcachofa':   return {color: "#7A410C"};
	    case 'Zanahoria':   return {color: "#F7BA22"};
	    case 'Patata':   return {color: "#FFF926"};  
	   }  
	}

  bounds = map.getBounds();
  SWlat = bounds._southWest.lat
  SWlon = bounds._southWest.lng
  NElat = bounds._northEast.lat
  NElon = bounds._northEast.lng

  map.addEventListener('zoomend moveend', function(event){
			    
		bounds = map.getBounds();
		SWlat = bounds._southWest.lat
		SWlon = bounds._southWest.lng
		NElat = bounds._northEast.lat
		NElon = bounds._northEast.lng

		APIcall(false);
  });

  product = "all";
  eco = "all";
  order_by = "price";
  order_direction = "asc";

  APIcall(true);

	
	function APIcall(init) {

    $.getJSON('/maps?product='+product+'&eco='+eco+'&order[]='+order_by+'&order[]='+order_direction+'&b[]='+
    					 NElat+'&b[]='+NElon+'&b[]='+SWlat+'&b[]='+SWlon+'&init='+init.toString(),

    	function(json) {

		    if(init) {
		    	geoLayer = L.geoJson(json,{style: styling}).addTo(map);

		    }else {
		    	geoLayer.addData(json);
		    	$('#list').empty();
		    }
		    // map
		    // .fitBounds( geoLayer.getBounds() )
		    //.setMaxBounds( geoLayer.getBounds().pad(0.5) );

		    var geoList = new L.Control.GeoJSONList(geoLayer,{
		      listItemBuild: function(layer) {
		        var item = L.DomUtil.create('div','');
		        item.innerHTML = L.Util.template('<br>Producto: {Producto} <br>Area: {Area} <br><a href="/fundings/new?farmland_id={Id}">Subscribirse</a>', layer.feature.properties);
		        return item;} 
    		});
   
		    geoList.on('item-active', function(e) {
		      $('#properties').text( JSON.stringify(e.layer.feature.properties) );
		    });

		    map.addControl(geoList);

		    var farm_list = $('.geojson-list');    
		    $('#list').append(farm_list); 

		     console.log(geoList) 
		     delete(geoList)  
		});
	}
});



