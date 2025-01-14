ui.step();

ui.roundNumber.setContent(string("Round {0}/16", rounds));
ui.leftPoints.setContent(string(players[0].points));
if (array_length(other.players) == 2)
{
	ui.rightPoints.setContent(string(players[1].points));
}

if (input_check_pressed("debugPlayKey"))
{
	startStop();
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

if (alarm[0] == -1 and false)
{
	if (global.debugEdit)
	{
		var cam = Camera.ThisCamera;
		x1 = camera_get_view_x(view_camera[1]);
		y1 = camera_get_view_y(view_camera[1]);
		x2 = x1 + camera_get_view_width(view_camera[1]);
		y2 = y1 + camera_get_view_height(view_camera[1]);
	}
	else 
	{
		var cam = Camera.ThisCamera;
		var width = 200;
		var height = 200;
		x1 = Camera.Target.x - (width / 2);
		y1 = Camera.Target.y - (height / 2);
		x2 = x1 + width;
		y2 = y1 + height;
	}
	
	instance_deactivate_all(true);
	
	instance_activate_layer("controllers");
	instance_activate_layer("fauxton");
	instance_activate_layer("players");
	instance_activate_layer("covers");
	instance_activate_layer("areas");
	instance_activate_object(input_controller_object);
	instance_activate_object(o_debugController);
	instance_activate_object(o_cameraTarget);
	instance_activate_object(o_gameManager);
	
	instance_activate_region(x1, y1, x2 - x1, y2 - y1, true)
}