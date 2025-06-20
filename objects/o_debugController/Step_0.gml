if (!hide)
{	
	if (currentTab == 3)			
	{
		if (ImGui.Begin("DialogMain",, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoBringToFrontOnFocus))
		{							
			scr_dialogLogic();
	
			scr_dialogNodes();
		}	
		ImGui.End();
	}
	else
	{
		scr_placeHolder();
	}
	
	if (ImGui.Begin("Debug",, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoBringToFrontOnFocus))
	{
		currentTab = 0;
	
		scr_gameOptions();
		scr_cameraControll();
		
		gameLanguage = ImGui.InputText("Language", gameLanguage);
		
		scr_objectsInspector();
		
		RENDER_QUALITY = ImGui.InputFloat("Quality", RENDER_QUALITY);
		RENDER_FIDELITY = ImGui.InputFloat("Fidelity", RENDER_FIDELITY);
		
		if (ImGui.Button(":D"))
		{
			ImGui.__Shutdown();
			instance_destroy();
			return;
		}
        
        if (ImGui.Button(":DD"))
		{
            var sum = 0;
            with(o_collision)
            {
                if (model == undefined)
                {
                    sum++;
                }
            }
            log(string("With model: {0}", instance_number(o_collision) - sum));
            log(string("Without model: {0}", sum));
        }
        
        if (keyboard_check_pressed(vk_f3))
        {
            debug_input_record(debug_input_filter_keyboard);
        }
        
        if (keyboard_check_pressed(vk_f4))
        {
            debug_input_save(get_project_path() + "input.data");
        }
        
        if (keyboard_check_pressed(vk_f5))
        {
            debug_input_playback(get_project_path() + "input.data");
        }
			
		scr_logsOptions();
	}
	ImGui.End();

	if (ImGui.Begin("Edit",, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoBringToFrontOnFocus))
	{
		currentTab = 1;
		
		scr_editorLogic();
		
		scr_gameOptions();
		scr_editorOptions();
		scr_objectsInspector();
		scr_logsOptions();
	}
	ImGui.End();

	if (ImGui.Begin("Game",, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoBringToFrontOnFocus))
	{	
	    currentTab = 2;

	    scr_gameOptions();
	    scr_playerData();
		scr_skills();
	    scr_gameRules();
	    scr_logsOptions();
	}
	ImGui.End();
	
	if (ImGui.Begin("Dialog",, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoBringToFrontOnFocus))
	{	
	    currentTab = 3;

		if (dialog != undefined)
		{
			dialog.logic();
		}

	    scr_gameOptions();
		scr_dialogBoxEditor();
		scr_dialogNavigation()
		scr_accentsEditor();
		scr_dialogDictionaryEditor();
	    scr_logsOptions();
	}
	ImGui.End();
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
	ImGui.End();

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
	
	if (currentTab == 3)
	{		
		view_set_visible(0, false);
		view_set_visible(1, true);
		view_set_visible(2, false);
	}
	
	previousTab = currentTab;
}

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (keyboard_check_pressed(vk_f1))
{
	hide = !hide;
	previousTab = -1;
}

if (global.debugEdit)
{
	if (place_meeting(x, y, o_collision))
	{
		instance_destroy();
	}
}