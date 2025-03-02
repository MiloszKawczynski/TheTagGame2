event_inherited();

follow = false;
draw = false;

editor = function()
{
	ImGui_position_3()
	color = ImGui.ColorEdit3("Color", color);
	range = ImGui.DragFloat("Range", range);
	follow = ImGui.Checkbox("follow", follow);
	draw = ImGui.Checkbox("draw", draw);
}