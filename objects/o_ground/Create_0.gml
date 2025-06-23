//alarm[0] = 2;

groundModel = fauxton_model_create_ext(s_tartanTexture, 0, 0, 0, 0, 0, 0, room_width / 1600, room_height / 896, 0.1, c_white, 1);
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

sprite_index = s_shadowMask;

if (global.gameLevelName != "")
{
	var shadowMaskPath = get_project_path() + string("shadowMask_{0}.png", global.gameLevelName);

	shadowMapSprite = sprite_add(shadowMaskPath, 0, false, false, room_width / 2, room_height / 2);
	
	if (shadowMapSprite != -1)
	{
		sprite_index = shadowMapSprite;
	}
}

fauxton_model_draw_enable(groundModel, false);

texelW = texture_get_texel_width(sprite_get_texture(sprite_index, 0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index, 0));

uvs = sprite_get_uvs(sprite_index, 0);