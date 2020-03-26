import { FeatureCollection } from '@turf/helpers';
import { DrawEvent, DrawModes } from '../util/constant';
import { renderFeature } from '../util/renderFeature';
import BaseRender from './base_render';
export default class DrawResultLayer extends BaseRender {
  public update(feature: FeatureCollection) {
    this.removeLayers();
    const style = this.draw.getStyle('normal');
    this.drawLayers = renderFeature(feature, style);
    this.addLayers();
  }
  public enableDrag() {
    const layer = this.drawLayers[0];
    layer.on('click', this.onClick);
  }
  public disableDrag() {
    const layer = this.drawLayers[0];
    layer.off('click', this.onClick);
  }
  public addFilter() {
    this.drawLayers.forEach((layer) =>
      layer.filter('active', (active) => {
        return !active;
      }),
    );
  }
  private onClick = (e: any) => {
    this.draw.setCurrentFeature(e.feature);
    this.draw.emit(DrawEvent.MODE_CHANGE, DrawModes.SIMPLE_SELECT);
  };
}
