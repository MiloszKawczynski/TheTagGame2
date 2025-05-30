alarm[0] = 2;

groundModel = fauxton_model_create_ext(s_tartanTexture, 0, 0, 0, 0, 0, 0, 1, 1, 0.1, c_white, 1);
color = make_color_rgb(58, 62, 93);

hue = false;

editor = function()
{
	color = ImGui.ColorEdit3("Color", color);
	hue = ImGui.Checkbox("Karuzela Kolorów", hue);
}

colorUniform = shader_get_uniform(shd_defaultReplaceWhite, "color");

sizeUniform = shader_get_uniform(shd_shadows, "size");
thickUniform = shader_get_uniform(shd_shadows, "thick");
uvsUniform = shader_get_uniform(shd_shadows, "uvs");