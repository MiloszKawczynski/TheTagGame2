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
	    ImGui.DockBuilderDockWindow("Players Data", docs[1]);

	    ImGui.DockBuilderFinish(dockspaceID);

		ImGui.SetWindowFocus("Debug");

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
	}
	ImGui.SameLine();
	if (ImGui.Button("Delete Player"))
	{
		if (instance_number(o_char) > 0)
		{
			instance_destroy(instance_find(o_char, choosedPlayerIndex));
		}
	}
}

function scr_gameOptions()
{
	ImGui.Text("Game Options");
	
	var buttonGameModeName;
	if (global.debugIsGravityOn) {buttonGameModeName = "Top-Down";} else {buttonGameModeName = "Platformer";}
	if(ImGui.Button(buttonGameModeName))
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
	
	global.debugCameraAxis = ImGui.Checkbox("Camera Axis", global.debugCameraAxis);
	global.debugAutoCamera = ImGui.Checkbox("Auto Camera", global.debugAutoCamera);
	global.debugOutOfViewCulling = ImGui.Checkbox("Out of View Culling", global.debugOutOfViewCulling);
	
	ImGui.Text(string("Angle: {0}", Camera.Angle));
	ImGui.Text(string("Pitch: {0}", Camera.Pitch));
	ImGui.Text(string("Zoom: {0}", Camera.Zoom));
	
	ImGui.Separator();
}

function scr_logs()
{
	if (ImGui.Button("Clear"))
	{
		ds_list_clear(logBuffor);
		ds_list_clear(logColor);
		ds_list_clear(monitoredValue);
	}
	ImGui.SameLine();
	if (ImGui.Button("Log!"))
	{
		log("Log!", c_yellow);
	}
	ImGui.SameLine();
	isAutoScrollOn = ImGui.Checkbox("AutoScroll", isAutoScrollOn);
	
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
	
	ImGui.Separator();
}

