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

	  switch (feature.properties.Registrada) {
	    case 'Si': return {color: "#F01414"};
	    case 'No':   return {color: 'blue'};
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

		APIcall(true, false);
  });

  product = "all";
  eco = "all";
  order_by = "price";
  order_direction = "asc";

  APIcall(true, true);
	
	function APIcall(init, first) {

    $.getJSON('/maps/new?b[]='+ NElat+'&b[]='+NElon+'&b[]='+SWlat+'&b[]='+SWlon+'&init='+init.toString(),

    	function(json) {

		    if(init) {
		    	if(first==false) {
		    		geoLayer.clearLayers();
		    	}
		    	geoLayer = L.geoJson(json,{style: styling}).addTo(map);

		    	var geoList = new L.Control.GeoJSONList(geoLayer,{

			      listItemBuild: function(layer) {
			        var item = L.DomUtil.create('div','');
			        item.innerHTML = L.Util.template(
			        itemListHTML() , 
			        layer.feature.properties);
			        return item;} 
    			});
   			
		    }else {
		    	geoLayer.addData(json);
		    }

		    geoList.on('item-active', function(e) {
		    
		      console.log(e.layer.feature.properties);
		      console.log(e.layer.feature.properties.Id);
		      $('#farmland_id').val((e.layer.feature.properties.Id).toString());
		    });

		    $('.leaflet-bottom').css('display','none');
		     map.addControl(geoList);

		});
	}

	function itemListHTML() {
		return ('<div></div>');	
	}

});



