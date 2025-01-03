godRaysSystem = part_system_copy(ps_godRays, 0);
godRaysType = part_type_copy(ps_godRays, 0);

part_system_automatic_draw(godRaysSystem, false);

godRaysSurface = undefined;

image_angle = 45;

isReflector = false;
intensivity = 0.6;

editor = function()
{
	ImGui_position_2(x, y);
	
	image_angle = ImGui.DragFloat("Rotation", image_angle);
	
	isReflector = ImGui.Checkbox("Reflector", isReflector);
	
	intensivity = ImGui.DragFloat("Intensivity", intensivity, 0.1, 0, 1);
}

intensivityUniform = shader_get_uniform(shd_godray, "intensivity");