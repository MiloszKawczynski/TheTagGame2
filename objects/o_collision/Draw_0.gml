if (global.debugEdit)
{
	draw_sprite_ext(sprite_index, image_number - 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
}
else
{
	if (model != undefined and (!global.createStaticBuffers and !global.loadStaticBuffers))
	{
		shader_set(shd_defaultMetalic);
		RenderPipeline.default_world_shader_set();
		fauxton_model_draw_override(model);
		shader_reset();
	}
}