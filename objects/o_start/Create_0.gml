z = 0;

model = fauxton_model_create(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1);

if (instance_number(o_start) > 2)
{
	instance_destroy();
}

linkToPlayer = instance_number(o_start) - 1;

fauxton_model_draw_enable(model, false);

colorUniform = shader_get_uniform(shd_defaultReplaceWhite, "color");

alarm[0] = 2;