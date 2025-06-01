#macro Release:DEBUG false
#macro Debug:DEBUG true 

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

global.lockOnStart = true;

if (DEBUG)
{
    global.lockOnStart = false;
}

global.c_discordBlack = make_color_rgb(17, 17, 17);
global.c_darkBlue = make_color_rgb(95, 102, 150);
global.c_brown = make_color_rgb(176, 112, 74);
global.c_skin = make_color_rgb(229, 193, 153);
global.c_neon = make_color_rgb(188, 224, 1);

//OG Colors
//global.c_runnersUp = make_color_rgb(93, 93, 108);
//global.c_gravitieri = make_color_rgb(201, 34, 34);
//global.c_flyingApocalypse = make_color_rgb(79, 136, 64);
//global.c_parkourPunishment = make_color_rgb(192, 157, 56);
//global.c_unitySquad = make_color_rgb(75, 126, 142);
//global.c_chaosCrew = make_color_rgb(104, 61, 148);
//global.c_theRunners = make_color_rgb(160, 46, 33);

global.c_runnersUp = make_color_rgb(255, 255, 255);
global.c_gravitieri = make_color_rgb(255, 0, 0);
global.c_flyingApocalypse = make_color_rgb(51, 255, 0);
global.c_parkourPunishment = make_color_rgb(240, 255, 0);
global.c_unitySquad = make_color_rgb(0, 194, 255);
global.c_chaosCrew = make_color_rgb(97, 0, 255);
global.c_theRunners = make_color_rgb(255, 167, 0);

global.c_teamColors = array_create();
array_push(global.c_teamColors,
global.c_runnersUp,
global.c_gravitieri,
global.c_flyingApocalypse,
global.c_parkourPunishment,
global.c_unitySquad,
global.c_chaosCrew,
global.c_theRunners
);

global.s_teamColors = array_create();

isTeamColorsSpriteCreated = false

scr_createCharacters();

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