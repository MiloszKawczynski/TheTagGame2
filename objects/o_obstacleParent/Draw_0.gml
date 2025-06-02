for(var i = 0; i < instance_number(o_char); i++)
{
	var char = instance_find(o_char, i);
	var dist = point_distance(x, y, char.x, char.y);
    var charDistance = char.obstacleRange;
    var charSurface = char.obstacleSurface;

	if (dist < charDistance or success > 0)
	{
		if (dist < charDistance)
		{
			characterColor = char.color;
		}
		
		surface_set_target(charSurface);
			draw_clear_alpha(characterColor, 1);
			draw_set_color(characterColor);
			draw_circle(charDistance, charDistance, dist, false);
		surface_reset_target();
	
		shader_set(shd_obstacleRing)
		shader_set_uniform_f(circleRadiusUniform, dist / charDistance);
		shader_set_uniform_f(directionUniform, point_direction(x, y, char.x, char.y));
		shader_set_uniform_f(successUniform, success);
			matrix_set(matrix_world, matrix_build(0, 0, z + 0.2, 0, 0, 0, 1, 1, 1));
			gpu_set_blendmode(bm_add);
				draw_surface(charSurface, x - charDistance, y - charDistance);
			gpu_set_blendmode(bm_normal);
			matrix_reset();
		shader_reset();
	}	
}