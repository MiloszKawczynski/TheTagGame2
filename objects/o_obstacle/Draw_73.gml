var dist = distance_to_object(o_char);
if (dist < instance_nearest(x, y, o_char).obstacleRange)
{
	if (glow)
	{
		shader_set(shd_bloom)
		//shader_set_uniform_f(glowIntensityUniform, glowIntensity);
			//matrix_set(matrix_world, matrix);
				draw_set_color(c_red);
				//draw_set_alpha(lerp(0, 0.25, 1 - (dist / instance_nearest(x, y, o_char).obstacleRange)));
				draw_circle(x, y, dist, false);
				//draw_set_alpha(draw_get_alpha() + 0.1);
				//draw_circle(x, y, dist - 1, true);
				//draw_circle(x, y, dist + 1, true);
				//draw_set_alpha(draw_get_alpha() + 0.1);
				//draw_circle(x, y, dist - 2, true);
				//draw_circle(x, y, dist + 2, true);
			//matrix_reset();
		shader_reset();
	}
	else
	{
		matrix_set(matrix_world, o_debugController.flatMatrix);
			draw_set_color(c_red);
			draw_set_alpha(lerp(0, 0.25, 1 - (dist / instance_nearest(x, y, o_char).obstacleRange)));
			draw_circle(x, y, dist, false);
			//draw_set_alpha(draw_get_alpha() + 0.1);
			//draw_circle(x, y, dist - 1, true);
			//draw_circle(x, y, dist + 1, true);
			//draw_set_alpha(draw_get_alpha() + 0.1);
			//draw_circle(x, y, dist - 2, true);
			//draw_circle(x, y, dist + 2, true);
		matrix_reset();
	}
	
	draw_set_alpha(1);
}