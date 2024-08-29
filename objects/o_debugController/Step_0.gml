ImGui.SetNextWindowSize(300, 700, ImGuiCond.Once);

var isMouseInputPossible = false;
var step = false;

if (ImGui.Begin("Debug")) 
{	
	ImGui.Text("Game");
	
	var buttonGameModeName;
	if (global.debugIsGravityOn) {buttonGameModeName = "Top-Down";} else {buttonGameModeName = "Platformer";}
	if(ImGui.Button(buttonGameModeName))
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		
		if (global.debugIsGravityOn)
		{		
			Camera.Pitch = 130;
			Camera.Angle = 90;
		}
		else
		{
			Camera.Pitch = 50;
			Camera.Angle = 90;
		}
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
	ImGui.PopStyleColor(1);
	
	if (ImGui.Button("Clea")) 
	{
		 isStatsOpen = true;
	}
	
	ImGui.Separator();
	ImGui.Text("Camera");

	ImGui.Dummy(19, 0);
	ImGui.SameLine();
	if (ImGui.ArrowButton("Pitch +", 2)) {Camera.Pitch += 10};
	
	if (ImGui.ArrowButton("Angle +", 0)) {Camera.Angle += 10};
	ImGui.SameLine();
	if (ImGui.ArrowButton("Pitch -", 3)) {Camera.Pitch -= 10};
	ImGui.SameLine();
	if (ImGui.ArrowButton("Angle -", 1)) {Camera.Angle -= 10};
	
	ImGui.Text(string("Angle: {0}", Camera.Angle));
	ImGui.Text(string("Pitch: {0}", Camera.Pitch));
	ImGui.Text(string("Zoom: {0}", Camera.Zoom));
	
	ImGui.Separator();
	
	if (ImGui.Button("Clear"))
	{
		ds_list_clear(logBuffor);
		ds_list_clear(monitoredValue);
		o_char.diagonalCounter = 0;
	}
	ImGui.SameLine();
	if (ImGui.Button("Log!"))
	{
		log("Log!");
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
	ImGui.Text(string("Diagonal Coutner: {0}", o_char.diagonalCounter));
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
	
	ImGui.End();
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (mouse_check_button_pressed(mb_right))
{
	//var dir = point_direction(o_char.x, o_char.y, window_mouse_get_x(), window_mouse_get_y());
	//o_char.x = window_mouse_get_x();
	//o_char.y = window_mouse_get_y();
	////o_char.x += lengthdir_x(32, dir);
	////o_char.y += lengthdir_y(32, dir);
}