if (!global.debugEdit)
{
	shader_set(shd_defaultLed);
	RenderPipeline.default_world_shader_set();
	shader_set_uniform_f_array(modelPositionUniform, [x, y]);
	shader_set_uniform_f(timeUniform, current_time);
	shader_set_uniform_f_array(ledUniform, leds[frame + offset]);
	shader_set_uniform_f_array(colorUniform, 
		[color_get_red(color) / 255,
		color_get_green(color) / 255,
		color_get_blue(color) / 255]
	)
	fauxton_model_draw_override(model);
	shader_reset();
}