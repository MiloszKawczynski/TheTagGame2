draw_set_color(c_red);
draw_rectangle(cullx1, cully1, cullx2, cully2, true);

matrix_set(matrix_world, matrix_build(0, 0, 0.13, 0, 0, 0, 1, 1, 1));
part_system_drawit(imChasingSystem);
matrix_reset();