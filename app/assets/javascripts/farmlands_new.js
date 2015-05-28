$(document).ready(function(){

 var map = L.map('map').setView([41.976140, -1.640856], 16);

 L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', 
 	{
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'nachopal.cf9cd065',
    accessToken: 'pk.eyJ1IjoibmFjaG9wYWwiLCJhIjoiM2NGMTlyQSJ9.bWIEpQg8AJcz3Yumqt-MEg'

 	}).addTo(map);

 //var marker = L.marker([41.976140, -1.640856]).addTo(map);

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
		//$('#list').empty();
		APIcall(true, false);
  });

  product = "all";
  eco = "all";
  order_by = "price";
  order_direction = "asc";

  APIcall(true, true);

 //  $('#btn-filter').on('click',function(){
  	
	// 	product = $('#product-chosen').val();
	// 	order_by = $('#order-chosen').val();
	// 	eco = $('#eco-chosen').is(":checked");
	// 	order_direction = $('#order-direction').val();
	// 	$('.map-and-list').css('flex','11');
	// 	$('#properties').css('flex','0');

	// 	APIcall(true, false);
		
	// })
	
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
   			
   			
		    	//$('#list').empty();
		    }else {
		    	geoLayer.addData(json);
		    	//$('#list').empty();
		    }
		    // map
		    // .fitBounds( geoLayer.getBounds() )
		    //.setMaxBounds( geoLayer.getBounds().pad(0.5) );

		    

		    geoList.on('item-active', function(e) {
		    //   $('.map-and-list').css('flex','7');
		    //   $('#properties').css('flex','4');
		      //$('#properties').html(propertiesHTML(e.layer.feature.properties));
		      console.log(e.layer.feature.properties);
		      console.log(e.layer.feature.properties.Id);
		      $('#farmland_id').val((e.layer.feature.properties.Id).toString());
		    });
		    $('.leaflet-bottom').css('display','none');
		     map.addControl(geoList);

		    // var farm_list = $('.geojson-list');    
		    // $('#list').append(farm_list); 

		});
	}

	function itemListHTML() {
		return ('<div></div>');	
	}

	// function propertiesHTML(properties) {
	// 	return ('<table class="table">'+
	// 						'<tr class="success">'+
 //                '<td><h4>'+properties.Nombre+'</h4></td>'+
 //                '<td><div><a href="/fundings/new?farmland_id='+properties.Id+'">'+
 //                '<buttom class="btn btn-info">Subscribirse</buttom></a></div>'+
 //          			'</td>'+
 //              '</tr>'+
	// 						'<tr class="danger">'+
 //                '<td><b>'+properties.Producto+'</b></td>'+
 //                '<td>'+properties.Precio+' €/Kg'+
 //          			'</td>'+
 //              '</tr>'+
 //            	'<tr class="warning">'+
 //                '<td><b>Localización:</b></td>'+
 //                '<td>'+properties.Comunidad+', '+ properties.Municipio+', '+properties.Region+
 //          			'</td>'+
 //              '</tr>'+
 //              '<tr class="info">'+
 //                '<td><b>Temporada:</b></td>'+
 //                '<td>'+properties.InicioTemporada+' a '+ properties.FinalTemporada+
 //          			'</td>'+
 //              '</tr>'+
 //              '<tr class="info">'+
 //                '<td><b>Ecológico:</b></td>'+
 //                '<td>'+ properties.Ecologico +
 //          			'</td>'+
 //              '</tr>'+
	// 					'</table>'
						
	// 						);
	// }


});



