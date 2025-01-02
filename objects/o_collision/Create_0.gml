alarm[0] = 1;

z = 0;


instanceToMerge = ds_map_create();
isReadyToMerge = false;
isMerged = false;
mergeSurface = undefined;
mergedX = 0;
mergedY = 0;
mergedSprite = undefined;
typeOfMerge = o_collision;

locate = function(map)
{
	isMerged = true;
	
	if (ds_map_find_value(map, id))
	{
		return map;
	}
	
	ds_map_add(map, id, true);
	
	if (place_meeting(x - 16, y, typeOfMerge))
	{
		map = instance_place(x - 16, y, typeOfMerge).locate(map);
	}
	
	if (place_meeting(x + 16, y, typeOfMerge))
	{
		map = instance_place(x + 16, y, typeOfMerge).locate(map);
	}
	
	if (place_meeting(x, y - 16, typeOfMerge))
	{
		map = instance_place(x, y - 16, typeOfMerge).locate(map);
	}
	
	if (place_meeting(x, y + 16, typeOfMerge))
	{
		map = instance_place(x, y + 16, typeOfMerge).locate(map);
	}
	
	return map;
}