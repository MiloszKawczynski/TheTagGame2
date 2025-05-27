randomize();

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

global.lockOnStart = !global.debug

global.c_darkBlue = make_color_rgb(95, 102, 150);
global.c_brown = make_color_rgb(176, 112, 74);
global.c_skin = make_color_rgb(229, 193, 153);
global.c_neon = make_color_rgb(188, 224, 1);

global.c_teamColors = array_create();
array_push(global.c_teamColors,
c_red,
c_lime);

global.s_teamColors = array_create();

isTeamColorsSpriteCreated = false

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

window_set_fullscreen(true);

alarm[0] = 1;