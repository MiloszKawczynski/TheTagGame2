if (global.debugEdit)
{
	draw_sprite(s_start, linkToPlayer, x, y);
}
else 
{
	shader_set(shd_defaultReplaceWhite);
	
	var color = c_white;
	
	if (instance_exists(o_gameManager))
	{
		if (array_length(o_gameManager.players) > linkToPlayer)
		{
			color = o_gameManager.players[linkToPlayer].instance.color;	
		}
	}
	
	RenderPipeline.default_world_shader_set(RenderPipeline.uniReplace);
	
	shader_set_uniform_f_array(colorUniform, 
		[color_get_red(color) / 255,
		color_get_green(color) / 255,
		color_get_blue(color) / 255]
	)
	
	fauxton_model_draw_override(model);
	
	shader_reset();
}