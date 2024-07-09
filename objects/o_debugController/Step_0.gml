with(ui)
{
	if (instance_exists(Camera))
	{
		cameraAngle.content = "Angle: " + string(Camera.Angle);
		cameraPitch.content = "Pitch: " + string(Camera.Pitch);
	}
}

ui.step();

if (keyboard_check_pressed(vk_escape))
{
	game_end();
}