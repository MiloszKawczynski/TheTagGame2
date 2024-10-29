var objectWidth = sprite_get_width(object_get_sprite(spawnObject))
var objectHeight = sprite_get_height(object_get_sprite(spawnObject))

for(var ix = 0; ix < room_width; ix += objectWidth)
{
	for(var iy = 0; iy < room_height - room_height mod 16; iy += objectHeight)
	{
		if ((ix == 0 or ix == room_width - objectWidth)
		or (iy == 0 or iy == room_height - room_height mod 16 - objectHeight))
		{
			instance_create_layer(ix + objectWidth / 2, iy + objectHeight / 2, layer, spawnObject);
		}
	}
}

instance_destroy();