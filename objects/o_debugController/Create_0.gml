event_inherited();

ImGui.__Initialize();
ImGui.ConfigFlagToggle(ImGuiConfigFlags.DockingEnable);	

isStatsOpen = false;

global.debug = true;
global.debugIsGravityOn = true;

if (global.debugIsGravityOn)
{		
	Camera.Pitch = 130;
	Camera.Angle = 90;
}
else
{
	Camera.Pitch = 50;
	Camera.Angle = 80;
}
Camera.Zoom = 2;
Camera.Target = o_char;

flatMatrix = matrix_build(0, 0, 1, 0, 0, 0, 1, 1, 1);
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
monitoredValue = ds_list_create();