if (!global.debugEdit)
{
	if (global.debugIsGravityOn)
	{
		draw_sprite_3d(sprite_index, image_index, x, y, 16, 0, 0, 0, image_xscale, 1, 1, true);
	}
	else
	{
		draw_sprite_3d(sprite_index, image_index, x, y, 16, Camera.Pitch, 0, 90 - Camera.Angle, image_xscale, 1, 1, false);
	}
}

if (canCaught)
{
	var dist = distance_to_object(nearestPlayer);
	
	if (!surface_exists(surface))
	{
		surface = surface_create(maximumCaughtRange * 2, maximumCaughtRange * 2);	
	}
		
	surface_set_target(surface);
		draw_clear_alpha(color, 1);
		draw_set_color(color);
		draw_circle(maximumCaughtRange, maximumCaughtRange, dist, false);
	surface_reset_target();
	
	shader_set(shd_obstacleRing)
	shader_set_uniform_f(circleRadius, dist / maximumCaughtRange);
		matrix_set(matrix_world, o_debugController.flat0Matrix);
			draw_surface(surface, x - maximumCaughtRange, y - maximumCaughtRange);
		matrix_reset();
	shader_reset();
}