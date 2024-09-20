var dockspaceID = ImGui.DockSpaceOverViewport();

if (init)
{
	ImGui.DockBuilderRemoveNode(dockspaceID);
	ImGui.DockBuilderAddNode(dockspaceID);
	
	var docs = ImGui.DockBuilderSplitNode(dockspaceID, ImGuiDir.Left, 0.11);

	ImGui.DockBuilderDockWindow("Debug", docs[1]);
	ImGui.DockBuilderDockWindow("Game", docs[2]);

	ImGui.DockBuilderFinish(dockspaceID);
	
	init = false;
}

if (ImGui.Begin("Debug")) 
{	
	ImGui.Text("Game");
	
	var buttonGameModeName;
	if (global.debugIsGravityOn) {buttonGameModeName = "Top-Down";} else {buttonGameModeName = "Platformer";}
	if(ImGui.Button(buttonGameModeName))
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		
		scr_gravitationChange();
	}
	
	if(ImGui.Button("Reset"))
	{
		game_restart();
	}
	
	if (ImGui.Button("Add Player"))
	{
		instance_create_layer(o_char.x + 16, o_char.y + 16, "players", o_char, 
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
	
	ImGui.Separator();
	
	choosedPlayerIndex = ImGui.InputInt("Choosed Players", choosedPlayerIndex, 1);
	choosedPlayerIndex = clamp(choosedPlayerIndex, 0, instance_number(o_char) - 1);
	var choosedPlayer = instance_find(o_char, choosedPlayerIndex);
	
	ImGui.Text(string("x: {0}", choosedPlayer.x));
	ImGui.Text(string("y: {0}", choosedPlayer.y));
	ImGui.Text(string("Speed: {0}", choosedPlayer.speed));
	ImGui.Text(string("hSpeed: {0}", choosedPlayer.horizontalSpeed));
	ImGui.Text(string("vSpeed: {0}", choosedPlayer.verticalSpeed));
	ImGui.Text(string("isGrounded: {0}", choosedPlayer.isGrounded));
	ImGui.Text(string("maxSpeed: {0}", choosedPlayer.maximumSpeed));
	ImGui.Text(string("coyoteTime: {0}", choosedPlayer.coyoteTime));
	ImGui.Text(string("jumpBuffor: {0}", choosedPlayer.jumpBuffor));
	
	if (ImGui.Button("Player")) 
	{
		 isStatsOpen = true;
	}
	
	ImGui.Separator();
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
		if (Camera.Pitch == 90.1)
		{
			scr_gravitationChange();
		}
		else
		{
			Camera.Pitch = 90.1
		}
	};
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
	
	ImGui.Text(string("Angle: {0}", Camera.Angle));
	ImGui.Text(string("Pitch: {0}", Camera.Pitch));
	ImGui.Text(string("Zoom: {0}", Camera.Zoom));
	
	ImGui.Separator();
	
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
	
	ImGui.End();
}
if (ImGui.Begin("Game"))
{
	var width = ImGui.GetWindowWidth();
	var height = width * 9 / 16;
	
	if (height > ImGui.GetWindowHeight())
	{
		height = ImGui.GetWindowHeight();
		width = height * 16 / 9;
	}

	if (isApplicationSurfaceEnabled)
	{
		ImGui.Surface(application_surface,,, width, height);
	}
	else
	{
		ImGui.Surface(RenderPipeline.screenSurface,,, width, height);
	}
	ImGui.End();
}

if (isStatsOpen)
{
	isStatsOpen = ImGui.Begin("Clea Stats", isStatsOpen, ImGuiWindowFlags.None, ImGuiReturnMask.Pointer);

	var width = 400;
	var label_width = 150;
	var input_width = 50;
	var spacing = 10;
	
	var choosedPlayer = instance_find(o_char, choosedPlayerIndex);
	
	choosedPlayer.maximumDefaultSpeed = scr_statitstic("Default Speed",  choosedPlayer.maximumDefaultSpeed);
	choosedPlayer.acceleration = scr_statitstic("Acceleration",  choosedPlayer.acceleration);
	choosedPlayer.deceleration = scr_statitstic("Deceleration",  choosedPlayer.deceleration);
	choosedPlayer.maximumSpeedDecelerationFactor = scr_statitstic("Maximum Speed Deceleration Factor",  choosedPlayer.maximumSpeedDecelerationFactor);
	choosedPlayer.jumpForce = scr_statitstic("Jump Height",  choosedPlayer.jumpForce);
	choosedPlayer.momentumJumpForce = scr_statitstic("Speed Additional Jump Height",  choosedPlayer.momentumJumpForce);
	choosedPlayer.gravitation= scr_statitstic("Gravity",  choosedPlayer.gravitation);
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
	
	ImGui.Separator();
	
	scr_keyPresets(choosedPlayer);
	
	choosedPlayer.rightKey = scr_keyBinding(choosedPlayer.rightKey, "Right Key", isRightKeyBindingOn, "isRightKeyBindingOn");
	choosedPlayer.leftKey = scr_keyBinding(choosedPlayer.leftKey, "Left Key", isLeftKeyBindingOn, "isLeftKeyBindingOn");
	choosedPlayer.upKey = scr_keyBinding(choosedPlayer.upKey, "Up Key", isUpKeyBindingOn, "isUpKeyBindingOn");
	choosedPlayer.downKey = scr_keyBinding(choosedPlayer.downKey, "Down Key", isDownKeyBindingOn, "isDownKeyBindingOn");
	choosedPlayer.jumpKey = scr_keyBinding(choosedPlayer.jumpKey, "Jump Key", isJumpKeyBindingOn, "isJumpKeyBindingOn");
	choosedPlayer.interactionKey = scr_keyBinding(choosedPlayer.interactionKey, "Interaction Key", isInteractionKeyBindingOn, "isInteractionKeyBindingOn");
	
	ImGui.End();
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (keyboard_check_pressed(ord("R")))
{
	game_restart();
}