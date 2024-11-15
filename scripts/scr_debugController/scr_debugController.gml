function scr_debugPreload()
{
	scr_levelLoad("santa");
	scr_rulesPresetLoad("default");
	scr_statsPresetLoad("default");
	
	scr_addPlayer(1);
		
	o_gameManager.reset();
}

function scr_addPlayer(idNumber)
{
	instance_create_layer(o_char.x, o_char.y, "players", o_char, 
	{
		player : idNumber
	});
}

function scr_docking()
{
	var dockspaceID 

	dockspaceID = ImGui.GetID("MyDockspace");

	if (init)
	{
	    ImGui.DockBuilderRemoveNode(dockspaceID);
	    ImGui.DockBuilderAddNode(dockspaceID);

	    ImGui.DockBuilderSetNodePos(dockspaceID, 0, 0);
	    ImGui.DockBuilderSetNodeSize(dockspaceID, 1920 * 0.22, 1080);

	    var docs = ImGui.DockBuilderSplitNode(dockspaceID, ImGuiDir.Left, 0.22);

	    ImGui.DockBuilderDockWindow("Debug", docs[1]);
	    ImGui.DockBuilderDockWindow("Edit", docs[1]);
	    ImGui.DockBuilderDockWindow("Game", docs[1]);

	    ImGui.DockBuilderFinish(dockspaceID);

		ImGui.SetWindowFocus("Debug");

		scr_debugPreload();

	    init = false;
	}
}

function scr_managePlayersNumber()
{
	if (ImGui.Button("Add Player"))
	{
		instance_create_layer(o_char.x, o_char.y, "players", o_char, 
		{
			player : 1
		});
		
		o_gameManager.reset();
	}
	ImGui.SameLine();
	if (ImGui.Button("Delete Player"))
	{
		if (instance_number(o_char) > 0)
		{
			instance_destroy(instance_find(o_char, choosedPlayerIndex));
		}
		
		o_gameManager.reset();
	}
}

function scr_gameOptions()
{
	ImGui.Text("Game Options");
	
	if(ImGui.Button("Top-Down / Platformer"))
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		
		scr_gravitationChange();
	}
	
	if(ImGui.Button("Reset"))
	{
		room_restart();
	}
	
	if(ImGui.Button("Room Change"))
	{
		if (room == r_init)
		{
			room_goto(r_levelEditor);
		}
		else
		{
			room_goto(r_init);
		}
	}

	ImGui.Separator();
}

function scr_cameraControll()
{
	ImGui.Text("Camera");
	
	isApplicationSurfaceEnabled = ImGui.Checkbox("Application surface", isApplicationSurfaceEnabled);

	ImGui.BeginGroup();
	ImGui.Dummy(19, 0);
	ImGui.SameLine();
	if (ImGui.ArrowButton("Pitch +", 2)) {Camera.Pitch += 10};
	
	if (ImGui.ArrowButton("Angle +", 0)) {Camera.Angle += 10};
	ImGui.SameLine();
	if (ImGui.Button("o", 19, 19)) 
	{
		pseudo2D = !pseudo2D;
		
		if (pseudo2D)
		{
			oldPitch = Camera.Pitch;
			oldAngle = Camera.Angle;
			
			Camera.Pitch = 90.1
		}
		else
		{
			Camera.Pitch = oldPitch;
			Camera.Angle = oldAngle;
		}
	}
	ImGui.SameLine();
	if (ImGui.ArrowButton("Angle -", 1)) {Camera.Angle -= 10};
	
	ImGui.Dummy(19, 0);
	ImGui.SameLine();
	if (ImGui.ArrowButton("Pitch -", 3)) {Camera.Pitch -= 10};
	ImGui.EndGroup();
	
	ImGui.SameLine();
	ImGui.BeginGroup();
	
	Camera.Zoom = ImGui.VSliderFloat("Zoom", 19, 60, Camera.Zoom, 0.5, 20);
	if (ImGui.IsItemEdited())
	{
		global.debugAutoCamera = false;
	}
	
	ImGui.EndGroup();
	
	o_cameraTarget.cameraMarginFactor = ImGui.InputFloat("Margin Factor", o_cameraTarget.cameraMarginFactor, 0.5);
	o_cameraTarget.cameraMarginFactor = clamp(o_cameraTarget.cameraMarginFactor, 1, 3);
	
	global.debugCameraAxis = ImGui.Checkbox("Camera Axis", global.debugCameraAxis);
	global.debugAutoCamera = ImGui.Checkbox("Auto Camera", global.debugAutoCamera);
	global.debugOutOfViewCulling = ImGui.Checkbox("Out of View Culling", global.debugOutOfViewCulling);
	
	ImGui.Text(string("Angle: {0}", Camera.Angle));
	ImGui.Text(string("Pitch: {0}", Camera.Pitch));
	ImGui.Text(string("Zoom: {0}", Camera.Zoom));
	
	ImGui.Separator();
}

function scr_clearLog()
{
	ds_list_clear(logBuffor);
	ds_list_clear(logColor);
	ds_list_clear(monitoredValue);
}

function scr_logsOptions()
{
	if (ImGui.Button("Clear"))
	{
		scr_clearLog();
	}
	ImGui.SameLine();
	if (ImGui.Button("Log!"))
	{
		log("Log!", c_yellow);
	}
	ImGui.SameLine();
	isAutoScrollOn = ImGui.Checkbox("AutoScroll", isAutoScrollOn);
	
	scr_logs();
	
	ImGui.Separator();
}

function scr_logs()
{
	ImGui.BeginChild("Log",, 200, true);
	for(var i = 0; i < ds_list_size(logBuffor); i++)
	{
		ImGui.TextColored(ds_list_find_value(logBuffor, i), ds_list_find_value(logColor, i));
		if (ImGui.IsItemHovered()) 
		{
			ImGui.BeginTooltip();
			ImGui.Text(ds_list_find_value(monitoredValue, i));
			ImGui.EndTooltip();
		}
	}
	
	if (isAutoScrollOn)
	{
		ImGui.SetScrollHereY(0.99);
	}
	ImGui.EndChild();
	
	ImGui.Text(string("Logs: {0}", ds_list_size(logBuffor)));
}

