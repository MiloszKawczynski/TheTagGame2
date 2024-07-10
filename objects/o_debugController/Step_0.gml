with(ui)
{
	if (instance_exists(Camera))
	{
		cameraAngle.content = "Angle: " + string(Camera.Angle);
		cameraPitch.content = "Pitch: " + string(Camera.Pitch);
	}
	
	if (instance_exists(o_char))
	{
		horizontalSpeed.content = "hSpeed: " + string(o_char.horizontalSpeed); 
		verticalSpeed.content = "vSpeed: " + string(o_char.verticalSpeed); 
	}
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}

if (keyboard_check_pressed(vk_f6))
{
	global.debugIsGravityOn = !global.debugIsGravityOn;
}