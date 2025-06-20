function animcurve_get_point(curve_id, channel_id, pointx)
{
	return animcurve_channel_evaluate(animcurve_get_channel(curve_id, channel_id), pointx);
}

function armez_timer(value, step = 0.1, maxValue = 1)
{
	if (step > 0)
	{
		value += step;
		if (value > maxValue)
		{
			value = maxValue;
		}
	}
	else if (step < 0)
	{
		value += step;
		if (value < 0)
		{
			value = 0;
		}
	}
			
	return value;
}

function draw_ribbon(path, width, precision = 0.01, cutStart = 0, cutEnd = 1)
{
	draw_primitive_begin(pr_trianglestrip);
	
	for(var i = cutStart; i < cutEnd; i += precision)
	{	
		var px = path_get_x(path, i);
		var py = path_get_y(path, i);
		
		var nx = path_get_x(path, i + precision);
		var ny = path_get_y(path, i + precision);
		
		var dir = point_direction(px, py, nx, ny) + 90;
		
		var vx = lengthdir_x(width / 2, dir);
		var vy = lengthdir_y(width / 2, dir);
		
		draw_vertex(px + vx, py + vy);
		draw_vertex(px - vx, py - vy);
	}
	
	draw_primitive_end();
}

function draw_ribbon_color(path, width, col1, col2, precision = 0.01, cutStart = 0, cutEnd = 1)
{
	draw_primitive_begin(pr_trianglestrip);
	
	for(var i = cutStart; i < cutEnd; i += precision)
	{	
		var px = path_get_x(path, i);
		var py = path_get_y(path, i);
		
		var nx = path_get_x(path, i + precision);
		var ny = path_get_y(path, i + precision);
		
		var dir = point_direction(px, py, nx, ny) + 90;
		
		var vx = lengthdir_x(width / 2, dir);
		var vy = lengthdir_y(width / 2, dir);
		
		draw_vertex_color(px + vx, py + vy, col1, 1);
		draw_vertex_color(px - vx, py - vy, col2, 1);
	}
	
	draw_primitive_end();
}

function draw_ribbon_texture(path, width, texture, movingSpeed = 1, precision = 0.01, cutStart = 0, cutEnd = 1)
{
	var textureFlip = 0;
	gpu_set_texrepeat(true);
	
	var _tex = sprite_get_texture(texture, 0);
	var _texHeight = sprite_get_height(texture);
	draw_primitive_begin_texture(pr_trianglestrip, _tex);
	
	for(var i = cutStart; i < cutEnd; i += precision)
	{	
		var px = path_get_x(path, i);
		var py = path_get_y(path, i);
		
		var nx = path_get_x(path, i + precision);
		var ny = path_get_y(path, i + precision);
		
		var dir = point_direction(px, py, nx, ny) + 90;
		
		var vx = lengthdir_x(width, dir);
		var vy = lengthdir_y(width, dir);
		
		var offset = ((current_time / 10) / 60 * movingSpeed) mod 1 - 1;
		
		var textureHeight = (i * path_get_length(path) / width);
		
		draw_vertex_texture(px + vx, py + vy, -0.5, (textureHeight - offset));
		draw_vertex_texture(px - vx, py - vy, 1.5, (textureHeight - offset));
		
		textureFlip = !textureFlip;
	}
	
	draw_primitive_end();
	gpu_set_texrepeat(false);
}

function path_create(points, closed = false, smoothe = false)
{
	var path = path_add();
	path_set_closed(path, closed);
	path_set_kind(path, smoothe);
	
	for(var i = 0; i < array_length(points); i += 2)
	{
		path_add_point(path, points[i], points[i + 1], 1);
	}
	
	return path;
}

function log(logMessage, color = c_white)
{
	var timeStamp = date_time_string(date_current_datetime());
	var fullLog = string(timeStamp + ": " + string(logMessage));
	var monitoredValue = "";
	
	show_debug_message(fullLog);
	if (instance_exists(o_debugController))
	{
		ds_list_add(o_debugController.logBuffor, fullLog);
		ds_list_add(o_debugController.logColor, color);
		ds_list_add(o_debugController.monitoredValue, monitoredValue);
	}
}

function closerTo(targetValue, value1, value2)
{
	var value1Distance = abs(targetValue - value1);
	var value2Distance = abs(targetValue - value2);
	
	if (value1Distance < value2Distance)
	{
		return value1;
	}
	else
	{
		return value2;
	}
}

function getKeyName(keyCode)
{
	switch(keyCode)
	{
	    case -1: return "No Key";
	    case 8: return "Backspace";
	    case 9: return "Tab";
	    case 13: return "Enter";
	    case 16: return "Shift";
	    case 17: return "Ctrl";
	    case 18: return "Alt";
	    case 19: return "Pause/Break";
	    case 20: return "CAPS";
	    case 27: return "Esc";
	    case 32: return "Space";
	    case 33: return "Page Up";
	    case 34: return "Page Down";
	    case 35: return "End";
	    case 36: return "Home";
	    case 37: return "Left Arrow";
	    case 38: return "Up Arrow";
	    case 39: return "Right Arrow";
	    case 40: return "Down Arrow";
	    case 45: return "Insert";
	    case 46: return "Delete";
	    case 96: return "Numpad 0";
	    case 97: return "Numpad 1";
	    case 98: return "Numpad 2";
	    case 99: return "Numpad 3";
	    case 100: return "Numpad 4";
	    case 101: return "Numpad 5";
	    case 102: return "Numpad 6";
	    case 103: return "Numpad 7";
	    case 104: return "Numpad 8";
	    case 105: return "Numpad 9";
	    case 106: return "Numpad *";
	    case 107: return "Numpad +";
	    case 109: return "Numpad -";
	    case 110: return "Numpad .";
	    case 111: return "Numpad /";
	    case 112: return "F1";
	    case 113: return "F2";
	    case 114: return "F3";
	    case 115: return "F4";
	    case 116: return "F5";
	    case 117: return "F6";
	    case 118: return "F7";
	    case 119: return "F8";
	    case 120: return "F9";
	    case 121: return "F10";
	    case 122: return "F11";
	    case 123: return "F12";
	    case 144: return "Num Lock";
	    case 145: return "Scroll Lock";
	    case 160: return "Left Shift";
	    case 161: return "Right Shift";
	    case 162: return "Left Ctrl";
	    case 163: return "Right Ctrl";
	    case 186: return ";";
	    case 187: return "=";
	    case 188: return ",";
	    case 189: return "-";
	    case 190: return ".";
	    case 191: return "\\";
	    case 192: return "`";
	    case 219: return "/";
	    case 220: return "[";
	    case 221: return "]";
	    case 222: return "'";
	}
	
	return chr(keyCode);
}

function array_clear(array)
{
	array_delete(array, 0, array_length(array));
}

function color_hue_change(color, change)
{
	return make_color_hsv(color_get_hue(color) + change, color_get_saturation(color), color_get_value(color));
}

function color_saturation_change(color, change)
{
	return make_color_hsv(color_get_hue(color), color_get_saturation(color) + change, color_get_value(color));
}

function color_value_change(color, change)
{
	return make_color_hsv(color_get_hue(color), color_get_saturation(color), color_get_value(color) + change);
}