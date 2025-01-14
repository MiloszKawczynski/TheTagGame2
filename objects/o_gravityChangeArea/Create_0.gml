event_inherited();

objectType = o_char;

onLeave = function()
{
	global.debugIsGravityOn = !global.debugIsGravityOn;
	scr_gravitationChange();
}