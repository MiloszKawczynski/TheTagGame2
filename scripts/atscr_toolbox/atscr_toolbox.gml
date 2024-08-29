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
			value = 0;
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

function path_create(points)
{
	var path = path_add();
	
	for(var i = 0; i < array_length(points); i += 2)
	{
		path_add_point(path, points[i], points[i + 1], 1);
	}
	
	return path;
}

function log(logMessage, color = c_white)
{
	var timeStamp = date_time_string(date_current_datetime());
	var fullLog = string(timeStamp + ": " + logMessage);
	var monitoredValue = "";
	monitoredValue += "x: " + string(o_char.x) + "\n";
	monitoredValue += "y: " + string(o_char.y) + "\n";
	monitoredValue += "Speed: " + string(o_char.speed) + "\n";
	monitoredValue += "HorizontalSpeed: " + string(o_char.horizontalSpeed) + "\n";
	monitoredValue += "VerticalSpeed: " + string(o_char.verticalSpeed) + "\n";
	monitoredValue += "IsGrounded: " + string(o_char.isGrounded) + "\n";
	monitoredValue += "MaximumSpeed: " + string(o_char.maximumSpeed) + "\n";
	monitoredValue += "CoyoteTime: " + string(o_char.coyoteTime) + "\n";
	monitoredValue += "JumpBuffor: " + string(o_char.jumpBuffor) + "\n";
	monitoredValue = string(monitoredValue);
	
	show_debug_message(fullLog);
	ds_list_add(o_debugController.logBuffor, fullLog);
	ds_list_add(o_debugController.logColor, color);
	ds_list_add(o_debugController.monitoredValue, monitoredValue);
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