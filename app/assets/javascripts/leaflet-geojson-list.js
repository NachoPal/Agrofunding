$(document).ready(function(){
(function() {

L.Control.GeoJSONList = L.Control.extend({
	
	includes: L.Mixin.Events,

	options: {
		collapsed: false,				//collapse panel list
		position: 'bottomleft',			//position of panel list
		listItemBuild: null,			//function list item builder
		activeListFromLayer: true,		//enable activation of list item from layer
		activeEventList: 'click',		//event on item list that trigger the fitBounds
		activeEventLayer: 'mouseover',	//event on item list that trigger the fitBounds
		activeClass: 'active',			
		
		activeStyle: {					
			 weight: 0.9,
			fillOpacity: 0.9
		},
		style: {
			 weight: 0.4,
			fillOpacity:0.3
		}
	},

	initialize: function(layer, options) {
		var opt = L.Util.setOptions(this, options || {});

		if(this.options.listItemBuild)
			this._itemBuild = this.options.listItemBuild;

		this._layer = layer;
	},

	onAdd: function (map) {

		this._map = map;
		
		var container = L.DomUtil.create('div', 'geojson-list');

		this._container = container;

		this._list = L.DomUtil.create('div', 'geojson-list-group', container);

		this._initToggle();
	
		this._updateList();

		L.DomEvent
			.on(container, 'mouseover', function (e) {
				map.scrollWheelZoom.disable();
			})
			.on(container, 'mouseout', function (e) {
				map.scrollWheelZoom.enable();
			});			

		map.whenReady(function(e) {
			container.style.height = (map.getSize().y)+'px';
		});

		return container;
	},
	
	onRemove: function(map) {
		map.off('moveend', this._updateList, this);	
	},

	reload: function(layer) {

		this._layer = layer;

		this._updateList();

		return this;
	},

	_getPath: function(obj, prop) {
		var parts = prop.split('.'),
			last = parts.pop(),
			len = parts.length,
			cur = parts[0],
			i = 1;

		if(len > 0)
			while((obj = obj[cur]) && i < len)
				cur = parts[i++];

		if(obj)
			return obj[last];
	},

	_itemBuild: function(layer) {

		var item = L.DomUtil.create('a',''),
			label = this._getPath(layer.feature, this.options.listLabel);

		item.innerHTML = '<span>'+(label || '&nbsp;')+'</span>';

		return item;
	},

	_createItem: function(layer) {

		var that = this,
			item = this._itemBuild.call(this, layer);

		L.DomUtil.addClass(item,'geojson-list-item');

		layer.itemList = item;

		L.DomEvent
			//.disableClickPropagation(item)
			.on(item, this.options.activeEventList, this)
			.on(item, this.options.activeEventList, function(e) {
				
				that._moveTo( layer );

				that.fire('item-active', {layer: layer });

			}, this)
			.on(item, 'mouseover', function(e) {
				
				L.DomUtil.addClass(e.target, this.options.activeClass);

				if(layer.setStyle)
					layer.setStyle( that.options.activeStyle );

			}, this)
			.on(item, 'mouseout', function(e) {

				L.DomUtil.removeClass(e.target, this.options.activeClass);

				if(layer.setStyle)
					layer.setStyle( that.options.style );

			}, this);

		return item;
	},

	_updateList: function() {
	
		var that = this,
			layers = [],
			sortProp = this.options.listSortBy;

		this._list.innerHTML = '';
		this._layer.eachLayer(function(layer) {

			layers.push( layer );

			if(layer.setStyle)
				layer.setStyle( that.options.style );

			if(that.options.activeListFromLayer) {
				layer
				.on(that.options.activeEventList, L.DomEvent.stop)
				.on(that.options.activeEventList, function(e) {

					that.fire('item-active', {layer: layer });
				})
				.on('mouseover', function(e) {
	
					if(layer.setStyle)
						layer.setStyle( that.options.activeStyle );

					L.DomUtil.addClass(layer.itemList, that.options.activeClass);
				})
				.on('mouseout', function(e) {

					if(layer.setStyle)
						layer.setStyle( that.options.style );

					L.DomUtil.removeClass(layer.itemList, that.options.activeClass);
				});
			}
		});

		for (var i=0; i<layers.length; i++)
			this._list.appendChild( this._createItem( layers[i] ) );
	},

	_initToggle: function () {

		var container = this._container;

		//Makes this work on IE10 Touch devices by stopping it from firing a mouseout event when the touch is released
		container.setAttribute('aria-haspopup', true);

		if (!L.Browser.touch) {
			// L.DomEvent
			// 	.disableClickPropagation(container);
		} else {
			L.DomEvent.on(container, 'click');//, L.DomEvent.stopPropagation);//Aqui
		}

		if (this.options.collapsed)
		{
			this._collapse();

			if (!L.Browser.android) {
				L.DomEvent
					.on(container, 'mouseover', this._expand, this)
					.on(container, 'mouseout', this._collapse, this);
			}
			var link = this._button = L.DomUtil.create('a', 'geojson-list-toggle', container);
			link.href = '#';
			link.title = 'List GeoJSON';

			if (L.Browser.touch) {
				L.DomEvent
					.on(link, 'click', L.DomEvent.stop)
					.on(link, 'click', this._expand, this);
			}
			else {
				L.DomEvent.on(link, 'focus', this._expand, this);
			}

			this._map.on('click', this._collapse, this);

		}
	},

	_expand: function () {
		this._container.className = this._container.className.replace(' geojson-list-collapsed', '');
	},

	_collapse: function () {
		L.DomUtil.addClass(this._container, 'geojson-list-collapsed');
	},

    _moveTo: function(layer) {
    	if(layer.getBounds)
			this._map.fitBounds( layer.getBounds().pad(1) );
		else if(layer.getLatLng)
			this._map.setView( layer.getLatLng() );
    }
});

L.control.geoJsonList = function (layer, options) {
    return new L.Control.GeoJSONList(layer, options);
};


}).call(this);
});