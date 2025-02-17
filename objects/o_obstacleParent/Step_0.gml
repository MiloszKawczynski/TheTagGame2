success = lerp(success, 0, 0.05);
if (success <= 0.1)
{
	success = 0;
}

if (place_meeting(x, y, o_obstacleParent))
{
	alarm[0] = 1 + random(3);
}