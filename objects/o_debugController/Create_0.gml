event_inherited();

global.debug = true;
global.debug3DCam = true;
global.debugIsGravityOn = false;

ui = new UI();

with(ui)
{
	mainLayer = new Layer();
	mainLayer.setGrid(10, 10);
	
	debugGroup = new Group(0, 0);
	debugGroup.setGrid(1, 3);
	
	cameraAngle = new Text("Angle: ", atf_font);
	cameraPitch = new Text("Pitch: ", atf_font);
	
	horizontalSpeed = new Text("hSpeed: ", atf_font);
	verticalSpeed = new Text("vSpeed: ", atf_font);
	
	debugGroup.addComponent(0, 0, cameraAngle);
	debugGroup.addComponent(0, 1, cameraPitch);
	debugGroup.addComponent(0, 3, horizontalSpeed);
	debugGroup.addComponent(0, 4, verticalSpeed);
		
	mainLayer.addComponent(1, 1, debugGroup);

	pushLayer(mainLayer);
}