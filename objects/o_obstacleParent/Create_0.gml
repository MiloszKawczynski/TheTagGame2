z = 1;

model = fauxton_model_create(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1);

circleRadiusUniform = shader_get_uniform(shd_obstacleRing, "circleRadius");
directionUniform = shader_get_uniform(shd_obstacleRing, "direction");
successUniform = shader_get_uniform(shd_obstacleRing, "success");

success = 0;