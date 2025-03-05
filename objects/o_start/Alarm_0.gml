if (instance_number(o_start) == 2)
{
	var otherStart = instance_furthest(x, y, o_start);
	var lightX = (x + otherStart.x) / 2;
	var lightY = (y + otherStart.y) / 2;
	
	var light = instance_create_layer(lightX, lightY, "level", o_spotLight);
	light.range = point_distance(x, y, lightX, lightY) * 4;
	light.cutoff_angle = 20;
	light.z = 60;
	light.angle = point_direction(lightX, lightY, x, y);
	light.z_angle = -radtodeg(arctan(light.z / point_distance(x, y, lightX, lightY)));
	light.color = merge_color(o_gameManager.players[linkToPlayer].instance.color, c_white, 0.5);
}