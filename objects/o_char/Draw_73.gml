if (global.debugEdit)
{
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, 1);
}

if (global.debugIsGravityOn)
{
	if (!surface_exists(runTrailSurface))
	{
		runTrailSurface = surface_create(1920, 1080);
	}
	
	surface_set_target(runTrailSurface);
		draw_clear_alpha(c_black, 0);
		part_system_drawit(runTrailSystem);
	surface_reset_target();
	
	matrix_set(matrix_world, o_debugController.characterMatrix);
		gpu_set_blendmode(bm_add);
			draw_surface(runTrailSurface, 0, 0);
		gpu_set_blendmode(bm_normal);
	matrix_reset();
}
else
{
	part_system_drawit(runTrailSystem);
}