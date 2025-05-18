matrix_set(matrix_world, matrix_build(room_width / 2, 0, z, 45, 0, 0, 1, 1, 1));

draw_sprite(sprite_index, 0, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(0, room_height / 2, z, 45, 0, 90, 1, 1, 1));

draw_sprite(s_crowdSide, 0, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(room_width / 2, room_height, z, 45, 0, 180, 1, 1, 1));

draw_sprite(sprite_index, 0, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(room_width, room_height / 2, z, 45, 0, 270, 1, 1, 1));

draw_sprite(s_crowdSide, 0, 0, 0);

matrix_reset();