var objectWidth = sprite_get_width(object_get_sprite(spawnObject))
var objectHeight = sprite_get_height(object_get_sprite(spawnObject))

for(var ix = 0; ix < image_xscale; ix++)
{
	for(var iy = 0; iy < image_yscale; iy++)
	{
		instance_create_layer(bbox_left + ix * objectWidth + objectWidth / 2, bbox_top + iy * objectHeight + objectHeight / 2, layer, spawnObject);
	}
}

instance_destroy();