if (isGameOn)
{
	chaseTime--;
	
	log(string(chaseTime));

	if (chaseTime mod (maximumChaseTime div changesPerChase) == 0)
	{
		isGravitationOn = !isGravitationOn;
		global.debugIsGravityOn = isGravitationOn;
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
			}
		}
		
		reset();
		
		log("END!", c_red);
	}
}