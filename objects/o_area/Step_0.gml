if (place_meeting(x, y, objectType))
{
	if (!objectIsIn)
	{
		objectIsIn = true;
		
		onEnter()
	}
}
else
{
	if (objectIsIn)
	{
		objectIsIn = false;
		
		onLeave();
	}
}