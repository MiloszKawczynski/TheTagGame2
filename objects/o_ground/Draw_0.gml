if (!global.debugEdit and alarm[0] == -1)
{
	shader_set(shd_defaultGround);
	
	RenderPipeline.default_world_shader_set();
	
	shader_set_uniform_f_array(colorUniform, 
		[color_get_red(color) / 255,
		color_get_green(color) / 255,
		color_get_blue(color) / 255]
	)
	
	fauxton_model_draw_override(groundModel);
	shader_reset();
	
	shader_set(shd_shadows);
	shader_set_uniform_f(sizeUniform, texelW, texelH);
	shader_set_uniform_f(thickUniform, 8);
	shader_set_uniform_f(uvsUniform, uvs[0], uvs[1], uvs[2], uvs[3]);
	matrix_set(matrix_world, matrix_build(room_width / 2, room_height / 2, 0.11, 0, 0, 0, 1, 1, 1));
	draw_sprite(sprite_index, 0, 0, 0);
	matrix_reset();
	shader_reset();
}