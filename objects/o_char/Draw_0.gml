if (canCaught)
{
	thick = lerp(thick, 15, 0.1);
	glow = lerp(glow, 0.25, 0.2);
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
    if (slap)
    {
        armAngle = lerp(armAngle, 90, 0.2);
        
        if (abs(armAngle - 90) < 3)
        {
            slap = false;
            o_gameManager.caught();
        }
    }
    else 
    {
        if (canCaught)
        {
            armAngle = lerp(armAngle, -40, 0.1);
        }
        else 
        {
            armAngle = lerp(armAngle, 40, 0.1);
        }
    }
    
	if (o_gameManager.whoIsChasing == player and o_gameManager.whoIsChasingStage >= 2)
	{
		var uniformOultuneFunction = function(uvs, color, hand)
		{
			setChasingOutlineUniform(uvs, color, hand);
		}
		
		var arguments = [sprite_get_uvs(sprite_index, image_index), color, false];
		
		draw_sprite_3d_in_game(sprite_index, image_index, x, y, 16 + z, 0, 0, 0, image_xscale, 1, 1, shd_outline, uniformOultuneFunction, arguments,, angle, stretch, squash);
        
        var arguments = [sprite_get_uvs(s_cleaHand, 0), color, true];
        
        draw_sprite_3d_in_game(s_cleaHand, 0, x, y, 16 + z + 1, 0, 0, 0, image_xscale, 1, 1, shd_outline, uniformOultuneFunction, arguments,,  angle + armAngle, stretch, squash);
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