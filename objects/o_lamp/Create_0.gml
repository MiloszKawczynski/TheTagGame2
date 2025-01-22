z = 8;

model = fauxton_model_create(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1);

maximumObstacleRange = 0;

circleRadius = shader_get_uniform(shd_obstacleRing, "circleRadius");

surface = undefined;

editor = function()
{
	ImGui.Text("LAMP");
}