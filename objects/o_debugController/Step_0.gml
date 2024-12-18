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
		
		dialogOverImGui = ImGui.Checkbox("Dialog Over ImGui", dialogOverImGui);
		ImGui.InputInt2("Dialog Position", dialogPosition);
		ImGui.InputInt2("Dialog Size", dialogSize);
		ImGui.InputInt2("Text Position", dialogTextPosition);
		ImGui.InputInt2("Portrait Position", dialogPortraitPosition);
		dialogPortraitSpacing = ImGui.InputFloat("Portrait Spacing", dialogPortraitSpacing);
		dialogPortraitScale = ImGui.InputFloat("Portrait Scale", dialogPortraitScale);
		dialog.width = ImGui.InputInt("Width", dialog.width);
		dialog.lines = ImGui.InputInt("Lines", dialog.lines, 1);
		//dialog.baseSpeed = ImGui.InputInt("Base Speed", dialog.baseSpeed);
		dialog.fastSpeed = ImGui.InputInt("Fast Speed", dialog.fastSpeed, 0.25);
		
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
		
		ImGui.Separator();
		
		if (ImGui.CollapsingHeader("Accents"))
		{	
			for (var i = 0; i < ds_list_size(dialog.accentList); i++)
			{				
				var accent = ds_list_find_value(dialog.accentList, i);
			
				if (accent.isOpen)
				{
					ImGui.SetNextItemOpen(true);
					accent.isOpen = false;
				}
			
				if (ImGui.CollapsingHeader(accent.name + "##" + string(i)))
				{
					var newName = accent.name;
					newName = ImGui.InputText("name ## Accent" + string(i), newName);
				
					if (accent.name != newName)
					{
						accent.name = newName;
						accent.isOpen = true;
					}
				
					accent.color = ImGui.ColorEdit3("Color ## Accent" + string(i), accent.color);
					accent.textSpeed = ImGui.InputFloat("Speed ## Accent" + string(i), accent.textSpeed, 0.25);
					accent.markup = ImGui.InputText("Markup ## Accent" + string(i), accent.markup);
				
					accent.markup = string_char_at(accent.markup, 0);
				
					accent.hideMarkup = ImGui.Checkbox("Hide Markup ## Accent" + string(i), accent.hideMarkup);
				
					accent.isSdfEnable = ImGui.Checkbox("Enable SDF ## Accent" + string(i), accent.isSdfEnable);
				
					if (accent.isSdfEnable)
					{
						if (accent.sdfEffects == undefined)
						{
							accent.sdfEffects = 
							{
								coreColour: accent.color,
							
								outlineEnable: false,
								outlineDistance: 0,
								outlineColour: c_white,
								outlineAlpha: 0,
							
								glowEnable: false,
								glowStart: 0,
								glowEnd: 0,
								glowColour: c_white,
								glowAlpha: 0,
							
								dropShadowEnable: false,
								dropShadowSoftness: 0,
								dropShadowOffsetX: 0,
								dropShadowOffsetY: 0,
								dropShadowColour: c_black,
								dropShadowAlpha: 0
							}
						}
					
						accent.sdfEffects.coreColour = accent.color;
					
						ImGui.Separator();
					
						accent.sdfEffects.outlineEnable = ImGui.Checkbox("Outline ## Accent" + string(i), accent.sdfEffects.outlineEnable);
					
						if (accent.sdfEffects.outlineEnable)
						{
					
							accent.sdfEffects.outlineDistance = ImGui.InputFloat("Outline Distance ## Accent" + string(i), accent.sdfEffects.outlineDistance, 1)
							accent.sdfEffects.outlineDistance = clamp (accent.sdfEffects.outlineDistance, 0, 64);
						
							accent.sdfEffects.outlineColour = ImGui.ColorEdit3("Outline Color ## Accent" + string(i), accent.sdfEffects.outlineColour)
						
							accent.sdfEffects.outlineAlpha = ImGui.InputFloat("Outline Alpha ## Accent" + string(i), accent.sdfEffects.outlineAlpha, 0.25)
							accent.sdfEffects.outlineAlpha = clamp (accent.sdfEffects.outlineAlpha, 0, 1);
						}
					
						ImGui.Separator();
					
						accent.sdfEffects.glowEnable = ImGui.Checkbox("Glow ## Accent" + string(i), accent.sdfEffects.glowEnable);
					
						if (accent.sdfEffects.glowEnable)
						{
							ImGui.SetNextItemWidth(64);
							accent.sdfEffects.glowStart = ImGui.InputFloat("Glow Start ## Accent" + string(i), accent.sdfEffects.glowStart, 1)
							accent.sdfEffects.glowStart = clamp (accent.sdfEffects.glowStart, 0, 64);
						
							ImGui.SameLine();
						
							ImGui.SetNextItemWidth(64);
							accent.sdfEffects.glowEnd = ImGui.InputFloat("Glow End ## Accent" + string(i), accent.sdfEffects.glowEnd, 1)
							accent.sdfEffects.glowEnd = clamp (accent.sdfEffects.glowEnd, 0, 64);
						
							accent.sdfEffects.glowColour = ImGui.ColorEdit3("Glow Color ## Accent" + string(i), accent.sdfEffects.glowColour)
						
							accent.sdfEffects.glowAlpha = ImGui.InputFloat("Glow Alpha ## Accent" + string(i), accent.sdfEffects.glowAlpha, 0.25)
							accent.sdfEffects.glowAlpha = clamp (accent.sdfEffects.glowAlpha, 0, 1);
						}
					
						ImGui.Separator();
					
						accent.sdfEffects.dropShadowEnable = ImGui.Checkbox("Shadow ## Accent" + string(i), accent.sdfEffects.dropShadowEnable);
					
						if (accent.sdfEffects.dropShadowEnable)
						{
							accent.sdfEffects.dropShadowSoftness = ImGui.InputFloat("Shadow Softness ## Accent" + string(i), accent.sdfEffects.dropShadowSoftness, 1)
							accent.sdfEffects.dropShadowSoftness = clamp (accent.sdfEffects.dropShadowSoftness, 0, 64);
						
							ImGui.SetNextItemWidth(64);
							accent.sdfEffects.dropShadowOffsetX = ImGui.InputFloat("Shadow Offset x ## Accent" + string(i), accent.sdfEffects.dropShadowOffsetX, 1)
						
							ImGui.SameLine();
						
							ImGui.SetNextItemWidth(64);
							accent.sdfEffects.dropShadowOffsetY = ImGui.InputFloat("Shadow Offset y ## Accent" + string(i), accent.sdfEffects.dropShadowOffsetY, 1)
						
							accent.sdfEffects.dropShadowColour = ImGui.ColorEdit3("Shadow Color ## Accent" + string(i), accent.sdfEffects.dropShadowColour)
						
							accent.sdfEffects.dropShadowAlpha = ImGui.InputFloat("Shadow Alpha ## Accent" + string(i), accent.sdfEffects.dropShadowAlpha, 0.25)
							accent.sdfEffects.dropShadowAlpha = clamp (accent.sdfEffects.dropShadowAlpha, 0, 1);
						}
					}
				
					ImGui.Separator();
				
					accent.waveH.isEnable = ImGui.Checkbox("Horizontal Wave ## Accent" + string(i), accent.waveH.isEnable);
				
					if (accent.waveH.isEnable)
					{
						accent.waveH.waveSpeed = ImGui.InputFloat("Wave Speed ##H Accent" + string(i), accent.waveH.waveSpeed, 1);					
						accent.waveH.chanel = ImGui.InputInt("Wave Channel ##H Accent" + string(i), accent.waveH.chanel, 1);
						accent.waveH.chanel = clamp(accent.waveH.chanel , 0, array_length(animcurve_get(ac_dialogWaveX).channels) - 1);
					
						accent.waveH.sync = ImGui.Checkbox("Is Sync ##H Accent" + string(i), accent.waveH.sync);
						accent.waveH.factor = ImGui.InputFloat("Wave Factor ##H Accent" + string(i), accent.waveH.factor, 1);
					}
				
					ImGui.Separator();
				
					accent.waveV.isEnable = ImGui.Checkbox("Vertical Wave ##V Accent" + string(i), accent.waveV.isEnable);
				
					if (accent.waveV.isEnable)
					{
						accent.waveV.waveSpeed = ImGui.InputFloat("Wave Speed ##V Accent" + string(i), accent.waveV.waveSpeed, 1);
						accent.waveV.chanel = ImGui.InputInt("Wave Channel ##V Accent" + string(i), accent.waveV.chanel, 1);
						accent.waveV.chanel = clamp(accent.waveV.chanel , 0, array_length(animcurve_get(ac_dialogWaveY).channels) - 1);
					
						accent.waveV.sync = ImGui.Checkbox("Is Sync ##V Accent" + string(i), accent.waveV.sync);
						accent.waveV.factor = ImGui.InputFloat("Wave Factor ##V Accent" + string(i), accent.waveV.factor, 1);
					}
				
					if (ImGui.Button("Remove"))
					{
						ds_list_delete(dialog.accentList, i);
						i--;
					}
				}
			}
		
			if (ImGui.Button("Add Accent"))
			{
				ds_list_add(dialog.accentList, new dialog.dialogAccent("New Accent " + string(ds_list_size(dialog.accentList)), c_red, dialog.baseSpeed, "*"));
			}
		}
		
		ImGui.Separator();
		
		if (ImGui.CollapsingHeader("Dictionary"))
		{
			for (var i = 0; i < ds_list_size(dialog.dictionary); i++)
			{
				var entry = ds_list_find_value(dialog.dictionary, i);
				
				ImGui.SetNextItemWidth(100);
				entry.key = ImGui.InputText("key ##" + string(i), entry.key);
				ImGui.SameLine();
				ImGui.SetNextItemWidth(100);
				entry.value = ImGui.InputText("value ##" + string(i), entry.value);
				ImGui.SameLine();
				if (ImGui.Button("Delete ##" + string(i)))
				{
					ds_list_delete(dialog.dictionary, i);
					i--;
				}
				
			}
			
			if (ImGui.Button("Add entry to dictionary"))
			{
				ds_list_add(dialog.dictionary, new dialogDictionaryEntry(ds_list_size(dialog.dictionary), ""));
			}
		}
		
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