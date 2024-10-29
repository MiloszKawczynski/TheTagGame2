if (ImGui.Begin("Debug"))
{
	currentTab = 0;
	
	scr_gameOptions();
	
	scr_cameraControll();
	
	scr_logs();
	
	ImGui.End();
}

if (ImGui.Begin("Edit"))
{
	currentTab = 1;
		
	scr_editorLogic();
	
	scr_gameOptions();
	
	scr_editorOptions();
	
	scr_logs();
			
	ImGui.End();
}

if (ImGui.Begin("Players Data"))
{
	currentTab = 2;
	
	scr_playerData();
}

scr_docking();

if (currentTab != previousTab)
{
	if (currentTab == 0 or currentTab == 2)
	{
		global.debugEdit = false;
			
		view_set_visible(0, true);
		view_set_visible(1, false);
		view_set_visible(2, false);
	}
	
	if (currentTab == 1)
	{
		global.debugEdit = true;
			
		view_set_visible(0, false);
		view_set_visible(1, true);
		view_set_visible(2, false);
	}
	
	previousTab = currentTab;
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (keyboard_check_pressed(ord("R")))
{
	room_restart();
}