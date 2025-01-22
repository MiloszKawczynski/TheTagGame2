function scr_makeDraCircle()
{
	var drawCircle = function()
	{
		draw_set_color(color);
		draw_circle(posX, posY, 26.5, false);
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