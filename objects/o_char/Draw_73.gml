matrix_set(matrix_world, o_debugController.debugMatrix);
draw_set_color(c_black);
draw_set_alpha(1);
with(groundImOn)
{
	draw_circle(x, y, 5, false);
	draw_line(x + 16 * other.image_xscale, y - 16, x + 16 * other.image_xscale, y);
}
matrix_reset();