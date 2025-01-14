alarm[0] = 1;

z = 0;

typeOfMerge = o_collision;

horizontalAlign = 0;
verticalAlign = 0;

locate = function()
{
	if (place_meeting(x - 1, y, typeOfMerge))
	{
		horizontalAlign--;
	}
	
	if (place_meeting(x + 1, y, typeOfMerge))
	{
		horizontalAlign++;
	}
	
	if (place_meeting(x, y - 1, typeOfMerge))
	{
		verticalAlign--;
	}
	
	if (place_meeting(x, y + 1, typeOfMerge))
	{
		verticalAlign++;
	}
	
	var newHor = horizontalAlign;
	var newVer = verticalAlign;
	
	if (horizontalAlign == 0)
	{
		if (place_meeting(x, y - 1, typeOfMerge) and (place_meeting(x, y + 1, typeOfMerge)))
		{
			newVer = 2;
		}
	}
	
	if (verticalAlign == 0)
	{
		if (place_meeting(x - 1, y, typeOfMerge) and (place_meeting(x + 1, y, typeOfMerge)))
		{
			newHor = 2;
		}
	}
	
	horizontalAlign = newHor;
	verticalAlign = newVer;
	
	if (horizontalAlign == 2 and verticalAlign == 2)
	{
		horizontalAlign = 0;
		verticalAlign = 0;
	}
	
	var bufferId = string("{0}_{1}_{2}_{3}_{4}", sprite_index, horizontalAlign, verticalAlign, image_xscale, image_yscale);
	
	model = ds_map_find_value(o_gameManager.buffersMap, bufferId);
	
	if (model == undefined or (!global.createStaticBuffers and !global.loadStaticBuffers))
	{
		model = fauxton_model_create_ext(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1, c_white, 1, horizontalAlign, verticalAlign);
		ds_map_add(o_gameManager.buffersMap, bufferId, model);
		
		if (global.createStaticBuffers or global.loadStaticBuffers)
		{
			fauxton_buffer_create(bufferId)
		}
	}
	
	fauxton_model_set(model, x, y, 0, 0, 0, 0, image_xscale, image_yscale, 1);
	
	if (global.createStaticBuffers or global.loadStaticBuffers)
	{
		fauxton_model_add_static(model, bufferId);
	}
}