function fauxton_cube_create(sprite, _x, _y, _z)
{
	//fauxton_model_create(sprite, _x,	 _y,     _z     ,   0,  0, 0, 1, 1, 1); // BOTTOM
	fauxton_model_create(sprite, _x,	 _y,     _z + 16,   0,  0, 0, 1, 1, 1); // TOP

	//fauxton_model_create(sprite, _x - 8, _y,     _z +  8, -90, 90, 0, 1, 1, 1); // LEFT
	//fauxton_model_create(sprite, _x + 8, _y,     _z +  8, -90, 90, 0, 1, 1, 1); // RIGHT
	
	//fauxton_model_create(sprite, _x,     _y + 8, _z +  8,  90,  0, 0, 1, 1, 1); // BACK
	fauxton_model_create(sprite, _x,     _y - 8, _z +  8,  90,  0, 0, 1, 1, 1); // FRONT
}

function fauxton_slope_create(slopeSprite, cubeSprite, _x, _y, _z)
{
	fauxton_model_create(slopeSprite, _x,	 _y,     _z     ,   0,  0, 0, image_xscale, 1, 1); // BOTTOM
	fauxton_model_create(slopeSprite, _x,	 _y,     _z + 16,   0,  0, 0, image_xscale, 1, 1); // TOP

	//*fauxton_model_create(s_cube, _x - 8, _y,     _z +  8, -90, 90, 0, 1, 1, 1); // LEFT
	//fauxton_model_create(cubeSprite, _x + 8, _y,     _z +  8, -90, 90, 0, 1, 1, 1); // RIGHT
	
	//fauxton_model_create(cubeSprite, _x,     _y + 8, _z +  8,  90,  0, 0, 1, 1, 1); // BACK
	//*fauxton_model_create(cubeSprite, _x,     _y - 8, _z +  8,  90,  0, 0, 1, 1, 1); // FRONT
}