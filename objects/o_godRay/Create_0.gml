godRaysSystem = part_system_copy(ps_godRays, 0);
godRaysType = part_type_copy(ps_godRays, 0);

part_system_automatic_draw(godRaysSystem, false);

godRaysSurface = undefined;

image_angle = 45;

editor = function()
{
	ImGui_position_2(x, y);
	
	image_angle = ImGui.DragFloat("Rotation", image_angle);
}