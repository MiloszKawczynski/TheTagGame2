fauxton_model_set(model, x, y, z, 0, 0, 0, 1, 1, 1);

if (frame + offset >= array_length(leds))
{
	frame = -offset;
}