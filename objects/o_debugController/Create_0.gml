event_inherited();

global.debug = true;
global.debugIsGravityOn = false;

ui = new UI();

with(ui)
{
	mainLayer = new Layer();
	mainLayer.setGrid(10, 10);

	pushLayer(mainLayer);
}