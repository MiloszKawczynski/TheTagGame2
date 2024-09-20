//if (live_call()) return live_result;

matrix_set(matrix_world, o_debugController.debugMatrix);
draw_set_color(c_black);
draw_set_alpha(1);
draw_set_color(c_lime);
draw_circle(x, y, 2, false);
matrix_reset();