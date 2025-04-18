ImGui.__Initialize();

fontDefault = ImGui.AddFontDefault();
fontRoboto = ImGui.AddFontFromFile("fonts/Roboto-Regular.ttf", 18);

init = true;
ImGui.ConfigFlagToggle(ImGuiConfigFlags.DockingEnable);	

global.debug = true;
global.debugCameraAxis = false;
global.debugAutoCamera = true;
global.debugEdit = false;

isAutoScrollOn = true;

logBuffor = ds_list_create();
logColor = ds_list_create();
monitoredValue = ds_list_create();

choosedPlayerIndex = 0;

isRightKeyBindingOn = false;
isLeftKeyBindingOn = false;
isUpKeyBindingOn = false;
isDownKeyBindingOn = false;
isJumpKeyBindingOn = false;
isInteractionKeyBindingOn = false;
isSkillKeyBindingOn = false;

pseudo2D = false;

gameWindowWidth = 0;
gameWindowHeight = 0;


oldPitch = Camera.Pitch;
oldAngle = Camera.Angle;
cursorX = 0;
cursorY = 0;
cursorXPressed = 0;
cursorYPressed = 0;
	
editorObjects = o_configurator.editorObjects;
editorMirror = false;
editorFlip = false;
editorFullView = true;
editorSlopeCreation = false;
	
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
dialogPresetFileName = "";
dialogFileName = "";
	
editorFiles = scr_getFiles("level_");
rulesPresetsFiles = scr_getFiles("rules_");
statsPresetsFiles = scr_getFiles("stats_");
modificatorsPresetsFiles = scr_getFiles("modificators_");
dialogPresetFiles = scr_getFiles("dialogbox_");
dialogFiles = scr_getFiles("dialog_");

layer_background_visible(layer_background_get_id(layer_get_id("SolidBlue")), false);

currentTab = 0;
previousTab = 0;

hide = false;

gameLanguage = "EN";

dialog = undefined;
dialogPosition = [0, 350];
dialogSize = [800, 100];
dialogTextPosition = [20, 20];
dialogPortraitPosition = [100, 200];
dialogPortraitScale = 0.15;
dialogPortraitSpacing = 150;
dialogOverImGui = false;
showDialogDebugDrawings = false;

dialogDictionaryEntry = function(_key, _value) constructor
{
	key = _key;
	value = _value;
}

panX = 0
panY = 0

targetPanX = 0
targetPanY = 0

sizePercent = 100;

dialogIsConnectionLineGrabbed = false;

allDialogNodes = ds_list_create();

isAnyNodeGrabbed = false;

c_selectedBlueBorder = make_color_rgb(255 * 0.2, 255 * 0.6, 255);
c_selectedBlueBackground = make_color_rgb(255 * 0.1, 255 * 0.2, 255 * 0.4);
c_errorRedBackground = make_color_rgb(255 * 0.3, 255 * 0.1, 255 * 0.1);

selectedNode = undefined;
startNodeIndex = -1;
showCursor = true;

allSprites = ds_list_create();
list_all_sprites(allSprites);

function dialogNode(_x, _y) constructor
{
	if (other.selectedNode == undefined)
	{
		other.selectedNode = self;
	}
	
	if (other.startNodeIndex == -1)
	{
		other.startNodeIndex = ds_list_size(other.allDialogNodes);
	}
	
	xPos = _x;
	yPos = _y;
	
	static language = function(_key) constructor
	{
		key = _key;
		content = ""
	}
	
	languages = array_create(0);
	
	array_push(languages, new language("EN"), new language("PL"));
	
	focusedLanuguage = "EN";
	
	in = undefined;
	out = undefined;
	
	xIn = _x;
	yIn = _y;
	
	xOut = _x;
	yOut = _y;
	
	inIndex = -1;
	outIndex = -1;
	
	isGrabbed = false;
	
	cursorPos = -1;
	
	talkers = array_create(0);
	
	static cutRelations = function()
	{
		if (in != undefined)
		{
			in.out = undefined;
		}
		
		if (out != undefined)
		{
			out.in = undefined;
		}
		
		in = undefined;
		out = undefined;
	}
	
	static getMyIndex = function()
	{
		for (var i = 0; i < ds_list_size(other.allDialogNodes); i++)
		{
			if (ds_list_find_value(other.allDialogNodes, i) == self)
			{
				return i;
			}
		}
		
		return -1;
	}
	
	static talker = function(_name) constructor
	{
		name = _name
		isActive = false;
		sprite = undefined
		image = 0;
		isMirrored = false;
	}
	
	static getAllTalkers = function()
	{
		var allTalkers = ds_list_create();
	
		var nextNode = self;
		
		while(nextNode != undefined)
		{
			ds_list_add(allTalkers, nextNode.talkers);
			nextNode = nextNode.out;
		}
		
		return allTalkers;
	}
	
	static getAllText = function(key)
	{
		var dialogToSay = "";
		
		var nextNode = self;
		
		while(nextNode != undefined)
		{
			dialogToSay += array_find_value_by_key(nextNode.languages, key).content;
			nextNode = nextNode.out;
		
			if (nextNode != undefined)
			{
				dialogToSay += " ¶";
			}
		}
		
		return dialogToSay;
	}
}

dialog = new dialogMain(780, 3, vk_enter, c_black, 0.25, 2, s_dialogBubble, f_test);

editableObjects = [];
objectName = "";
selectedObject = undefined;

input_source_mode_set(INPUT_SOURCE_MODE.FIXED);

input_source_set(INPUT_KEYBOARD, 10);
input_profile_set("keyboard_and_mouse", 10);

keyboardShare = [10];
firstFreePlayer = 0;
isBindingFinilize = false;

fpsLogger = false;