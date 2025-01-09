alarm[0] = 1;

z = 0;

model = fauxton_model_create_ext(sprite_index, x, y, 0, 0, 0, 0, image_xscale, image_yscale, 1, image_blend, 1);

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
	
	fauxton_model_destroy(model);
	delete model;
	
	model = fauxton_model_create_ext(sprite_index, x, y, 0, 0, 0, 0, image_xscale, image_yscale, 1, image_blend, 1, horizontalAlign, verticalAlign);
}