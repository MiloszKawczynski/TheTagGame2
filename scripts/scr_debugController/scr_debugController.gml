function scr_statitstic(name, value)
{
	var width = 400;
	var label_width = 150;
	var input_width = 50;
	var spacing = 10;
	
	ImGui.Text(name + ":"); ImGui.SameLine();
	ImGui.SetCursorPosX(width - input_width - spacing);
	ImGui.SetNextItemWidth(input_width);
	return ImGui.InputFloat("##" + string_replace_all(name, " ", ""), value);
}

function scr_gravitationChange()
{
	if (global.debugIsGravityOn)
	{		
		Camera.Pitch = 130;
		Camera.Angle = 90;
	}
	else
	{
		Camera.Pitch = 50;
		Camera.Angle = 80;
	}
}

function scr_keyBinding(key, keyName, isKeyBindingOn, varName)
{	
	if (isKeyBindingOn)
	{
		keyName = "---";
	}
	
	var label_width = 150;
	
	if (ImGui.Button(keyName, label_width))
	{	
		variable_instance_set(self, varName, true);
	}
	ImGui.SameLine();
	ImGui.Dummy(100, 0);
	ImGui.SameLine();
	ImGui.Text(getKeyName(key));

	if (isKeyBindingOn and keyboard_check_pressed(vk_anykey))
	{
		variable_instance_set(self, varName, false);
		return keyboard_lastkey;
	}
	
	return key;
}

function scr_keyPresets(choosedPlayer)
{
	if (ImGui.Button("WSAD"))
	{
		choosedPlayer.rightKey = ord("D");
		choosedPlayer.leftKey = ord("A");
		choosedPlayer.upKey = ord("W");
		choosedPlayer.downKey = ord("S");
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("^v<>"))
	{
		choosedPlayer.rightKey = vk_right;
		choosedPlayer.leftKey = vk_left;
		choosedPlayer.upKey = vk_up;
		choosedPlayer.downKey = vk_down;
	}
	
	ImGui.SameLine();
	
	if (ImGui.Button("HUJK"))
	{
		choosedPlayer.rightKey = ord("K");
		choosedPlayer.leftKey = ord("H");
		choosedPlayer.upKey = ord("U");
		choosedPlayer.downKey = ord("J");
	}
}