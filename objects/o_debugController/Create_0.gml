event_inherited();

ImGui.__Initialize();

init = true;
ImGui.ConfigFlagToggle(ImGuiConfigFlags.DockingEnable);	

global.debug = true;
global.debugIsGravityOn = false;
global.debugCameraAxis = false;
global.debugAutoCamera = true;
global.debugOutOfViewCulling = false;
global.debugEdit = false;

if (!global.debugEdit)
{
	Camera.Zoom = 2;
	Camera.Target = o_cameraTarget;
	
	scr_gravitationChange();
}

flat0Matrix = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
flat1Matrix = matrix_build(0, 0, 1, 0, 0, 0, 1, 1, 1);
debugMatrix = matrix_build(0, 0, 33, 0, 0, 0, 1, 1, 1);
characterMatrix = matrix_build(0, 12, 16, 0, 0, 0, 1, 1, 1);

window_set_fullscreen(true);

ui = new UI();

with(ui)
{
	mainLayer = new Layer();
	mainLayer.setGrid(10, 10, false);

	pushLayer(mainLayer);
}

isAutoScrollOn = true;

logBuffor = ds_list_create();
logColor = ds_list_create();
monitoredValue = ds_list_create();

isApplicationSurfaceEnabled = false;

choosedPlayerIndex = 0;

isRightKeyBindingOn = false;
isLeftKeyBindingOn = false;
isUpKeyBindingOn = false;
isDownKeyBindingOn = false;
isJumpKeyBindingOn = false;
isInteractionKeyBindingOn = false;

pseudo2D = false;

gameWindowWidth = 0;
gameWindowHeight = 0;


oldPitch = Camera.Pitch;
oldAngle = Camera.Angle;
cursorX = 0;
cursorY = 0;
cursorXPressed = 0;
cursorYPressed = 0;
	
editorMirror = false;
editorFlip = false;
editorFullView = true;
editorSlopeCreation = false;
	
editorObjects = ds_list_create();
ds_list_add(editorObjects, o_block, o_ramp, o_slope, o_obstacle, o_start, o_slopeTop);
editorCurrentObjectIndex = 0;
editorCurrentObject = o_block;
enum EditorDirectionType
{
	topLeft,
	topRight,
	bottomLeft,
	bottomRight
}
	
editorDirection = EditorDirectionType.bottomRight;
	
editorFileName = "";
rulesPresetFileName = "";
statsPresetFileName = "";
modificatorsPresetFileName = "";
	
editorFiles = scr_getFiles("level_");
rulesPresetsFiles = scr_getFiles("rules_");
statsPresetsFiles = scr_getFiles("stats_");
modificatorsPresetsFiles = scr_getFiles("modificators_");

layer_background_visible(layer_background_get_id(layer_get_id("SolidBlue")), false);

currentTab = 0;
previousTab = 0;

hide = false;