function scr_playersStats()
{
    if (ImGui.CollapsingHeader("Stats"))
    {
        o_gameManager.maximumDefaultSpeed = scr_statitstic("Default Speed",  o_gameManager.maximumDefaultSpeed);
        o_gameManager.acceleration = scr_statitstic("Acceleration",  o_gameManager.acceleration);
        o_gameManager.deceleration = scr_statitstic("Deceleration",  o_gameManager.deceleration);
        o_gameManager.maximumSpeedDecelerationFactor = scr_statitstic("Maximum Speed Deceleration Factor",  o_gameManager.maximumSpeedDecelerationFactor);
        o_gameManager.jumpForce = scr_statitstic("Jump Height",  o_gameManager.jumpForce);
        o_gameManager.momentumJumpForce = scr_statitstic("Speed Additional Jump Height",  o_gameManager.momentumJumpForce);
        o_gameManager.gravitation = scr_statitstic("Gravity",  o_gameManager.gravitation);
        o_gameManager.slopeAcceleration = scr_statitstic("Slope Acceleration",  o_gameManager.slopeAcceleration);
        o_gameManager.slopeDeceleration = scr_statitstic("Slope Deceleration",  o_gameManager.slopeDeceleration);
        o_gameManager.rampAcceleration = scr_statitstic("Ramp Acceleration",  o_gameManager.rampAcceleration);
        o_gameManager.rampDeceleration = scr_statitstic("Ramp Deceleration",  o_gameManager.rampDeceleration);
        o_gameManager.maximumSlopeSpeed = scr_statitstic("Slope Max Speed",  o_gameManager.maximumSlopeSpeed);
        o_gameManager.maximumRampSpeed = scr_statitstic("Ramp Max Speed",  o_gameManager.maximumRampSpeed);
        o_gameManager.slopeSpeedTransitionFactor = scr_statitstic("Slope Speed Transition Factor",  o_gameManager.slopeSpeedTransitionFactor);
        o_gameManager.maximumCoyoteTime = scr_statitstic("Coyote Time",  o_gameManager.maximumCoyoteTime);
        o_gameManager.obstacleRange = scr_statitstic("Obstacle Range",  o_gameManager.obstacleRange);
        o_gameManager.minimumObstacleJumpForce = scr_statitstic("Minimum Obstacle Jump",  o_gameManager.minimumObstacleJumpForce);
        o_gameManager.maximumObstacleJumpForce = scr_statitstic("Maximum Obstacle Jump",  o_gameManager.maximumObstacleJumpForce);
        o_gameManager.maximumJumpBuffor = scr_statitstic("Maximum Jump Buffor",  o_gameManager.maximumJumpBuffor);

        with(o_char)
		{
			setupStats();
		}
		
		returnList = scr_fileSearchList("stats", statsPresetFileName, statsPresetsFiles);
		
		statsPresetFileName = ds_list_find_value(returnList, 0);
		statsPresetsFiles = ds_list_find_value(returnList, 1);
		
		ds_list_destroy(returnList);
    }

    ImGui.Separator();
}

function scr_playerModificators()
{
    var choosedPlayer = instance_find(o_char, choosedPlayerIndex);

    if (ImGui.CollapsingHeader("Modificators"))
    {
		ImGui.Text(string("Player {0} Modificators", choosedPlayerIndex));
		
		choosedPlayer.maximumDefaultSpeedModificator = scr_statitstic("Default Speed Modificator",  choosedPlayer.maximumDefaultSpeedModificator);
		choosedPlayer.accelerationModificator = scr_statitstic("Acceleration Modificator",  choosedPlayer.accelerationModificator);
		choosedPlayer.decelerationModificator = scr_statitstic("Deceleration Modificator",  choosedPlayer.decelerationModificator);
		choosedPlayer.maximumSpeedDecelerationFactorModificator = scr_statitstic("Maximum Speed Deceleration Factor Modificator",  choosedPlayer.maximumSpeedDecelerationFactorModificator);
		choosedPlayer.jumpForceModificator = scr_statitstic("Jump Height Modificator",  choosedPlayer.jumpForceModificator);
		choosedPlayer.momentumJumpForceModificator = scr_statitstic("Speed Additional Jump Height Modificator",  choosedPlayer.momentumJumpForceModificator);
		choosedPlayer.gravitationModificator = scr_statitstic("Gravity Modificator",  choosedPlayer.gravitationModificator);
		choosedPlayer.slopeAccelerationModificator = scr_statitstic("Slope Acceleration Modificator",  choosedPlayer.slopeAccelerationModificator);
		choosedPlayer.slopeDecelerationModificator = scr_statitstic("Slope Deceleration Modificator",  choosedPlayer.slopeDecelerationModificator);
		choosedPlayer.rampAccelerationModificator = scr_statitstic("Ramp Acceleration Modificator",  choosedPlayer.rampAccelerationModificator);
		choosedPlayer.rampDecelerationModificator = scr_statitstic("Ramp Deceleration Modificator",  choosedPlayer.rampDecelerationModificator);
		choosedPlayer.maximumSlopeSpeedModificator = scr_statitstic("Slope Max Speed Modificator",  choosedPlayer.maximumSlopeSpeedModificator);
		choosedPlayer.maximumRampSpeedModificator = scr_statitstic("Ramp Max Speed Modificator",  choosedPlayer.maximumRampSpeedModificator);
		choosedPlayer.slopeSpeedTransitionFactorModificator = scr_statitstic("Slope Speed Transition Factor Modificator",  choosedPlayer.slopeSpeedTransitionFactorModificator);
		choosedPlayer.maximumCoyoteTimeModificator = scr_statitstic("Coyote Time Modificator",  choosedPlayer.maximumCoyoteTimeModificator);
		choosedPlayer.obstacleRangeModificator = scr_statitstic("Obstacle Range Modificator",  choosedPlayer.obstacleRangeModificator);
		choosedPlayer.minimumObstacleJumpForceModificator = scr_statitstic("Minimum Obstacle Jump Modificator",  choosedPlayer.minimumObstacleJumpForceModificator);
		choosedPlayer.maximumObstacleJumpForceModificator = scr_statitstic("Maximum Obstacle Jump Modificator",  choosedPlayer.maximumObstacleJumpForceModificator);
		choosedPlayer.maximumJumpBufforModificator = scr_statitstic("Maximum Jump Buffor Modificator",  choosedPlayer.maximumJumpBufforModificator);
		choosedPlayer.color = ImGui.ColorEdit3("Color", choosedPlayer.color);
		
		with(choosedPlayer)
		{
			setupStats();
		}
		
		returnList = scr_fileSearchList("modificators", modificatorsPresetFileName, modificatorsPresetsFiles);
		
		modificatorsPresetFileName = ds_list_find_value(returnList, 0);
		modificatorsPresetsFiles = ds_list_find_value(returnList, 1);
		
		ds_list_destroy(returnList);
    }

    ImGui.Separator();

    if (ImGui.CollapsingHeader("Keybinding"))
    {
        ImGui.Text(string("Player {0} Keybinding", choosedPlayerIndex));
        
        scr_keyPresets(choosedPlayer);
        
        choosedPlayer.rightKey = scr_keyBinding(choosedPlayer.rightKey, "Right Key", isRightKeyBindingOn, "isRightKeyBindingOn");
        choosedPlayer.leftKey = scr_keyBinding(choosedPlayer.leftKey, "Left Key", isLeftKeyBindingOn, "isLeftKeyBindingOn");
        choosedPlayer.upKey = scr_keyBinding(choosedPlayer.upKey, "Up Key", isUpKeyBindingOn, "isUpKeyBindingOn");
        choosedPlayer.downKey = scr_keyBinding(choosedPlayer.downKey, "Down Key", isDownKeyBindingOn, "isDownKeyBindingOn");
        choosedPlayer.jumpKey = scr_keyBinding(choosedPlayer.jumpKey, "Jump Key", isJumpKeyBindingOn, "isJumpKeyBindingOn");
        choosedPlayer.interactionKey = scr_keyBinding(choosedPlayer.interactionKey, "Interaction Key", isInteractionKeyBindingOn, "isInteractionKeyBindingOn");
    }

    ImGui.Separator();
}

