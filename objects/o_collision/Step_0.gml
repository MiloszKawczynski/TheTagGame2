if (global.debugEdit)
{
	if (place_meeting(x, y, o_collision))
	{
		if (!instance_place(x, y, o_cup))
		{		
			instance_destroy();
		}
	}
}