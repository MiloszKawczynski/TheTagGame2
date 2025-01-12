/// @description Insert description here
// You can write your code in this editor
if (place_meeting(x, y, o_char))
{
	if (!characterIsIn)
	{
		characterIsIn = true;
		
		global.debugIsGravityOn = !global.debugIsGravityOn;
		
		scr_gravitationChange();
	}
}
else
{
	if (characterIsIn)
	{
		characterIsIn = false;
	}
}