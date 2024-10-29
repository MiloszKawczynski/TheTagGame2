if (global.debugOutOfViewCulling)
{
	var cam = Camera.ThisCamera;
	var zoom = Camera.Zoom * 1.5;
	var x1 = Camera.Target.x - (Camera.Width * zoom / 2);
	var y1 = Camera.Target.y - (Camera.Height * zoom * 1.5 / 2);
	var x2 = x1 + Camera.Width * zoom;
	var y2 = y1 + Camera.Height * zoom * 1.5;

	fauxton_model_draw_enable(model, point_in_rectangle(x, y, x1, y1, x2, y2));
}
else
{
	fauxton_model_draw_enable(model, true);
}

if (global.debugEdit)
{
	if (place_meeting(x, y, o_collision))
	{
		instance_destroy();
	}
}