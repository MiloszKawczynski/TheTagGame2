if (input_check_pressed("debugPlayKey"))
{
	startStop();
}

ui.step();
uiState();
logicState();

if (alarm[0] == -1 and false)
{
	if (global.debugEdit)
	{
		var cam = Camera.ThisCamera;
		cullx1 = camera_get_view_x(view_camera[1]);
		cully1 = camera_get_view_y(view_camera[1]);
		cullx2 = cullx1 + camera_get_view_width(view_camera[1]);
		cully2 = cully1 + camera_get_view_height(view_camera[1]);
	}
	else 
	{
		var cam = Camera.ThisCamera;
		var width = 200;
		var height = 200;
		cullx1 = Camera.Target.x - (width / 2);
		cully1 = Camera.Target.y - (height / 2);
		cullx2 = cullx1 + width;
		cully2 = cully1 + height;
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
	
	instance_activate_region(cullx1, cully1, cullx2 - cullx1, cully2 - cully1, true)
}