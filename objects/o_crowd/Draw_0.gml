// walls

var degree = 15;

matrix_set(matrix_world, matrix_build(room_width / 2, 0, z, degree, 0, 0, 4, 1, 1));

draw_sprite(sprite_index, image_index, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(0, room_height / 2, z, degree, 0, 90, 1, 4, 1));

draw_sprite(s_crowdSide, image_index, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(room_width / 2, room_height, z, degree, 0, 180, 4, 1, 1));

draw_sprite(sprite_index, image_index, 0, 0);

matrix_reset();

matrix_set(matrix_world, matrix_build(room_width, room_height / 2, z, degree, 0, 270, 1, 4, 1));

draw_sprite(s_crowdSide, image_index, 0, 0);

matrix_reset();