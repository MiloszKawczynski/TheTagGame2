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
		
		if (ImGui.Button("Spawn Node"))
		{
			ds_list_add(allDialogNodes, new dialogNode(500, 500));
		}
		
		sizePercent = ImGui.InputFloat("Size %", sizePercent);

		if (ImGui.Button("Copy % of Width"))
		{
			clipboard_set_text(camera_get_view_width(view_camera[0]) * (sizePercent / 100));
		}
		
		ImGui.SameLine();
		
		if (ImGui.Button("Copy % of Height"))
		{
			clipboard_set_text(camera_get_view_height(view_camera[0]) * (sizePercent / 100));
		}
		
		ImGui.InputInt2("Dialog Position", dialogPosition);
		ImGui.InputInt2("Dialog Size", dialogSize);
		ImGui.InputInt2("Text Position", dialogTextPosition);
		ImGui.InputInt2("Portrait Position", dialogPortraitPosition);
		dialog.width = ImGui.InputInt("Width", dialog.width);
		dialog.lines = ImGui.InputInt("Lines", dialog.lines);
		
		ImGui.Separator();
		
		if (selectedNode != undefined)
		{
			ImGui.BeginDisabled(selectedNode.in == undefined);
		}
		else
		{
			ImGui.BeginDisabled(true);
		}
		
		if (ImGui.Button("<- Prev"))
		{
			selectedNode = selectedNode.in;
			scr_centerNode();
		}
		
		ImGui.EndDisabled();
		
		ImGui.SameLine();
		
		if (selectedNode != undefined)
		{
			ImGui.BeginDisabled(selectedNode.out == undefined);
		}
		else
		{
			ImGui.BeginDisabled(true);
		}
		
		if (ImGui.Button("Next ->"))
		{
			selectedNode = selectedNode.out;
			scr_centerNode();
		}
		
		ImGui.EndDisabled();
		
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