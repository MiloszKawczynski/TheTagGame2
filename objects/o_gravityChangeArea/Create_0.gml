event_inherited();

objectType = o_char;

onLeave = function()
{
	o_gameManager.isGravitationOn = !o_gameManager.isGravitationOn;
	scr_gravitationChange();
}