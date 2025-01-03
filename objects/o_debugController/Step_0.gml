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
		
		ImGui.Separator();
		
		if (selectedObject != undefined)
		{
			if (variable_instance_exists(selectedObject, "editor"))
			{
				selectedObject.editor();
			}
			else
			{
				ImGui.TextColored("This object doesn't have editor!", c_red);
			}
		}
		
		ImGui.Separator();
		
		objectName = ImGui.InputText("Object name: ", objectName);
	
		if (ImGui.Button("Search objects"))
		{
			array_delete(editableObjects, 0, array_length(editableObjects));
			
			for (var i = 0; i < instance_number(all); i++) 
			{
				var inst = instance_find(all, i);
				
				if (!string_count(objectName, object_get_name(inst.object_index)))
				{
					continue;
				}
				
				array_push(editableObjects, inst);
			}
		}
		
		for (var i = 0; i < array_length(editableObjects); i++) 
		{
			var inst = editableObjects[i];
			var name = string("{0}_{1}", object_get_name(inst.object_index), inst.id);
			
			if (!variable_instance_exists(inst, "editor"))
			{
				continue;
			}
		
			if (ImGui.Selectable(name, selectedObject == inst)) 
			{
				selectedObject = inst;
			}
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