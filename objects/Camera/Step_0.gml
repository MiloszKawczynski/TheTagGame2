camera_update();

if (variable_global_exists("debug") and global.debug)
{
	if (keyboard_check_pressed(vk_f2))
	{
		Pitch -= 10;
	}
	
	if (keyboard_check_pressed(vk_f3))
	{
		Pitch += 10;
	}
	
	if (keyboard_check_pressed(vk_f4))
	{
		Angle -= 10;
	}
	
	if (keyboard_check_pressed(vk_f5))
	{
		Angle += 10;
	}
	
	Zoom += ( mouse_wheel_down() - mouse_wheel_up() ) * 0.1;
}