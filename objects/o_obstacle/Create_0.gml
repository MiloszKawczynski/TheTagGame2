model = fauxton_model_create(sprite_index, x, y, 0, 0, 0, 0, 1, 1, 1);
fauxton_model_draw_enable(model, false)

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
//center = shader_get_uniform(shd_bloom, "center");
//color = shader_get_uniform(shd_bloom, "color");