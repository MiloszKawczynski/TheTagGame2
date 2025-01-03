var length = 1200;

part_emitter_region(godRaysSystem, 0, 0, length, 100, 100, ps_shape_line, ps_distr_linear)
part_emitter_stream(godRaysSystem, 0, godRaysType, 1);

if (isReflector)
{
	x = lerp(x, o_char.x, 0.2);
	y = lerp(y, o_char.y, 0.2);

	image_angle = lerp(image_angle, 45 * o_char.image_xscale, 0.01);
}