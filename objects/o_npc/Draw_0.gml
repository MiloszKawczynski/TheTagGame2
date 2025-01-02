if (!global.debugEdit)
{
	draw_sprite_3d_in_game(sprite_index, image_index, x, y, 16 + z, 0, 0, 0, image_xscale, 1, 1);
}

if (distance_to_object(o_char) < range)
{
	draw_sprite_3d_in_game(s_speechIcon, speechIndex, x, y - 1, 48, 0, 0, 0, 1, 1, 1);
	speechIndex += sprite_get_speed(s_speechIcon) / 60;
}
else
{
	draw_sprite_3d_in_game(s_speechIcon, 0, x, y - 1, 48, 0, 0, 0, 1, 1, 1)
}