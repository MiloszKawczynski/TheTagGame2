for(var i = 0; i < numberOfPlayers; i++)
{
	var color = c_white;
	
	if (isBindingFinilize)
	{
		color = c_lime;
	}
	
	drawSlot((room_width * 0.2) + room_width * 0.20 * i, room_height * 0.5, i);
}