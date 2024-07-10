if (global.debugIsGravityOn)
{
	scr_platformerMovement();
}
else
{
	scr_topDownMovement();
}

scr_outOfBoundsPrevention();
scr_collision();