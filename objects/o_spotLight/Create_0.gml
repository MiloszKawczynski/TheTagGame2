event_inherited();

follow = false;
draw = false;

editor = function()
{
	ImGui_position_3()
	color = ImGui.ColorEdit3("Color", color);
	range = ImGui.DragFloat("Range", range);
	cutoff_angle = ImGui.DragFloat("Cutoff", cutoff_angle);
	angle = ImGui.DragFloat("Angle", angle);
	z_angle = ImGui.DragFloat("Z Angle", z_angle);
	follow = ImGui.Checkbox("follow", follow);
	draw = ImGui.Checkbox("draw", draw);
}