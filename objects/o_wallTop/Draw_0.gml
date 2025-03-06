if (!global.debugEdit and alarm[0] == -1 and topModel != undefined)
{
	shader_set(shd_defaultMetalic)
	RenderPipeline.default_world_shader_set();
	fauxton_model_draw_override(topModel);
	shader_reset();
}