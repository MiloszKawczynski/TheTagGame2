sprite_index = s_shadowMask;

if (o_debugController.gameLevelName != "")
{
	var shadowMaskPath = get_project_path() + string("shadowMask_{0}.png", o_debugController.gameLevelName);

	shadowMapSprite = sprite_add(shadowMaskPath, 0, false, false, 1600 / 2, 896 / 2);
	
	if (shadowMapSprite != -1)
	{
		sprite_index = shadowMapSprite;
	}
}

fauxton_model_draw_enable(groundModel, false);

texelW = texture_get_texel_width(sprite_get_texture(sprite_index, 0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index, 0));

uvs = sprite_get_uvs(sprite_index, 0);