if (!isBindingFinilize)
{
	calculateFirstFreePlayer();
	if (firstFreePlayer < numberOfPlayers)
	{
		if (input_check_pressed("joinP1", 2) and !isWSADBind)
		{ 
			input_source_set(INPUT_KEYBOARD, firstFreePlayer,, false);
			input_profile_set("P1", firstFreePlayer);	
			isWSADBind = true;
		}
		
		if (input_check_pressed("joinP2", 2) and !isArrowsBind)
		{ 
			input_source_set(INPUT_KEYBOARD, firstFreePlayer,, false);
			input_profile_set("P2", firstFreePlayer);
			isArrowsBind = true;
		}
		
		for (var i = 0; i < numberOfPlayers; i++)
		{
			if (input_source_detect_input(INPUT_GAMEPAD[i]))
			{
				input_source_set(INPUT_GAMEPAD[i], firstFreePlayer,, false);
			}
		}
	}
	
	calculateFirstFreePlayer();
	for(var i = 0; i < numberOfPlayers; i++)
	{
		if (input_check_pressed("leave", i))
		{
			switch(input_profile_get(i))
			{
				case("P1"):
				{
					if (isWSADBind)
					{
						disconnectPlayer(i);
						isWSADBind = false;
					}
					break;
				}
				
				case("P2"):
				{
					if (isArrowsBind)
					{
						disconnectPlayer(i);
						isArrowsBind = false;
					}
					break;
				}
				
				case("gamepad"):
				{
					disconnectPlayer(i);
					break;
				}
			}
		}
		
		//if (input_check_long_pressed("interactionKey", i) and firstFreePlayer >= 2)
		if (firstFreePlayer >= 2)
		{
			isBindingFinilize = true;
			break;
		}
	}
	calculateFirstFreePlayer();
		
	
	while(input_source_using(INPUT_KEYBOARD, firstFreePlayer) or input_source_using(INPUT_GAMEPAD, firstFreePlayer))
	{
		firstFreePlayer++;
	}
}
else 
{
	for(var i = 0; i < numberOfPlayers; i++)
	{
		if (input_check_pressed("leave", i))
		{
			isBindingFinilize = false;
		}
		
		//if (input_check_pressed("interactionKey", i))
		{
            if (DESTINATION == DebugDestination.Arena)
            {
                global.gameLevelName = "shaft";
                room_goto(r_levelEditor);
            }
            
            if (DESTINATION == DebugDestination.PlotMap)
            {
                global.gameLevelName = "metroChasev1.1";
			    room_goto(r_levelEditorBig);
            }
            
            if (DESTINATION == DebugDestination.Lobby)
            {
                room_goto(r_characterSelection);
            }
            
			break;
		}
	}
}
