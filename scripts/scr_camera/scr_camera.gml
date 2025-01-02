function scr_follow_one_character()
{
	x = o_char.x;
	y = o_char.y;
	
	if (global.debugAutoCamera and !global.debugEdit)
	{
		Camera.Zoom = 2;
	}
}

function scr_follow_many_characters()
{
	var sumX = 0;
	var sumY = 0;
	var highestDistanceBetweenPlayers = 0;
	
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

	if (global.debugAutoCamera and !global.debugEdit)
	{
		Camera.Zoom = (highestDistanceBetweenPlayers / 225) * cameraMarginFactor;
		Camera.Zoom = clamp(Camera.Zoom, 1, 3);
	}
}