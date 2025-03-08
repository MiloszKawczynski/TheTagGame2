if (!o_gameManager.isGameOn and !hide)
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
		
		if (!isBindingFinilize)
		{
			if (firstFreePlayer < 2)
			{
				var doesAnyoneJoin = false;
				
				if (input_check_pressed("joinP1", 10))
				{ 
					input_source_set(INPUT_KEYBOARD, firstFreePlayer,, false);
					input_profile_set("P1", firstFreePlayer);	
					firstFreePlayer++;
				}
				
				if (input_check_pressed("joinP2", 10))
				{ 
					input_source_set(INPUT_KEYBOARD, firstFreePlayer,, false);
					input_profile_set("P2", firstFreePlayer);
					firstFreePlayer++;
				}
				
				for (var i = 0; i < 4; i++)
				{
					if (input_source_detect_input(INPUT_GAMEPAD[i]))
					{
						input_source_set(INPUT_GAMEPAD[i], firstFreePlayer,, false);
						firstFreePlayer++;
					}
				}
			}
			
			for(var i = firstFreePlayer - 1; i >= 0; i--)
			{
				if (input_check_pressed("leave", i))
				{
					input_source_clear(i);
					firstFreePlayer = i;
					break;
				}
				
				if (input_check_long_pressed("interactionKey", i) and firstFreePlayer >= 2)
				{
					isBindingFinilize = true;
					break;
				}
			}
			
			while(input_source_using(INPUT_KEYBOARD, firstFreePlayer) or input_source_using(INPUT_GAMEPAD, firstFreePlayer))
			{
				firstFreePlayer++;
			}
		}
		
		for(var i = 0; i < 2; i++)
		{
			var color = c_white;
			
			if (isBindingFinilize)
			{
				color = c_lime;
			}
			
			if (i == firstFreePlayer)
			{
				ImGui.TextColored(string(">>> player {0} - {1}", i, input_player_connected(i)), color);
			}
			else 
			{
				ImGui.TextColored(string("player {0} - {1}", i, input_player_connected(i)), color);
			}
		}
		
		RENDER_QUALITY = ImGui.InputFloat("Quality", RENDER_QUALITY);
		
		if (ImGui.Button(":D"))
		{
			ImGui.__Shutdown();
			instance_destroy();
			return;
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

if (o_gameManager.isGameOn and keyboard_check_pressed(ord("P")))
{
	o_gameManager.startStop();

	previousTab = -1;
}