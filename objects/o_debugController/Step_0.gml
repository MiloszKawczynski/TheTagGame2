if (!o_gameManager.isGameOn and !hide)
{

	if (ImGui.Begin("Debug"))
	{
		currentTab = 0;
	
		scr_gameOptions();
		scr_cameraControll();
		scr_logsOptions();
	
		ImGui.End();
	}

	if (ImGui.Begin("Edit"))
	{
		currentTab = 1;
		
		scr_editorLogic();
		
		scr_gameOptions();
		scr_editorOptions();
		scr_logsOptions();
			
		ImGui.End();
	}

	if (ImGui.Begin("Game"))
	{	
	    currentTab = 2;

	    scr_gameOptions();
	    scr_playerData();
	    scr_gameRules();
	    scr_logsOptions();

	    ImGui.End();
	}
}
else
{
	ImGui.SetNextWindowPos(0, 0);
	ImGui.SetNextWindowSize(300, 150);
	ImGui.SetNextWindowBgAlpha(0.25);
	if (ImGui.Begin("Logs"))
	{	
		scr_logs();
	}
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

if (keyboard_check_pressed(vk_f1))
{
	hide = !hide;
	previousTab = -1;
}

if (o_gameManager.isGameOn and keyboard_check_pressed(ord("P")))
{
	o_gameManager.startStop();

	previousTab = -1;
}