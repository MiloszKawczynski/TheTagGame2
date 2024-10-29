if (!global.debugEdit)
{
	if (global.debugIsGravityOn)
	{
		draw_sprite_3d(sprite_index, image_index, x, y, 16, 0, 0, 0, image_xscale, 1, 1, true);
	}
	else
	{
		draw_sprite_3d(sprite_index, image_index, x, y, 16, Camera.Pitch, 0, 90 - Camera.Angle, image_xscale, 1, 1, false);
	}
}