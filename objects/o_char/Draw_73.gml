if (global.debugIsGravityOn)
{
	matrix_set(matrix_world, o_debugController.characterMatrix);
	part_system_drawit(runTrailSystem);
	matrix_reset();
}
else 
{
	part_system_drawit(runTrailSystem);
}