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