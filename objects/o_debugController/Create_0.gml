event_inherited();

ImGui.__Initialize();
ImGui.ConfigFlagToggle(ImGuiConfigFlags.DockingEnable);	

isStatsOpen = false;

global.debug = true;
global.debugIsGravityOn = false;
global.debugCameraAxis = false;
global.debugAutoCamera = true;

Camera.Zoom = 2;
Camera.Target = o_cameraTarget;

scr_gravitationChange();

flat0Matrix = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
flat1Matrix = matrix_build(0, 0, 1, 0, 0, 0, 1, 1, 1);
debugMatrix = matrix_build(0, 0, 33, 0, 0, 0, 1, 1, 1);

//window_set_fullscreen(true);

ui = new UI();

with(ui)
{
	mainLayer = new Layer();
	mainLayer.setGrid(10, 10);

	pushLayer(mainLayer);
}

isAutoScrollOn = true;

logBuffor = ds_list_create();
logColor = ds_list_create();
monitoredValue = ds_list_create();

isApplicationSurfaceEnabled = false;

init = true;