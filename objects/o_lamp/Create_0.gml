event_inherited();

editor = function()
{
	if (ImGui.Button("Destroy"))
	{
		instance_destroy();
	}
}