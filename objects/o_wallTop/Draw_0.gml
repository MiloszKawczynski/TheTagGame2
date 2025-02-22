if (!global.debugEdit)
{
	shader_set(shd_defaultMetalic)
	RenderPipeline.default_world_shader_set();
	fauxton_model_draw_override(topModel);
	shader_reset();
}