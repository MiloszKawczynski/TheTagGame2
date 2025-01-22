editor = function()
{
	AmbientColor = ImGui.ColorEdit3("Ambient", AmbientColor);
	SunColor = ImGui.ColorEdit3("Sun", SunColor);
	SunIntensity = ImGui.InputFloat("Intensitivity", SunIntensity);
	
	ImGui.DragFloat3("Sun Position", SunPosition, 0.01, -1, 1);
}

RENDER_QUALITY = 8;