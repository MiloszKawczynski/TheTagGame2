function scr_bake()
{
	scr_bakeTopWall();
	scr_bakeShadow();
}

function scr_bakeTopWall()
{
	var topWallMask = surface_create(1600, 896);
	surface_set_target(topWallMask);
	draw_clear_alpha(c_white, 0);
	draw_set_alpha(0.0001);
	draw_point_color(0, 0, c_white);
	draw_point_color(1600, 896, c_white);
	draw_set_alpha(1);
	with(o_collision)
	{
		if (sprite_index != s_cubeCageZero)
		{
			draw_sprite_ext(sprite_index, image_number - 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
		}
	}
	surface_reset_target();
	surface_save(topWallMask, PROJECT_DIR + "/topWallMask_" + global.gameLevelName + ".png");
}

function scr_bakeShadow()
{
	var topWallMask = surface_create(1600, 896);
	surface_set_target(topWallMask);
	draw_clear_alpha(c_white, 0);
	draw_set_alpha(0.0001);
	draw_point_color(0, 0, c_white);
	draw_point_color(1600, 896, c_white);
	draw_set_alpha(1);
	with(o_collision)
	{
		if (sprite_index != s_cubeCageZero)
		{
			draw_sprite_ext(sprite_index, image_number - 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
		}
		else 
		{
			draw_sprite_ext(s_cubeCage, image_number - 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
		}
	}
	surface_reset_target();
	surface_save(topWallMask, PROJECT_DIR + "/shadowMask_" + global.gameLevelName + ".png");
}