fauxton_model_set(model, x, y, z, 0, 0, 0, 1, 1, 1);

if (frame + offset >= array_length(leds))
{
	frame = -offset;
}

if (o_gameManager.players[0].points > o_gameManager.players[1].points)
{
	setColorTo(o_gameManager.players[0].instance.color);
}
else if (o_gameManager.players[0].points < o_gameManager.players[1].points)
{
	setColorTo(o_gameManager.players[1].instance.color);
}
else 
{
	setColorTo(merge_color(o_gameManager.players[0].instance.color, o_gameManager.players[1].instance.color, 0.5));
}