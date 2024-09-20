if (live_call()) return live_result;

if (global.debugIsGravityOn)
{
	scr_platformerMovement();
	scr_platformerCollision();
}
else
{
	scr_topDownMovement();
	scr_topDownCollision();
}

Camera.MouseLock = mouse_check_button(mb_right);