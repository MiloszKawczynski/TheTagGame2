if (hue)
{
	var newHue = color_get_hue(color) + 1;
	color = make_color_hsv(newHue, color_get_saturation(color), color_get_value(color));
	color2 = make_color_hsv(newHue, color_get_saturation(color2), color_get_value(color2));
}