function scr_playerData()
{
	ImGui.Text("Player Data");
	
	scr_managePlayersNumber();
	
	choosedPlayerIndex = ImGui.InputInt("Choosed Players", choosedPlayerIndex, 1);
	choosedPlayerIndex = clamp(choosedPlayerIndex, 0, instance_number(o_char) - 1);	
	
	scr_playersStats();
	scr_playerModificators();
	
	for(var i = 0; i < instance_number(o_char); i++)
	{
		var choosedPlayer = instance_find(o_char, i);
		
		ImGui.PushStyleColor(ImGuiCol.Text, c_aqua, 1);
		if (ImGui.Selectable(string("Player {0}", i), i == choosedPlayerIndex))
		{
			choosedPlayerIndex = i;
		}
		ImGui.PopStyleColor();
		
		ImGui.Separator();
		
		if (i == choosedPlayerIndex)
		{
			ImGui.PushStyleColor(ImGuiCol.Text, c_red, 1);
		}
		
		ImGui.Text(string("isChasing: {0}", choosedPlayer.isChasing));
		//ImGui.Text(string("x: {0}", choosedPlayer.x));
		//ImGui.Text(string("y: {0}", choosedPlayer.y));
		//ImGui.Text(string("Speed: {0}", choosedPlayer.speed));
		//ImGui.Text(string("hSpeed: {0}", choosedPlayer.horizontalSpeed));
		//ImGui.Text(string("vSpeed: {0}", choosedPlayer.verticalSpeed));
		//ImGui.Text(string("isGrounded: {0}", choosedPlayer.isGrounded));
		//ImGui.Text(string("maxSpeed: {0}", choosedPlayer.maximumSpeed));
		//ImGui.Text(string("coyoteTime: {0}", choosedPlayer.coyoteTime));
		//ImGui.Text(string("jumpBuffor: {0}", choosedPlayer.jumpBuffor));
		
		if (i == choosedPlayerIndex)
		{
			ImGui.PopStyleColor();
		}
		
		ImGui.Separator();
	}
	
	ImGui.Separator();
}

function scr_statitstic(name, value)
{
	var width = 400;
	var label_width = 150;
	var input_width = 50;
	var spacing = 10;
	
	ImGui.Text(name + ":"); ImGui.SameLine();
	ImGui.SetCursorPosX(width - input_width - spacing);
	ImGui.SetNextItemWidth(input_width);
	return ImGui.InputFloat("##" + string_replace_all(name, " ", ""), value);
}

function scr_gravitationChange()
{
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
}

function scr_keyBinding(key, keyName, isKeyBindingOn, varName)
{	
	if (isKeyBindingOn)
	{
		keyName = "---";
	}
	
	var label_width = 150;
	
	if (ImGui.Button(keyName, label_width))
	{	
		variable_instance_set(self, varName, true);
	}
	ImGui.SameLine();
	ImGui.Dummy(100, 0);
	ImGui.SameLine();
	ImGui.Text(getKeyName(key));

	if (isKeyBindingOn and keyboard_check_pressed(vk_anykey))
	{
		variable_instance_set(self, varName, false);
		return keyboard_lastkey;
	}
	
	return key;
}

function scr_keyPresets(choosedPlayer)
{
	if (ImGui.Button("WSAD"))
	{
		choosedPlayer.rightKey = ord("D");
		choosedPlayer.leftKey = ord("A");
		choosedPlayer.upKey = ord("W");
		choosedPlayer.downKey = ord("S");
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("^v<>"))
	{
		choosedPlayer.rightKey = vk_right;
		choosedPlayer.leftKey = vk_left;
		choosedPlayer.upKey = vk_up;
		choosedPlayer.downKey = vk_down;
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("HUJK"))
	{
		choosedPlayer.rightKey = ord("K");
		choosedPlayer.leftKey = ord("H");
		choosedPlayer.upKey = ord("U");
		choosedPlayer.downKey = ord("J");
	}
}

