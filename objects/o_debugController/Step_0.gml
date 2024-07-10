ImGui.SetNextWindowSize(200, 400, ImGuiCond.Once);

var isMouseInputPossible = false;
var step = false;

if (ImGui.Begin("Debug")) 
{	
	var buttonGameModeName;
	if (global.debugIsGravityOn) {buttonGameModeName = "Top-Down";} else {buttonGameModeName = "Platformer";}
	if(ImGui.Button(buttonGameModeName))
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		Camera.Angle = 90;
		
		if (global.debugIsGravityOn)
		{		
			Camera.Pitch = 130;
		}
		else
		{
			Camera.Pitch = 50;
		}
	}
	
	ImGui.Text(string("hSpeed: {0}", o_char.horizontalSpeed));
	ImGui.Text(string("vSpeed: {0}", o_char.verticalSpeed));
	
	ImGui.Separator();

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
	
	ImGui.End();
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}