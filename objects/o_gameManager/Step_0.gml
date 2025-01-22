ui.step();

with(ui)
{
	roundNumber.setContent(string("Round {0}/16", other.rounds));
	leftPoints.setContent(string(other.players[0].points));
	//ui.timeBar.setValue(chaseTime / maximumChaseTime);
	
	var leftPlayer = other.players[0].instance;
	
	var pos = [];
	
	if (other.isGravitationOn)
	{
		pos = world_to_gui(
			leftPlayer.x + leftPlayer.image_xscale * 28 + leftPlayer.hspeed,
			leftPlayer.y - 20 + leftPlayer.vspeed,
			leftPlayer.z);
	}
	else 
	{
		if (sign(leftPlayer.image_xscale) == 1) 
		{
			pos = world_to_gui(
				leftPlayer.x + leftPlayer.image_xscale * 16 + leftPlayer.hspeed,
				leftPlayer.y - 48 + leftPlayer.vspeed,
				leftPlayer.z);
		}
		else 
		{
			pos = world_to_gui(
				leftPlayer.x + leftPlayer.image_xscale * 36 + leftPlayer.hspeed,
				leftPlayer.y - 40 + leftPlayer.vspeed,
				leftPlayer.z);
		}
	}
	
	leftStamina.setValue(leftPlayer.skillEnergy);
	leftStamina.setShift(pos[0], pos[1]);
	leftStamina.setScale((0.8 * leftPlayer.image_xscale) / Camera.Zoom, 0.8 / Camera.Zoom);

	if (array_length(other.players) == 2)
	{
		rightPoints.setContent(string(other.players[1].points));
		
		var rightPlayer = other.players[1].instance;
		
		if (other.isGravitationOn)
		{
			pos = world_to_gui(
				rightPlayer.x + rightPlayer.image_xscale * 28 + rightPlayer.hspeed,
				rightPlayer.y - 20 + rightPlayer.vspeed,
				rightPlayer.z);
		}
		else 
		{
			if (sign(rightPlayer.image_xscale) == 1) 
			{
				pos = world_to_gui(
					rightPlayer.x + rightPlayer.image_xscale * 16 + rightPlayer.hspeed,
					rightPlayer.y - 48 + rightPlayer.vspeed,
					rightPlayer.z);
			}
			else 
			{
				pos = world_to_gui(
					rightPlayer.x + rightPlayer.image_xscale * 36 + rightPlayer.hspeed,
					rightPlayer.y - 40 + rightPlayer.vspeed,
					rightPlayer.z);
			}
		}
		
		rightStamina.setValue(rightPlayer.skillEnergy);
		rightStamina.setShift(pos[0], pos[1]);
		rightStamina.setScale((0.8 * rightPlayer.image_xscale) / Camera.Zoom, 0.8 / Camera.Zoom);
	}
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
			
			if (i == 3)
			{
				audio_play_sound(sn_gravityChangeWarning, 0, false);
			}
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
			}
		}
		
		players[!whoIsChasing].points++;
		
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