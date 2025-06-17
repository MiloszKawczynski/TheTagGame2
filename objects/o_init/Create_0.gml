enum DebugDestination
{
    Arena,
    PlotMap,
    Lobby
}

#macro Release:DEBUG false
#macro Debug:DEBUG true 

#macro Release:DESTINATION DebugDestination.Lobby

#macro Arena:DESTINATION DebugDestination.Arena
#macro PlotMap:DESTINATION DebugDestination.PlotMap
#macro Lobby:DESTINATION DebugDestination.Lobby

randomize();

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

global.c_adam = make_color_rgb(187, 0, 119);
global.c_clea = make_color_rgb(255, 0, 0);
global.c_david = make_color_rgb(40, 42, 53);
global.c_feather = make_color_rgb(204, 0, 255);
global.c_karen = make_color_rgb(255, 129, 127);
global.c_miriam = make_color_rgb(130, 0, 0);
global.c_riley = make_color_rgb(255, 255, 0);
global.c_snowWhite = make_color_rgb(255, 255, 255);
global.c_trickster = make_color_rgb(97, 0, 255);

global.c_teamColors = array_create();
array_push(global.c_teamColors,
//global.c_runnersUp,
//global.c_gravitieri,
//global.c_flyingApocalypse,
//global.c_parkourPunishment,
//global.c_unitySquad,
//global.c_chaosCrew,
//global.c_theRunners
global.c_adam,
global.c_clea,
global.c_david,
global.c_feather,
global.c_karen,
global.c_miriam,
global.c_riley,
global.c_snowWhite,
global.c_trickster
);

global.s_teamColors = array_create();

global.leftCharacter = 0;
global.rightCharacter = 0;
global.gameLevelName = "empty";

isTeamColorsSpriteCreated = false

scr_createCharacters();
scr_createLevels();

window_set_fullscreen(true);