if (isGameOn)
{
	chaseTime--;

	if (chaseTime mod (maximumChaseTime div changesPerChase) == 0)
	{
		global.debugIsGravityOn = !global.debugIsGravityOn;
		scr_gravitationChange();
		log("CHANGE!", c_yellow);
	}
	
	if (chaseTime <= 0)
	{
		with(o_char)
		{
			if (!isChasing)
			{
				log(string("Player {0} ESCAPED!", player), color);
				
				other.points[player]++;
			}
		}
		
		reset();
	}
}