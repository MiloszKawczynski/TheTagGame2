function scr_gravitationChange()
{
	if (global.debugIsGravityOn)
	{		
		Camera.Pitch = 130;
		Camera.Angle = 90;
	}
	else
	{
		Camera.Pitch = 50;
		Camera.Angle = 80;
	}
}