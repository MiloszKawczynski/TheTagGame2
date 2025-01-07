ui.step();

ui.roundNumber.setContent(string("Round {0}/16", rounds));
ui.leftPoints.setContent(string(players[0].points));
if (array_length(other.players) == 2)
{
	ui.rightPoints.setContent(string(players[1].points));
}

if (isGameOn)
{
	chaseTime--;
	
	for (var i = 0; i < 4; i++)
	{
		if ((chaseTime - (i * 40)) mod (maximumChaseTime div changesPerChase) == 0)
		{
			vignettePulse = true;
		}
	}
	
	if (vignettePulse)
	{
		scr_vignettePulse();
	}
	else
	{
		if (pulseCounter == 0)
		{
			scr_vignettePullBack();
		}
	}

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
				
				other.players[player].points++;
			}
		}
		
		reset();
	}
}