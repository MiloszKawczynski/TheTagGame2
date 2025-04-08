function scr_makeDrawCircle()
{
	var drawCircle = function()
	{
		var dir = 1 / 5;
		var points = o_gameManager.players[0].points;
		
		if (color == o_gameManager.players[1].instance.color)
		{
			dir = -1 / 5;
			points = o_gameManager.players[1].points;
		}
		
		draw_set_color(color);
		draw_sprite_ext(s_chaseBarCharacterCircle, 0, posX, posY, scaleX, scaleY, 0, color, 1);
		draw_sprite_ext(s_chaseBarCharacterCircle, 1, posX, posY, scaleX, scaleY, dir * current_time, color, 1); 
	}
	setDrawFunction(drawCircle);
	setColor(c_white);
}

function scr_makeStaminaBar()
{
	var drawStaminaBar = function()
	{					
		var widthBackground = 55;
		var heightBackground = 79;
		
		if (!surface_exists(surface))
		{
			surface = surface_create(widthBackground, heightBackground);
		}
		
		surface_set_target(surface);
	
		draw_clear_alpha(c_white, 0);
		
		var x1 = 0;
		var y1 = heightBackground * (1 - value);
		var x2 = x1 + widthBackground;
		var y2 = y1 + heightBackground;
		
		draw_sprite(s_staminaBar, 0, widthBackground / 2, heightBackground / 2);
		gpu_set_colorwriteenable(1, 1, 1, 0);
		draw_set_color(color);
		draw_rectangle(x1, y1, x2, y2, false);
		gpu_set_colorwriteenable(1, 1, 1, 1);
		draw_sprite(s_staminaBar, 1, widthBackground / 2, heightBackground / 2);
	
		surface_reset_target();
	
		draw_surface_ext(surface, posX, posY, scaleX, scaleY, 0, c_white, 1);
	}
	
	setDrawFunction(drawStaminaBar, 100, 100);
}

function scr_makeTimerBar()
{
	var drawTimerBar = function()
	{					
		var widthBackground = 797;
		var heightBackground = 151;
		
		if (!surface_exists(surface))
		{
			surface = surface_create(widthBackground, heightBackground);
		}
		
		surface_set_target(surface);
	
		draw_clear_alpha(c_white, 0);
		
		var x1 = 29;
		var y1 = 0;
		var x2 = x1 + (widthBackground - x1) * value;
		var y2 = y1 + heightBackground;
		
		draw_sprite(s_chaseBarTimer, 0, widthBackground / 2, heightBackground / 2);
		gpu_set_colorwriteenable(1, 1, 1, 0);
		var change = 50;
		var colorHueLeft = color_hue_change(o_ground.color, -change);
		var colorHueRight = color_hue_change(o_ground.color, change);
		draw_rectangle_color(x1, y1, x2, y2, colorHueLeft, colorHueRight, colorHueRight, colorHueLeft, false);
		
		gpu_set_texrepeat(true);
		draw_set_color(c_white);
		draw_set_alpha(0.25);
		var _tex = sprite_get_texture(s_chaseBarTimerTexture, 0);
		draw_primitive_begin_texture(pr_trianglestrip, _tex);
		
		var shift = -current_time / 2500;
		
		draw_vertex_texture(x1, y1, shift, 0);
		draw_vertex_texture(x2, y1, value + shift, 0);
		draw_vertex_texture(x1, y2, shift, 1);
		draw_vertex_texture(x2, y2, value + shift, 1);
		
		draw_primitive_end();
		gpu_set_texrepeat(false);
		
		draw_set_alpha(1);
		gpu_set_colorwriteenable(1, 1, 1, 1);
		draw_sprite(s_chaseBarTimer, 1, widthBackground / 2, heightBackground / 2);
	
		surface_reset_target();
	
		draw_surface_ext(surface, posX, posY, scaleX, scaleY, 0, c_white, 1);
	}
	
	setDrawFunction(drawTimerBar, 797, 151);
}