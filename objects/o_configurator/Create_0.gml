global.gameLevelName = "";
enum staticBuffersOptionType
{
	create,
	createAndSave,
	load,
	disable
}

global.loadStaticBuffers = false;
global.createStaticBuffers = false;
global.saveStaticBuffers = false;

global.debug = false;
global.debugEdit = false;
global.debugModels = true;

Camera.Zoom = 2;
Camera.Target = o_cameraTarget;

flat0Matrix = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
flat1Matrix = matrix_build(0, 0, 1, 0, 0, 0, 1, 1, 1);
debugMatrix = matrix_build(0, 0, 33, 0, 0, 0, 1, 1, 1);
characterMatrix = matrix_build(0, 12, 16, 0, 0, 0, 1, 1, 1);

editorObjects = array_create(0);
array_push(editorObjects, 
	o_block, 
	o_ramp, 
	o_slope, 
	o_obstacle, 
	o_start, 
	o_slopeTop, 
	o_godRay, 
	o_bench, 
	o_cup,
	o_locker,
	o_npc,
	o_gravityChangeArea,
	o_cover,
	o_metroChaseTitleCard,
	o_lamp,
	o_pointLight,
	o_spotLight,
	o_ledPanel
);

input_source_mode_set(INPUT_SOURCE_MODE.FIXED);

input_source_set(INPUT_KEYBOARD, 10);
input_profile_set("keyboard_and_mouse", 10);

window_set_fullscreen(true);

alarm[0] = 1;