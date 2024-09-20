if (live_call()) return live_result;

if (global.debugIsGravityOn)
{
	scr_platformerMovement();
	scr_platformerCollision();
	//fauxton_model_set(model, x, y + 15, 12, -90, 0, 0, 1, 1, 1);
}
else
{
	scr_topDownMovement();
	scr_topDownCollision();
	//fauxton_model_set(model, x, y, 0, 0, 0, direction + 90, 1, 1, 1);
}

Camera.MouseLock = mouse_check_button(mb_right);