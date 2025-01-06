model = fauxton_model_create(sprite_index, x, y, 0, 0, 0, 0, 1, 1, 1);

maximumObstacleRange = 0;

circleRadius = shader_get_uniform(shd_obstacleRing, "circleRadius");

surface = undefined;