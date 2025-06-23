if (follow == -1)
{
    if (array_length(o_gameManager.players) != 0)
    {
        if (instance_number(o_char) > 1)
        {
            if (o_gameManager.logicState == o_gameManager.pointState)
            {
                scr_follow_one_character(!o_gameManager.whoIsChasing);
            }
            else 
            {
            	scr_follow_many_characters();
            }
        }
        else
        {
            scr_follow_one_character();
        }
    }
}
else if (follow == -2)
{
    x = room_width / 2;
    y = room_height / 2;
}
else
{
	scr_follow_one_character(follow);
}

if (global.debugEdit)
{
	camera_set_view_pos(view_camera[1],  x - (camera_get_view_width(view_camera[1]) / 2), y - (camera_get_view_height(view_camera[1]) / 2))
}