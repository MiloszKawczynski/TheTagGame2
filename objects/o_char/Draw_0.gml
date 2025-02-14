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

for (var i = 0; i < ds_list_size(afterimageList); i++) 
{
	var order = ds_list_size(afterimageList) - i;
	
    var frame = ds_list_find_value(afterimageList, i);
	var uniform = function(i, color)
	{
		setAfterImageUniform(0.75 - (0.05 * i), color);
	}
	var arguments = [order, color];

	draw_sprite_3d_in_game(frame.spriteIndex, frame.imageIndex, frame.xx, frame.yy, 16 + z, 0, 0, 0, frame.xScale, 1, 1, shd_afterimage, uniform, arguments,, frame.rotation, frame._stretch, frame._squash);
}

if (!global.debugEdit)
{
	if (o_gameManager.whoIsChasing == player and o_gameManager.whoIsChasingStage == 2)
	{
		var uniformOultuneFunction = function(w, h, color)
		{
			setChasingOutlineUniform(w, h, color);
		}
		
		var arguments = [texture_get_texel_width(sprite_get_texture(sprite_index, image_index)), texture_get_texel_height(sprite_get_texture(sprite_index, image_index)), color];
		
		draw_sprite_3d_in_game(sprite_index, image_index, x, y, 16 + z, 0, 0, 0, image_xscale, 1, 1, shd_outline, uniformOultuneFunction, arguments,, angle, stretch, squash);
	}
	else 
	{
		draw_sprite_3d_in_game(sprite_index, image_index, x, y, 16 + z, 0, 0, 0, image_xscale, 1, 1,,,,, angle, stretch, squash);
	}
}

if (global.debugEdit)
{
	draw_self();
}