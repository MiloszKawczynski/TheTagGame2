model = fauxton_model_create(sprite_index, x, y, 0, 0, 0, 0, 1, 1, 1);

maximumObstacleRange = 0;

with(o_char)
{
	if (obstacleRange > other.maximumObstacleRange)
	{
		other.maximumObstacleRange = obstacleRange;
	}
}

surface = surface_create(maximumObstacleRange * 2, maximumObstacleRange * 2);

circleRadius = shader_get_uniform(shd_obstacleRing, "circleRadius");