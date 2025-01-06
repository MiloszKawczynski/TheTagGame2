for(var i = 0; i < instance_number(o_char); i++)
{
	var char = instance_find(o_char, i);
	var dist = distance_to_object(char);
	var characterColor = char.color;

	if (dist < char.obstacleRange)
	{
		if (!surface_exists(surface))
		{
			with(o_char)
			{
				if (obstacleRange > other.maximumObstacleRange)
				{
					other.maximumObstacleRange = obstacleRange;
				}
			}
			
			surface = surface_create(maximumObstacleRange * 2, maximumObstacleRange * 2);
		}
		
		surface_set_target(surface);
			draw_clear_alpha(characterColor, 1);
			draw_set_color(characterColor);
			draw_circle(maximumObstacleRange, maximumObstacleRange, dist, false);
		surface_reset_target();
	
		shader_set(shd_obstacleRing)
		shader_set_uniform_f(circleRadius, dist / maximumObstacleRange);
			matrix_set(matrix_world, o_debugController.flat0Matrix);
				gpu_set_blendmode(bm_add);
					draw_surface(surface, x - maximumObstacleRange, y - maximumObstacleRange);
				gpu_set_blendmode(bm_normal);
			matrix_reset();
		shader_reset();
	}	
}