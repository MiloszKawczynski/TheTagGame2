if (live_call()) return live_result;

for(var i = 0; i < instance_number(o_char); i++)
{
	var char = instance_find(o_char, i);
	var dist = distance_to_object(char);
	var characterColor = char.color;

	if (dist < char.obstacleRange)
	{
		surface_set_target(surface);
			draw_clear_alpha(characterColor, 1);
			draw_set_color(characterColor);
			draw_circle(maximumObstacleRange, maximumObstacleRange, dist, false);
		surface_reset_target();
	
		shader_set(shd_obstacleRing)
		shader_set_uniform_f(circleRadius, dist / maximumObstacleRange);
			matrix_set(matrix_world, o_debugController.flat0Matrix);
				draw_surface(surface, x - maximumObstacleRange, y - maximumObstacleRange);
			matrix_reset();
		shader_reset();
	}	
}

shader_set(shd_default);
	fauxton_model_draw_override(model);
shader_reset();