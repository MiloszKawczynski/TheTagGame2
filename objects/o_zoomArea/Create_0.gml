event_inherited();

objectType = o_char;

zoomBefore = Camera.Zoom;

onEnter = function()
{
	zoomBefore = Camera.Zoom;
	Camera.Zoom = zoom;
}

onLeave = function()
{
	Camera.Zoom = zoomBefore;
}