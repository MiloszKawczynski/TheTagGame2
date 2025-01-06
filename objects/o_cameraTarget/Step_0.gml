if (array_length(o_gameManager.players) != 0)
{
	if (o_gameManager.isGameOn)
	{
		if (instance_number(o_char) > 1)
		{
			scr_follow_many_characters();
		}
		else
		{
			scr_follow_one_character();
		}
	}
	else
	{
		scr_follow_one_character();
		
		if (place_meeting(x, y, o_zoomArea))
		{
			Camera.Zoom = instance_place(x, y, o_zoomArea).zoom;
		}
	}
}

if (global.debugEdit)
{
	camera_set_view_pos(view_camera[1],  x - (camera_get_view_width(view_camera[1]) / 2), y - (camera_get_view_height(view_camera[1]) / 2))
}