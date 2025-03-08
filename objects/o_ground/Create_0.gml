alarm[0] = 2;

groundModel = fauxton_model_create_ext(s_tartanTexture, 0, 0, 0, 0, 0, 0, 0.5, 1, 0.1, c_white, 1);
groundModel2 = fauxton_model_create_ext(s_tartanTexture, 800, 0, 0, 0, 0, 0, 0.5, 1, 0.1, c_white, 1);
//color = make_color_hsv(random(255), 218, 160);
color = make_color_hsv(random(255), 218, 160);
color2 = make_color_hsv(color_get_hue(color), 218, 160);

hue = false;

editor = function()
{
	color = ImGui.ColorEdit3("Color", color);
	color2 = ImGui.ColorEdit3("Color2", color2);
	hue = ImGui.Checkbox("Karuzela Kolorów", hue);
}

colorUniform = shader_get_uniform(shd_defaultReplaceWhite, "color");

sizeUniform = shader_get_uniform(shd_shadows, "size");
thickUniform = shader_get_uniform(shd_shadows, "thick");
uvsUniform = shader_get_uniform(shd_shadows, "uvs");