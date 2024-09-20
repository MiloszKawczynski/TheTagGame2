var sumX = 0;
var sumY = 0;
var highestDistanceBetweenPlayers = 0;

if (instance_number(o_char) > 1)
{
	with(o_char)
	{
		sumX += x;
		sumY += y;
	
		var distanceToFurthestPlayer = distance_to_object(instance_furthest(x, y, o_char))
	
		if (distanceToFurthestPlayer > highestDistanceBetweenPlayers)
		{
			highestDistanceBetweenPlayers = distanceToFurthestPlayer;
		}
	}

	x = sumX / instance_number(o_char);
	y = sumY / instance_number(o_char);

	if (global.debugAutoCamera)
	{
		Camera.Zoom = (highestDistanceBetweenPlayers / 450) * 1.25;
		Camera.Zoom = clamp(Camera.Zoom, 1, 20);
	}
}
else
{
	x = o_char.x;
	y = o_char.y;
	
	if (global.debugAutoCamera)
	{
		Camera.Zoom = 2;
	}
}