function scr_playerStats()
{
    var choosedPlayer = instance_find(o_char, choosedPlayerIndex);

    if (ImGui.CollapsingHeader("Stats"))
    {
		ImGui.Text(string("Player {0} Stats", choosedPlayerIndex));
		
        choosedPlayer.maximumDefaultSpeed = scr_statitstic("Default Speed",  choosedPlayer.maximumDefaultSpeed);
        choosedPlayer.acceleration = scr_statitstic("Acceleration",  choosedPlayer.acceleration);
        choosedPlayer.deceleration = scr_statitstic("Deceleration",  choosedPlayer.deceleration);
        choosedPlayer.maximumSpeedDecelerationFactor = scr_statitstic("Maximum Speed Deceleration Factor",  choosedPlayer.maximumSpeedDecelerationFactor);
        choosedPlayer.jumpForce = scr_statitstic("Jump Height",  choosedPlayer.jumpForce);
        choosedPlayer.momentumJumpForce = scr_statitstic("Speed Additional Jump Height",  choosedPlayer.momentumJumpForce);
        choosedPlayer.gravitation = scr_statitstic("Gravity",  choosedPlayer.gravitation);
        choosedPlayer.slopeAcceleration = scr_statitstic("Slope Acceleration",  choosedPlayer.slopeAcceleration);
        choosedPlayer.rampAcceleration = scr_statitstic("Ramp Acceleration",  choosedPlayer.rampAcceleration);
        choosedPlayer.maximumSlopeSpeed = scr_statitstic("Slope Deceleration",  choosedPlayer.maximumSlopeSpeed);
        choosedPlayer.maximumRampSpeed = scr_statitstic("Ramp Deceleration",  choosedPlayer.maximumRampSpeed);
        choosedPlayer.slopeSpeedTransitionFactor = scr_statitstic("Slope Speed Transition Factor",  choosedPlayer.slopeSpeedTransitionFactor);
        choosedPlayer.maximumCoyoteTime = scr_statitstic("Coyote Time",  choosedPlayer.maximumCoyoteTime);
        choosedPlayer.obstacleRange = scr_statitstic("Obstacle Range",  choosedPlayer.obstacleRange);
        choosedPlayer.minimumObstacleJumpForce = scr_statitstic("Minimum Obstacle Jump",  choosedPlayer.minimumObstacleJumpForce);
        choosedPlayer.maximumObstacleJumpForce = scr_statitstic("Maximum Obstacle Jump",  choosedPlayer.maximumObstacleJumpForce);
        choosedPlayer.maximumJumpBuffor = scr_statitstic("Maximum Jump Buffor",  choosedPlayer.maximumJumpBuffor);
        choosedPlayer.color = ImGui.ColorEdit3("Color", choosedPlayer.color);
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
	
	scr_playerStats();
	
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
		
		ImGui.Text(string("x: {0}", choosedPlayer.x));
		ImGui.Text(string("y: {0}", choosedPlayer.y));
		ImGui.Text(string("Speed: {0}", choosedPlayer.speed));
		ImGui.Text(string("hSpeed: {0}", choosedPlayer.horizontalSpeed));
		ImGui.Text(string("vSpeed: {0}", choosedPlayer.verticalSpeed));
		ImGui.Text(string("isGrounded: {0}", choosedPlayer.isGrounded));
		ImGui.Text(string("maxSpeed: {0}", choosedPlayer.maximumSpeed));
		ImGui.Text(string("coyoteTime: {0}", choosedPlayer.coyoteTime));
		ImGui.Text(string("jumpBuffor: {0}", choosedPlayer.jumpBuffor));
		
		if (i == choosedPlayerIndex)
		{
			ImGui.PopStyleColor();
		}
		
		ImGui.Separator();
	}
	
	if (ImGui.Button("Player")) 
	{
		isStatsOpen = true;
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
						
	if (rotate)
	{
		if (trimX == trimH - trimY)
		{			
			if (editorCurrentObject == o_ramp)
			{
				instance = instance_create_layer(_xSpawn + (counter * 16), _ySpawn, "level", editorCurrentObject);
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
					instance = instance_create_layer(_xSpawn - 8 + (16 * counter), _ySpawn, "level", o_block);
					instance = instance_create_layer(_xSpawn + 8 + (16 * counter), _ySpawn, "level", o_block);
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
						instance = instance_create_layer(_xSpawn - 8 + (16 * counter), _ySpawn, "level", o_block);
						instance = instance_create_layer(_xSpawn + 8 + (16 * counter), _ySpawn, "level", o_block);
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
				instance = instance_create_layer(_xSpawn + (counter * 16), _ySpawn, "level", editorCurrentObject);
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
						instance = instance_create_layer(_xSpawn - 8 + (16 * counter), _ySpawn, "level", o_block);
						instance = instance_create_layer(_xSpawn + 8 + (16 * counter), _ySpawn, "level", o_block);
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
					instance = instance_create_layer(_xSpawn - 8 + (16 * counter), _ySpawn, "level", o_block);
					instance = instance_create_layer(_xSpawn + 8 + (16 * counter), _ySpawn, "level", o_block);
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
							scr_createSlope(_x, _y, room_width - _xSpawn, _ySpawn, true,, counter);
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
	function objectSerialized(_x, _y, _object) constructor
	{	
		xPos = _x;
		yPos = _y;
		objectType = _object;
	}
	
	with (objectType) 
    {
        var instanceSerialized = new objectSerialized(x, y, objectType);

		file_text_write_string(file, json_stringify(instanceSerialized));
		file_text_writeln(file);
		
		delete instanceSerialized;
    }
}

function scr_levelSave()
{
    var fileName = string("{0}.json", editorFileName);
    if (file_exists(fileName))
    {
        file_delete(fileName);
    }
    
    var objectList = ds_map_create();

    var file = file_text_open_write(fileName);

	scr_serializeObject(o_block, file);
	scr_serializeObject(o_slope, file);
	scr_serializeObject(o_ramp, file);
   
    file_text_close(file);
	
	log(string("Level {0} Saved", editorFileName));
}

function scr_levelLoad()
{
    var fileName = string("{0}.json", editorFileName);
    
    if (file_exists(fileName))
    {
        var file = file_text_open_read(fileName);

        while (!file_text_eof(file))
        {
            var jsonString = file_text_read_string(file);
			file_text_readln(file);
            var instanceData = json_parse(jsonString);

            var newInstance = instance_create_layer(instanceData.xPos, instanceData.yPos, "Level", instanceData.objectType);
        }

        file_text_close(file);
    }
	
	log(string("Level {0} Loaded", editorFileName));
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
	
	editorFileName = ImGui.InputText("File name: ", editorFileName);
	if (ImGui.Button("Save"))
	{
		scr_levelSave();
	}
	
	if (ImGui.Button("Load"))
	{
		scr_levelLoad();
	}
	
	if (ImGui.BeginCombo("Objects", object_get_name(ds_list_find_value(editorObjects, editorCurrentObjectIndex)), ImGuiComboFlags.HeightLarge)) 
	{
	    var maxWidth = ImGui.GetContentRegionAvailX();

	    for (var i = 0; i < ds_list_size(editorObjects); i++) 
		{
	        var object = ds_list_find_value(editorObjects, i);
	        var sprite = object_get_sprite(object);
			var spriteWidth = sprite_get_width(sprite);
			var spriteHeight = sprite_get_height(sprite);
	        var isSelected = (editorCurrentObjectIndex == i);

	        if (ImGui.Selectable(object_get_name(object), isSelected, 0, maxWidth, 32)) 
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

	        var cursorX = ImGui.GetCursorPosX();
	        ImGui.SameLine();
	        ImGui.SetCursorPosX(cursorX + maxWidth - spriteWidth * 2);
	        ImGui.Image(sprite, 0,,, spriteWidth * 2, spriteHeight * 2);

	        if (isSelected) 
			{
	            ImGui.SetItemDefaultFocus();
	        }
	    }

	    ImGui.EndCombo();
	}


	
	ImGui.Separator();
}