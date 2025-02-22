alarm[0] = 10;

frame++;

if (frame + offset >= array_length(leds))
{
	frame = 0 - offset;
}