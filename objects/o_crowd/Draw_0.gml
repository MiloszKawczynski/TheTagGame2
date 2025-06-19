if (o_gameManager.isGravitationOn)
{
    degree = lerp(degree, 22.5, 0.2);
}
else 
{
	degree = lerp(degree, 45, 0.2);
}

shader_set(shd_crowd);
shader_set_uniform_f(sizeUniform, crowdTexelW, crowdTexelH);
shader_set_uniform_f_array(dotPositionXUniform, dotPositionX);
shader_set_uniform_f_array(dotPositionYUniform, dotPositionY);
shader_set_uniform_f_array(dotRadiusUniform, dotSize);
shader_set_uniform_f_array(dotLightUniform, dotLight);

matrix_set(matrix_world, matrix_build(room_width / 2, 0, z, degree, 0, 0, 1, 1, 1));
draw_sprite(sprite_index, image_index, 0, 0);
matrix_reset();

matrix_set(matrix_world, matrix_build(room_width / 2, room_height, z, 15, 0, 180, 1, 1, 1));
draw_sprite(sprite_index, image_index, 0, 0);
matrix_reset();

shader_reset();

shader_set(shd_crowd);
shader_set_uniform_f(sizeUniform, crowdSideTexelW, crowdSideTexelH);
shader_set_uniform_f_array(dotPositionXUniform, dotPositionX);
shader_set_uniform_f_array(dotPositionYUniform, dotPositionY);
shader_set_uniform_f_array(dotRadiusUniform, dotSize);
shader_set_uniform_f_array(dotLightUniform, dotLight);

matrix_set(matrix_world, matrix_build(0, room_height / 2, z, degree, 0, 90, 1, 1, 1));
draw_sprite(s_crowdSide, image_index, 0, 0);
matrix_reset();

matrix_set(matrix_world, matrix_build(room_width, room_height / 2, z, degree, 0, 270, 1, 1, 1));
draw_sprite(s_crowdSide, image_index, 0, 0);
matrix_reset();

shader_reset();