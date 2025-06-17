editor = function()
{
	AmbientColor = ImGui.ColorEdit3("Ambient", AmbientColor);
	SunColor = ImGui.ColorEdit3("Sun", SunColor);
	SunIntensity = ImGui.InputFloat("Intensitivity", SunIntensity);
	
	ImGui.DragFloat3("Sun Position", SunPosition, 0.01, -1, 1);
}

RENDER_QUALITY = 8;
RENDER_FIDELITY = 1;

fauxton_world_environment.sun_color = SunColor;
fauxton_world_environment.ambient_color = AmbientColor;
fauxton_world_environment.sun_intensity = SunIntensity;	
fauxton_world_environment.sun_pos = SunPosition;

var color_return = function(color)
{
    var r,g,b;
    r = color_get_red(color)/255;
    g = color_get_green(color)/255;
    b = color_get_blue(color)/255;
    var ret = array_create(3);
    ret = [ r, g, b];
    return ret;
}

acol = array_create(3);
scol = array_create(3);

acol = color_return(AmbientColor);
scol = color_return(SunColor);
