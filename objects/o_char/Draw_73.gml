if (o_gameManager.isGravitationOn)
{
	matrix_set(matrix_world, o_configurator.characterMatrix);
	part_system_drawit(runTrailSystem);
	matrix_reset();
}
else 
{
	matrix_set(matrix_world, matrix_build(0, 0, 1.3, 0, 0, 0, 1, 1, 1));
	part_system_drawit(runTrailSystem);
	matrix_reset();
}