/**
 *
 * Displaying group popups
 *
 */

MapGroupPopup = {
  map: null,
  layer: null,

  init: function(m, l) {
    this.map = m;
    this.layer = l;
    m.addControl(new OpenLayers.Control.SelectFeature(l, {id: 'selector', onSelect: MapGroupPopup.createPopup, onUnselect: MapGroupPopup.destroyPopup }));
    m.getControl('selector').activate();
    m.getControl('selector').handlers.feature.stopDown = false; // Allow click-drag on polygons to move the map
  },

  createPopup: function(feature) {
      feature.popup = new OpenLayers.Popup.FramedCloud("pop",
          feature.geometry.getBounds().getCenterLonLat(),
          null,
          //'<img src="' + feature.attributes.image_url + '" width="37" height="37">' +
          '<h3><a href="' + feature.attributes.url + '">' + feature.attributes.title + '</a></h3>' +
            '<p>' + feature.attributes.description + '</p>',
          null,
          true,
          function() { MapGroupPopup.map.getControl('selector').unselectAll(); this.destroy(); }
      );
      map.addPopup(feature.popup);
  },

  destroyPopup: function(feature) {
      feature.popup.destroy();
      feature.popup = null;
  }
}