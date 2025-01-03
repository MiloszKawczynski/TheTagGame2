if (global.debugEdit)
{
	draw_sprite_ext(sprite_index, image_number - 1, x, y, image_xscale, image_yscale, 0, c_white, 1);
}

if (isReadyToMerge)
{
	var key = ds_map_find_first(instanceToMerge);
	var size = ds_map_size(instanceToMerge)
	
	var left = bbox_left;
	var right = bbox_right;
	var top = bbox_top;
	var bottom = bbox_bottom;
	var height = 0;
	
	for (var i = 0; i < size; i++)
	{
		var inst = key;
		
		if (inst.bbox_left < left)
		{
			left = inst.bbox_left;
		}
		
		if (inst.bbox_right > right)
		{
			right = inst.bbox_right;
		}
		
		if (inst.bbox_top < top)
		{
			top = inst.bbox_top;
		}
		
		if (inst.bbox_bottom > bottom)
		{
			bottom = inst.bbox_bottom;
		}
		
		if (inst.image_number > height)
		{
			height = inst.image_number;
		}
		
		key = ds_map_find_next(instanceToMerge, key);
	}
	
	mergedX = left;
	mergedY = top;
	
	if (!surface_exists(mergeSurface))
	{
		mergeSurface = surface_create(right - left, bottom - top);	
	}
		
	surface_set_target(mergeSurface);
	draw_clear_alpha(c_black, 0);
	key = ds_map_find_first(instanceToMerge);
		
	for (var j = 0; j < size; j++)
	{
		var inst = key;
			
		if (inst.image_number < height - 1)
		{
			key = ds_map_find_next(instanceToMerge, key);
			continue;
		}
			
		draw_sprite_ext(inst.sprite_index, height - 1, inst.x - left, inst.y - top, inst.image_xscale, inst.image_yscale, inst.image_angle, inst.image_blend, inst.image_alpha);
		
		key = ds_map_find_next(instanceToMerge, key);
	}
		
	mergedSprite = sprite_create_from_surface(mergeSurface, 0, 0, right - left, bottom - top, false, false, 0, 0);
	
	surface_reset_target();
	
	mergedModel = fauxton_model_create(mergedSprite, mergedX, mergedY, height - 0.9, 0, 0, 0, 1, 1, 1);
	
	isReadyToMerge = false;
	
	editor = function()
	{
		ImGui_position_3(x, y, z);
	
		fauxton_model_set(mergedModel, x, y, z, 0, 0, 0, image_xscale, image_yscale, 1);
	}
}
