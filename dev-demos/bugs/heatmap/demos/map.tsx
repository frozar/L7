// @ts-ignore
import { Scene,RasterLayer, HeatmapLayer } from '@antv/l7';
// @ts-ignore
import { Map,GaodeMap } from '@antv/l7-maps';
import React, { useEffect } from 'react';

export default () => {
  useEffect(() => {

const scene = new Scene({
    id: 'map',
    map: new GaodeMap({
      style: 'light',
      pitch: 0,
      center: [ 114.07737552216226, 22.542656745583486 ],
      rotation: 0,
      zoom: 12
    })
  });
  scene.on('loaded', () => {
    const url1 =
      'https://tiles{1-3}.geovisearth.com/base/v1/vec/{z}/{x}/{y}?format=png&tmsIds=w&token=b2a0cfc132cd60b61391b9dd63c15711eadb9b38a9943e3f98160d5710aef788';

    const layer1 = new RasterLayer({
      zIndex: 0,
    }).source(url1, {
      parser: {
        type: 'rasterTile',
        tileSize: 256,
        zoomOffset: 0,
      },
    });
    scene.addLayer(layer1)
    fetch(
      'https://gw.alipayobjects.com/os/basement_prod/513add53-dcb2-4295-8860-9e7aa5236699.json'
    )
      .then(res => res.json())
      .then(data => {
        const layer = new HeatmapLayer({})
            .source(data)
            .shape('heatmap3D')
            .size('h12', [0, 1.0]) // weight映射通道
            .style({
              intensity: 2,
              radius: 20,
              opacity: 1.0,
              rampColors: {
                colors: [
                  '#FF4818',
                  '#F7B74A',
                  '#FFF598',
                  '#F27DEB',
                  '#8C1EB2',
                  '#421EB2',
                ].reverse(),
                positions: [0, 0.2, 0.4, 0.6, 0.8, 1.0],
              },
            });
        scene.addLayer(layer);
        scene.render()
      });
  });
  

  
  }, []);
  return (
    <div
      id="map"
      style={{
        height: '500px',
        position: 'relative',
      }}
    />
  );
};
