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
	
	ImGui.Separator();
	ImGui.Text("Clea");
	
	ImGui.Text(string("x: {0}", o_char.x));
	ImGui.Text(string("y: {0}", o_char.y));
	ImGui.Text(string("Speed: {0}", o_char.speed));
	ImGui.Text(string("hSpeed: {0}", o_char.horizontalSpeed));
	ImGui.Text(string("vSpeed: {0}", o_char.verticalSpeed));
	ImGui.Text(string("isGrounded: {0}", o_char.isGrounded));
	ImGui.Text(string("maxSpeed: {0}", o_char.maximumSpeed));
	ImGui.Text(string("coyoteTime: {0}", o_char.coyoteTime));
	ImGui.Text(string("jumpBuffor: {0}", o_char.jumpBuffor));
	
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
	
	o_char.maximumDefaultSpeed = scr_statitstic("Default Speed",  o_char.maximumDefaultSpeed);
	o_char.acceleration = scr_statitstic("Acceleration",  o_char.acceleration);
	o_char.deceleration = scr_statitstic("Deceleration",  o_char.deceleration);
	o_char.maximumSpeedDecelerationFactor = scr_statitstic("Maximum Speed Deceleration Factor",  o_char.maximumSpeedDecelerationFactor);
	o_char.jumpForce = scr_statitstic("Jump Height",  o_char.jumpForce);
	o_char.momentumJumpForce = scr_statitstic("Speed Additional Jump Height",  o_char.momentumJumpForce);
	o_char.gravitation= scr_statitstic("Gravity",  o_char.gravitation);
	o_char.slopeAcceleration = scr_statitstic("Slope Acceleration",  o_char.slopeAcceleration);
	o_char.rampAcceleration = scr_statitstic("Ramp Acceleration",  o_char.rampAcceleration);
	o_char.maximumSlopeSpeed = scr_statitstic("Slope Deceleration",  o_char.maximumSlopeSpeed);
	o_char.maximumRampSpeed = scr_statitstic("Ramp Deceleration",  o_char.maximumRampSpeed);
	o_char.slopeSpeedTransitionFactor = scr_statitstic("Slope Speed Transition Factor",  o_char.slopeSpeedTransitionFactor);
	o_char.maximumCoyoteTime = scr_statitstic("Coyote Time",  o_char.maximumCoyoteTime);
	o_char.obstacleRange = scr_statitstic("Obstacle Range",  o_char.obstacleRange);
	o_char.minimumObstacleJumpForce = scr_statitstic("Minimum Obstacle Jump",  o_char.minimumObstacleJumpForce);
	o_char.maximumObstacleJumpForce = scr_statitstic("Maximum Obstacle Jump",  o_char.maximumObstacleJumpForce);
	o_char.maximumJumpBuffor = scr_statitstic("Maximum Jump Buffor",  o_char.maximumJumpBuffor);
	o_char.color = ImGui.ColorEdit3("Color", o_char.color);
	
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