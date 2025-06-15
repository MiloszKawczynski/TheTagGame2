if (!global.debugEdit)
{
    locate();
}
else 
{
	model = fauxton_model_create_ext(sprite_index, 0, 0, 0, 0, 0, 0, 1, 1, 1, c_white, 1, 0, 0);
    fauxton_model_set(model, x, y, z, 0, 0, 0, image_xscale, image_yscale, 1);
}