function scr_createSlope(_x, _y, _xSpawn, _ySpawn, mirror = false, flip = false, counter = 0)
{
	var instance = noone;
	
	var trimX = _x - cursorXPressed;
	var trimY = _y - cursorYPressed;
						
	var trimW = abs((_x - cursorXPressed) - (_x - cursorX));
	var trimH = abs((_y - cursorYPressed) - (_y - cursorY));
						
	var rotate = false;
						
	if (editorDirection = EditorDirectionType.topRight or editorDirection = EditorDirectionType.bottomLeft)
	{				
		rotate = true;
	}
	
	var rampMirror = 1;
	
	if (mirror)
	{
		rampMirror = -1;
	}
						
	if (rotate)
	{
		if (trimX == trimH - trimY)
		{			
			if (editorCurrentObject == o_ramp)
			{
				instance = instance_create_layer(_xSpawn + (counter * 16 * rampMirror), _ySpawn, "level", editorCurrentObject);
			}
			else
			{			
				instance = instance_create_layer(_xSpawn, _ySpawn, "level", editorCurrentObject);
			}
								
			if (keyboard_check(vk_alt))
			{
				instance.image_xscale = -1;
				instance.image_yscale = -1;
			}
			
			if (mirror)
			{
				instance.image_xscale *= -1;
			}
			
			if (flip)
			{
				instance.image_yscale *= -1;
			}
		}
							
		if (keyboard_check(vk_alt))
		{
			if (trimX < trimH - trimY)
			{
				if (editorCurrentObject == o_ramp)
				{
					instance = instance_create_layer(_xSpawn - 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
					instance = instance_create_layer(_xSpawn + 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
				}
				else
				{
					instance = instance_create_layer(_xSpawn, _ySpawn, "level", o_block);
				}
			}
		}
		else
		{
			if (trimX > trimH - trimY)
			{
				if (editorCurrentObject == o_ramp)
				{
					if (trimX < trimH + 1)
					{
						instance = instance_create_layer(_xSpawn - 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
						instance = instance_create_layer(_xSpawn + 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
					}
				}
				else
				{
					instance = instance_create_layer(_xSpawn, _ySpawn, "level", o_block);
				}
			}
		}
	}
	else
	{
		if (trimX == trimY)
		{
			if (editorCurrentObject == o_ramp)
			{
				instance = instance_create_layer(_xSpawn + (counter * 16 * rampMirror), _ySpawn, "level", editorCurrentObject);
			}
			else
			{			
				instance = instance_create_layer(_xSpawn, _ySpawn, "level", editorCurrentObject);
			}
							
			if (instance != noone)
			{
				instance.image_xscale = -1;
							
				if (keyboard_check(vk_alt))
				{
					instance.image_xscale = 1;
					instance.image_yscale = -1;
				}
			
				if (mirror)
				{
					instance.image_xscale *= -1;
				}
			
				if (flip)
				{
					instance.image_yscale *= -1;
				}
			}
		}
							
		if (keyboard_check(vk_alt))
		{
			if (trimX > trimY)
			{
				if (editorCurrentObject == o_ramp)
				{
					if (trimX < trimH + 1)
					{
						instance = instance_create_layer(_xSpawn - 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
						instance = instance_create_layer(_xSpawn + 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
					}
				}
				else
				{
					instance = instance_create_layer(_xSpawn, _ySpawn, "level", o_block);
				}
			}
		}
		else
		{
			if (trimX < trimY)
			{
				if (editorCurrentObject == o_ramp)
				{
					instance = instance_create_layer(_xSpawn - 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
					instance = instance_create_layer(_xSpawn + 8 + (16 * counter * rampMirror), _ySpawn, "level", o_block);
				}
				else
				{
					instance = instance_create_layer(_xSpawn, _ySpawn, "level", o_block);
				}
			}
		}
	}
}

function scr_deleteRegion(x1, y1, x2, y2)
{
	var collisionList = ds_list_create();
			
	collision_rectangle_list(x1, y1, x2, y2, o_collision, true, true, collisionList, false);
	for(var i = 0; i < ds_list_size(collisionList); i++)
	{
		instance_destroy(ds_list_find_value(collisionList, i));
	}
			
	ds_list_clear(collisionList);
			
	collision_rectangle_list(x1, y1, x2, y2, o_obstacle, true, true, collisionList, false);
	for(var i = 0; i < ds_list_size(collisionList); i++)
	{
		instance_destroy(ds_list_find_value(collisionList, i));
	}
	
	ds_list_clear(collisionList);
	
	collision_rectangle_list(x1, y1, x2, y2, o_start, true, true, collisionList, false);
	for(var i = 0; i < ds_list_size(collisionList); i++)
	{
		instance_destroy(ds_list_find_value(collisionList, i));
	}
}

function scr_editorLogic()
{
	if (ImGui.IsAnyItemHovered() == false)
	{
		if (mouse_check_button_pressed(mb_any))
		{
			cursorXPressed = cursorX;
			cursorYPressed = cursorY;
		}
		
		if (mouse_check_button_released(mb_any))
		{
			if (cursorX < cursorXPressed)
			{
				var swap = cursorX;
				cursorX = cursorXPressed;
				cursorXPressed = swap;
			}
			
			if (cursorY < cursorYPressed)
			{
				var swap = cursorY;
				cursorY = cursorYPressed;
				cursorYPressed = swap;
			}
		}
		
		if (mouse_check_button_released(mb_left))
		{	
			var counter = 0;
						
			for(var _x = cursorXPressed; _x <= cursorX; _x += 16)
			{
				for(var _y = cursorYPressed; _y <= cursorY; _y += 16)
				{	
					var objectSprite = object_get_sprite(editorCurrentObject);
	
					var objectWidth = sprite_get_width(objectSprite);
					var objectHeight = sprite_get_height(objectSprite);
					
					var _xSpawn = _x + objectWidth / 2;
					var _ySpawn = _y + objectHeight / 2;
					
					var instance;
					
					if (editorSlopeCreation)
					{
						scr_createSlope(_x, _y, _xSpawn, _ySpawn,,, counter);
						
						if (editorMirror)
						{
							if (editorCurrentObject == o_ramp)
							{
								scr_createSlope(_x, _y, room_width - _xSpawn, _ySpawn, true,, counter);
							}
							else
							{
								scr_createSlope(_x, _y, room_width - _xSpawn, _ySpawn, true,, counter);
							}
						}
						
						if (editorFlip)
						{
							scr_createSlope(_x, _y, _xSpawn, room_height - _ySpawn,, true, counter);
						}
						
						if (editorMirror and editorFlip)
						{
							scr_createSlope(_x, _y, room_width - _xSpawn, room_height - _ySpawn, true, true, counter);
						}
					}
					else
					{
						instance = instance_create_layer(_xSpawn, _ySpawn, "level", editorCurrentObject);
					
						if (editorMirror)
						{
							instance = instance_create_layer(room_width - (_xSpawn), _ySpawn, "level", editorCurrentObject);
							instance.image_xscale = -1;
						}
					
						if (editorFlip)
						{
							instance = instance_create_layer(_xSpawn, room_height - (_ySpawn), "level", editorCurrentObject);
							instance.image_yscale = -1;
						}
					
						if (editorMirror and editorFlip)
						{
							instance = instance_create_layer(room_width - (_xSpawn), room_height - (_ySpawn), "level", editorCurrentObject);
							instance.image_xscale = -1;
							instance.image_yscale = -1;
						}
					}
				}
				
				counter++;
			}
		}
		
		if (mouse_check_button_released(mb_right))
		{	
			scr_deleteRegion(cursorXPressed, cursorYPressed, cursorX + 8, cursorY + 8);
			
			if (editorMirror)
			{
				scr_deleteRegion(room_width - cursorXPressed, cursorYPressed, room_width - (cursorX + 8), cursorY + 8);
			}
					
			if (editorFlip)
			{
				scr_deleteRegion(cursorXPressed, room_height - cursorYPressed, cursorX + 8, room_height - (cursorY + 8));
			}
					
			if (editorMirror and editorFlip)
			{
				scr_deleteRegion(room_width - cursorXPressed, room_height - cursorYPressed, room_width - (cursorX + 8), room_height - (cursorY + 8));
			}
		}
		
		cursorX = mouse_x div 16 * 16;
		cursorY = mouse_y div 16 * 16;
		
		if (cursorX > cursorXPressed)
		{
			if (cursorY > cursorYPressed)
			{
				editorDirection = EditorDirectionType.bottomRight;
			}
			else
			{
				editorDirection = EditorDirectionType.topRight;
			}
		}
		else
		{
			if (cursorY > cursorYPressed)
			{
				editorDirection = EditorDirectionType.bottomLeft;
			}
			else
			{
				editorDirection = EditorDirectionType.topLeft;
			}
		}
		
		if (!mouse_check_button(mb_any))
		{
			cursorXPressed = cursorX;
			cursorYPressed = cursorY;
		}
		else
		{
			if (keyboard_check(vk_shift))
			{
				if (abs(cursorX - cursorXPressed) > abs(cursorY - cursorYPressed))
				{
					cursorY = cursorYPressed;
				}
				else
				{
					cursorX = cursorXPressed;
				}
			}
			
			if (keyboard_check(vk_control) or (editorSlopeCreation and !mouse_check_button(mb_right)))
			{
				var rectangleWidth;
				var rectangleHeight;
				
				if (abs(cursorX - cursorXPressed) > abs(cursorY - cursorYPressed))
				{
					rectangleWidth = abs(cursorX - cursorXPressed);
				}
				else
				{
					rectangleWidth = abs(cursorY - cursorYPressed);
				}
				
				rectangleHeight = rectangleWidth;
				
				if (editorCurrentObject == o_ramp)
				{
					rectangleWidth *= 2;
				}
				
				switch(editorDirection)
				{
					case(EditorDirectionType.bottomRight):
					{
						cursorX = cursorXPressed + rectangleWidth;
						cursorY = cursorYPressed + rectangleHeight;
						
						break;
					}
					
					case(EditorDirectionType.topRight):
					{
						cursorX = cursorXPressed + rectangleWidth;
						cursorY = cursorYPressed - rectangleHeight;
						
						break;
					}

					case(EditorDirectionType.bottomLeft):
					{
						cursorX = cursorXPressed - rectangleWidth;
						cursorY = cursorYPressed + rectangleHeight;
						
						break;
					}
					
					case(EditorDirectionType.topLeft):
					{
						cursorX = cursorXPressed - rectangleWidth;
						cursorY = cursorYPressed - rectangleHeight;
						
						break;
					}
				}
			}
		}
	}
	
	if (!editorFullView)
	{
		var mouseWheelChange = (mouse_wheel_down() - mouse_wheel_up()) * 16;
		camera_set_view_size(view_camera[1], camera_get_view_width(view_camera[1]) + mouseWheelChange * 16, camera_get_view_height(view_camera[1]) + mouseWheelChange * 9);
	}
	
	if (mouse_check_button_pressed(mb_middle))
	{
		o_char.x = cursorX;
		o_char.y = cursorY;
	}
}

function scr_serializeObject(objectType, file)
{
	function objectSerialized(_x, _y, _imageXScale, _imageYScale, _object) constructor
	{	
		xPos = _x;
		yPos = _y;
		imageXScale = _imageXScale;
		imageYScale = _imageYScale;
		objectType = _object;
	}
	
	with (objectType) 
    {
        var instanceSerialized = new objectSerialized(x, y, image_xscale, image_yscale, objectType);

		file_text_write_string(file, json_stringify(instanceSerialized));
		file_text_writeln(file);
		
		delete instanceSerialized;
    }
}

function scr_levelSave(levelName = editorFileName)
{
    var fileName = string("level_{0}.json", levelName);
    if (file_exists(fileName))
    {
        file_delete(fileName);
    }
    
    var objectList = ds_map_create();

    var file = file_text_open_write(fileName);

	scr_serializeObject(o_block, file);
	scr_serializeObject(o_slope, file);
	scr_serializeObject(o_ramp, file);
	scr_serializeObject(o_obstacle, file);
	scr_serializeObject(o_start, file);
   
    file_text_close(file);
	
	log(string("Level {0} Saved", levelName));
}

function scr_levelLoad(levelName = editorFileName)
{
    var fileName = string("level_{0}.json", levelName);
    
    if (file_exists(fileName))
    {
        var file = file_text_open_read(fileName);

        while (!file_text_eof(file))
        {
            var jsonString = file_text_read_string(file);
			file_text_readln(file);
            var instanceData = json_parse(jsonString);

            var newInstance = instance_create_layer(instanceData.xPos, instanceData.yPos, "Level", instanceData.objectType);
			newInstance.image_xscale = instanceData.imageXScale;
			newInstance.image_yscale = instanceData.imageYScale;
        }

        file_text_close(file);
		
		log(string("Level {0} Loaded", levelName));
		return;
    }
	
	log(string("Level {0} Doesnt exist", levelName), c_red);
}

function scr_fileDelete(fileName)
{	
	file_delete(fileName);
    
	log(string("File {0} Deleted", fileName));
}

function scr_getFiles(prefix = "", suffix = ".json") 
{
    var fileList = [];

    var filePattern = prefix + "*" + suffix;
    var file = file_find_first(filePattern, fa_none);

    while (file != "") 
	{
        fileList[array_length(fileList)] = file;
        file = file_find_next();
    }

    file_find_close();
    return fileList;
}

function scr_fileSearchList(fileType, fileName, files)
{
	var returnList = ds_list_create();
	
	fileName = ImGui.InputText("File name: ##" + fileType, fileName);
	
	var fileTypeAsPrefix = fileType + "_";
	
	for (var i = 0; i < array_length(files); i++) 
	{
		var name = string_replace(files[i], fileTypeAsPrefix, "");
		name = string_replace(name, ".json", "");
		
	    if (ImGui.Selectable(name)) 
		{
			fileName = name;
		}
	}
	
	if (ImGui.Button("Save ##stats"))
	{
		switch(fileType)
		{
			case("level"):
			{
				scr_levelSave();
				break;
			}
			case("rules"):
			{
				scr_rulesPresetSave()
				break;
			}
			case("stats"):
			{
				scr_statsPresetSave()
				break;
			}
			case("modificators"):
			{
				scr_modificatorsPresetSave(, instance_find(o_char, choosedPlayerIndex));
				break;
			}
		}
		files = scr_getFiles(fileTypeAsPrefix);
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("Load ##" + fileType))
	{
		switch(fileType)
		{
			case("level"):
			{
				scr_levelLoad();
				break;
			}
			case("rules"):
			{
				scr_rulesPresetLoad()
				break;
			}
			case("stats"):
			{
				scr_statsPresetLoad()
				break;
			}
			case("modificators"):
			{
				scr_modificatorsPresetLoad(, instance_find(o_char, choosedPlayerIndex));
				break;
			}
		}
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("Delete ##" + fileType))
	{
		file_delete(string("{0}{1}.json", fileTypeAsPrefix, fileName));
		files = scr_getFiles(fileTypeAsPrefix);
	}
	
	ImGui.Separator();
	
	ds_list_add(returnList, fileName, files);
	
	return returnList;
}

function scr_editorOptions()
{
	editorMirror = ImGui.Checkbox("Mirror", editorMirror);
	editorFlip = ImGui.Checkbox("Flip", editorFlip);
	
	editorFullView = ImGui.Checkbox("Full view", editorFullView);
	
	if (editorFullView)
	{
		view_set_visible(1, false);
		view_set_visible(2, true);
	}
	else
	{
		view_set_visible(1, true);
		view_set_visible(2, false);
	}
	
	ImGui.BeginDisabled(editorFullView);
	if (ImGui.Button("Reset view"))
	{
        camera_set_view_size(view_camera[1], 800, 450);
	}
	ImGui.EndDisabled();
	
	returnList = scr_fileSearchList("level", editorFileName, editorFiles);
		
	editorFileName = ds_list_find_value(returnList, 0);
	editorFiles = ds_list_find_value(returnList, 1);
		
	ds_list_destroy(returnList);
	
	var buttonSize = 64;
	var itemsPerRow = 5;
	var totalItems = ds_list_size(editorObjects);

	for (var i = 0; i < totalItems; i++) 
	{
	    var object = ds_list_find_value(editorObjects, i);
	    var sprite = object_get_sprite(object);
	    var spriteBboxWidth = sprite_get_bbox_right(sprite) - sprite_get_bbox_left(sprite);
	    var spriteBboxHeight = sprite_get_bbox_bottom(sprite) - sprite_get_bbox_top(sprite);
		
		var spriteWidth = sprite_get_width(sprite);
		var spriteHeight = sprite_get_height(sprite);
		
		var scale = 2;
		var selectionAlpha = 0.5;
		
		if (i == editorCurrentObjectIndex)
		{
			selectionAlpha = 1;
		}
    
	    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, (buttonSize - spriteBboxWidth * scale) / 2, (buttonSize - spriteBboxHeight * scale) / 2);

	    if (ImGui.ImageButton(string("sprite {0}", i), sprite, 0, c_white, selectionAlpha, c_white, 0, spriteWidth * scale, spriteHeight * scale))
		{
			editorCurrentObjectIndex = i;
	        editorCurrentObject = object;

	        if (editorCurrentObject == o_ramp or editorCurrentObject == o_slope)
	        {
	            editorSlopeCreation = true;
	        }
	        else
	        {
	            editorSlopeCreation = false;
	        }
		}

		ImGui.PopStyleVar();

	    if (i + 1 != totalItems and (i + 1) % itemsPerRow != 0)
	    {
	        ImGui.SameLine();
	    }
	}
	
	ImGui.Separator();
}

function scr_serializeRulesPreset(file)
{
	function rulesPresetSerialized(_maximumChaseTime, _changesPerChase) constructor
	{	
		maximumChaseTime = _maximumChaseTime;
		changesPerChase = _changesPerChase;
	}
	
    var instanceSerialized = new rulesPresetSerialized(o_gameManager.maximumChaseTime, o_gameManager.changesPerChase);

	file_text_write_string(file, json_stringify(instanceSerialized));
	file_text_writeln(file);
		
	delete instanceSerialized;
}

function scr_rulesPresetSave(rulesPresetName = rulesPresetFileName)
{
    var fileName = string("rules_{0}.json", rulesPresetName);
    if (file_exists(fileName))
    {
        file_delete(fileName);
    }
    
    var objectList = ds_map_create();

    var file = file_text_open_write(fileName);

	scr_serializeRulesPreset(file);
   
    file_text_close(file);
	
	log(string("Rules Preset {0} Saved", rulesPresetName));
}

function scr_rulesPresetLoad(rulesPresetName = rulesPresetFileName)
{
    var fileName = string("rules_{0}.json", rulesPresetName);
    
    if (file_exists(fileName))
    {
        var file = file_text_open_read(fileName);

        while (!file_text_eof(file))
        {
            var jsonString = file_text_read_string(file);
			file_text_readln(file);
            var instanceData = json_parse(jsonString);

            o_gameManager.maximumChaseTime = instanceData.maximumChaseTime;
			o_gameManager.changesPerChase = instanceData.changesPerChase;
			o_gameManager.reset();
        }

        file_text_close(file);
		
		log(string("Rules Preset {0} Loaded", rulesPresetName));
		return;
    }
	
	log(string("Rules Preset {0} Doesnt exist", rulesPresetName), c_red);
}

function scr_serializeStatsPreset(file)
{
    function statsPresetSerialized(_maximumDefaultSpeed, _acceleration, _deceleration, _maximumSpeedDecelerationFactor, _jumpForce, _momentumJumpForce, _gravitation, _slopeAcceleration, _slopeDeceleration, _rampAcceleration, _rampDeceleration, _maximumSlopeSpeed, _maximumRampSpeed, _slopeSpeedTransitionFactor, _maximumCoyoteTime, _obstacleRange, _maximumObstacleJumpForce, _minimumObstacleJumpForce, _maximumJumpBuffor) constructor
    {   
        maximumDefaultSpeed = _maximumDefaultSpeed;
        acceleration = _acceleration;
        deceleration = _deceleration;
        maximumSpeedDecelerationFactor = _maximumSpeedDecelerationFactor;
        jumpForce = _jumpForce;
        momentumJumpForce = _momentumJumpForce;
        gravitation = _gravitation;
        slopeAcceleration = _slopeAcceleration;
        slopeDeceleration = _slopeDeceleration;
        rampAcceleration = _rampAcceleration;
        rampDeceleration = _rampDeceleration;
        maximumSlopeSpeed = _maximumSlopeSpeed;
        maximumRampSpeed = _maximumRampSpeed;
        slopeSpeedTransitionFactor = _slopeSpeedTransitionFactor;
        maximumCoyoteTime = _maximumCoyoteTime;
        obstacleRange = _obstacleRange;
        maximumObstacleJumpForce = _maximumObstacleJumpForce;
        minimumObstacleJumpForce = _minimumObstacleJumpForce;
        maximumJumpBuffor = _maximumJumpBuffor;
    }
    
    var instanceSerialized = new statsPresetSerialized(
        o_gameManager.maximumDefaultSpeed,
        o_gameManager.acceleration,
        o_gameManager.deceleration,
        o_gameManager.maximumSpeedDecelerationFactor,
        o_gameManager.jumpForce,
        o_gameManager.momentumJumpForce,
        o_gameManager.gravitation,
        o_gameManager.slopeAcceleration,
        o_gameManager.slopeDeceleration,
        o_gameManager.rampAcceleration,
        o_gameManager.rampDeceleration,
        o_gameManager.maximumSlopeSpeed,
        o_gameManager.maximumRampSpeed,
        o_gameManager.slopeSpeedTransitionFactor,
        o_gameManager.maximumCoyoteTime,
        o_gameManager.obstacleRange,
        o_gameManager.maximumObstacleJumpForce,
        o_gameManager.minimumObstacleJumpForce,
        o_gameManager.maximumJumpBuffor
    );

    file_text_write_string(file, json_stringify(instanceSerialized));
    file_text_writeln(file);
    
    delete instanceSerialized;
}

function scr_statsPresetSave(statsPresetName = statsPresetFileName)
{
    var fileName = string("stats_{0}.json", statsPresetName);
    if (file_exists(fileName))
    {
        file_delete(fileName);
    }
    
    var objectList = ds_map_create();

    var file = file_text_open_write(fileName);

	scr_serializeStatsPreset(file);
   
    file_text_close(file);
	
	log(string("Stats Preset {0} Saved", statsPresetName));
}

function scr_statsPresetLoad(statsPresetName = statsPresetFileName)
{
    var fileName = string("stats_{0}.json", statsPresetName);
    
    if (file_exists(fileName))
    {
        var file = file_text_open_read(fileName);

        while (!file_text_eof(file))
        {
            var jsonString = file_text_read_string(file);
            file_text_readln(file);
            var instanceData = json_parse(jsonString);

            o_gameManager.maximumDefaultSpeed = instanceData.maximumDefaultSpeed;
            o_gameManager.acceleration = instanceData.acceleration;
            o_gameManager.deceleration = instanceData.deceleration;
            o_gameManager.maximumSpeedDecelerationFactor = instanceData.maximumSpeedDecelerationFactor;
            o_gameManager.jumpForce = instanceData.jumpForce;
            o_gameManager.momentumJumpForce = instanceData.momentumJumpForce;
            o_gameManager.gravitation = instanceData.gravitation;
            o_gameManager.slopeAcceleration = instanceData.slopeAcceleration;
            o_gameManager.slopeDeceleration = instanceData.slopeDeceleration;
            o_gameManager.rampAcceleration = instanceData.rampAcceleration;
            o_gameManager.rampDeceleration = instanceData.rampDeceleration;
            o_gameManager.maximumSlopeSpeed = instanceData.maximumSlopeSpeed;
            o_gameManager.maximumRampSpeed = instanceData.maximumRampSpeed;
            o_gameManager.slopeSpeedTransitionFactor = instanceData.slopeSpeedTransitionFactor;
            o_gameManager.maximumCoyoteTime = instanceData.maximumCoyoteTime;
            o_gameManager.obstacleRange = instanceData.obstacleRange;
            o_gameManager.maximumObstacleJumpForce = instanceData.maximumObstacleJumpForce;
            o_gameManager.minimumObstacleJumpForce = instanceData.minimumObstacleJumpForce;
            o_gameManager.maximumJumpBuffor = instanceData.maximumJumpBuffor;
        }
		
		with(o_char)
		{
			setupStats();
		}

        file_text_close(file);
		
		log(string("Stats Preset {0} Loaded", statsPresetName));
		return;
    }
	
	log(string("Stats Preset {0} Doesnt exist", statsPresetName), c_red);
}

function scr_serializeModificatorsPreset(file, choosedPlayer)
{
    function modificatorsPresetSerialized(_maximumDefaultSpeed, _acceleration, _deceleration, _maximumSpeedDecelerationFactor, _jumpForce, _momentumJumpForce, _gravitation, _slopeAcceleration, _slopeDeceleration, _rampAcceleration, _rampDeceleration, _maximumSlopeSpeed, _maximumRampSpeed, _slopeSpeedTransitionFactor, _maximumCoyoteTime, _obstacleRange, _maximumObstacleJumpForce, _minimumObstacleJumpForce, _maximumJumpBuffor, _color) constructor
    {   
        maximumDefaultSpeed = _maximumDefaultSpeed;
        acceleration = _acceleration;
        deceleration = _deceleration;
        maximumSpeedDecelerationFactor = _maximumSpeedDecelerationFactor;
        jumpForce = _jumpForce;
        momentumJumpForce = _momentumJumpForce;
        gravitation = _gravitation;
        slopeAcceleration = _slopeAcceleration;
        slopeDeceleration = _slopeDeceleration;
        rampAcceleration = _rampAcceleration;
        rampDeceleration = _rampDeceleration;
        maximumSlopeSpeed = _maximumSlopeSpeed;
        maximumRampSpeed = _maximumRampSpeed;
        slopeSpeedTransitionFactor = _slopeSpeedTransitionFactor;
        maximumCoyoteTime = _maximumCoyoteTime;
        obstacleRange = _obstacleRange;
        maximumObstacleJumpForce = _maximumObstacleJumpForce;
        minimumObstacleJumpForce = _minimumObstacleJumpForce;
        maximumJumpBuffor = _maximumJumpBuffor;
        color = _color;
    }
    
    var instanceSerialized = new modificatorsPresetSerialized(
        choosedPlayer.maximumDefaultSpeedModificator,
        choosedPlayer.accelerationModificator,
        choosedPlayer.decelerationModificator,
        choosedPlayer.maximumSpeedDecelerationFactorModificator,
        choosedPlayer.jumpForceModificator,
        choosedPlayer.momentumJumpForceModificator,
        choosedPlayer.gravitationModificator,
        choosedPlayer.slopeAccelerationModificator,
        choosedPlayer.slopeDecelerationModificator,
        choosedPlayer.rampAccelerationModificator,
        choosedPlayer.rampDecelerationModificator,
        choosedPlayer.maximumSlopeSpeedModificator,
        choosedPlayer.maximumRampSpeedModificator,
        choosedPlayer.slopeSpeedTransitionFactorModificator,
        choosedPlayer.maximumCoyoteTimeModificator,
        choosedPlayer.obstacleRangeModificator,
        choosedPlayer.maximumObstacleJumpForceModificator,
        choosedPlayer.minimumObstacleJumpForceModificator,
        choosedPlayer.maximumJumpBufforModificator,
        choosedPlayer.color
    );

    file_text_write_string(file, json_stringify(instanceSerialized));
    file_text_writeln(file);
    
    delete instanceSerialized;
}

function scr_modificatorsPresetSave(modificatorsPresetName = modificatorsPresetFileName, choosedPlayer)
{
    var fileName = string("modificators_{0}.json", modificatorsPresetName);
    if (file_exists(fileName))
    {
        file_delete(fileName);
    }
    
    var objectList = ds_map_create();

    var file = file_text_open_write(fileName);

	scr_serializeModificatorsPreset(file, choosedPlayer);
   
    file_text_close(file);
	
	log(string("Modificators Preset {0} Saved", modificatorsPresetName));
}

function scr_modificatorsPresetLoad(modificatorsPresetName = modificatorsPresetFileName, choosedPlayer)
{
    var fileName = string("modificators_{0}.json", modificatorsPresetName, choosedPlayer);
    
    if (file_exists(fileName))
    {
        var file = file_text_open_read(fileName);

        while (!file_text_eof(file))
        {
            var jsonString = file_text_read_string(file);
            file_text_readln(file);
            var instanceData = json_parse(jsonString);

            choosedPlayer.maximumDefaultSpeedModificator = instanceData.maximumDefaultSpeed;
            choosedPlayer.accelerationModificator = instanceData.acceleration;
            choosedPlayer.decelerationModificator = instanceData.deceleration;
            choosedPlayer.maximumSpeedDecelerationFactorModificator = instanceData.maximumSpeedDecelerationFactor;
            choosedPlayer.jumpForceModificator = instanceData.jumpForce;
            choosedPlayer.momentumJumpForceModificator = instanceData.momentumJumpForce;
            choosedPlayer.gravitationModificator = instanceData.gravitation;
            choosedPlayer.slopeAccelerationModificator = instanceData.slopeAcceleration;
            choosedPlayer.slopeDecelerationModificator = instanceData.slopeDeceleration;
            choosedPlayer.rampAccelerationModificator = instanceData.rampAcceleration;
            choosedPlayer.rampDecelerationModificator = instanceData.rampDeceleration;
            choosedPlayer.maximumSlopeSpeedModificator = instanceData.maximumSlopeSpeed;
            choosedPlayer.maximumRampSpeedModificator = instanceData.maximumRampSpeed;
            choosedPlayer.slopeSpeedTransitionFactorModificator = instanceData.slopeSpeedTransitionFactor;
            choosedPlayer.maximumCoyoteTimeModificator = instanceData.maximumCoyoteTime;
            choosedPlayer.obstacleRangeModificator = instanceData.obstacleRange;
            choosedPlayer.maximumObstacleJumpForceModificator = instanceData.maximumObstacleJumpForce;
            choosedPlayer.minimumObstacleJumpForceModificator = instanceData.minimumObstacleJumpForce;
            choosedPlayer.maximumJumpBufforModificator = instanceData.maximumJumpBuffor;
            choosedPlayer.maximumJumpBufforModificator = instanceData.maximumJumpBuffor;
            choosedPlayer.color = instanceData.color;
        }
		
		with(choosedPlayer)
		{
			setupStats();
		}

        file_text_close(file);
		
		log(string("Modificators Preset {0} Loaded", modificatorsPresetName));
		return;
    }
	
	log(string("Modificators Preset {0} Doesnt exist", modificatorsPresetName), c_red);
}

function scr_gameRules()
{
	returnList = scr_fileSearchList("rules", rulesPresetFileName, rulesPresetsFiles);
		
	rulesPresetFileName = ds_list_find_value(returnList, 0);
	rulesPresetsFiles = ds_list_find_value(returnList, 1);
		
	ds_list_destroy(returnList);
	
	if (ImGui.Button("START / STOP"))
	{
		o_gameManager.startStop();
	}
	
	if (ImGui.Button("Restart"))
	{
		o_gameManager.reset();
	}
	
	var timeInSeconds = o_gameManager.maximumChaseTime / 60;
	timeInSeconds = ImGui.InputInt("Chase Time (sek)", timeInSeconds);
	o_gameManager.maximumChaseTime = timeInSeconds * 60
	o_gameManager.changesPerChase = ImGui.InputInt("Changes Per Chase", o_gameManager.changesPerChase);
	
}