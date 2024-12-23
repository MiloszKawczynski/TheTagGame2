function instance_nearest_notme(_x, _y, obj) 
{
    var inst = noone;
    var distClosest = infinity;
    with (obj) 
	{
        var dist = point_distance(x, y, _x, _y);
        if (id != other.id and dist < distClosest) 
		{
            inst = id;
            distClosest = dist;
        }
    }
    return inst;
}

function wait(time)
{
	var tend = get_timer() + (time * 1000000);
	while(get_timer() < tend)
	{
		//do nothing
	}
}

function part_system_copy(ps, ind) 
{
    var systemInfo = particle_get_info(ps);
    var newSystem = part_system_create();

    part_system_draw_order(newSystem, systemInfo.oldtonew);
	
	part_emitter_copy(ps, ind, newSystem);

    return newSystem;
}

function part_emitter_copy(ps, ind, newSystem) 
{
    var emitterInfo = particle_get_info(ps).emitters[ind];
    var newEmitter = part_emitter_create(newSystem);
	
	var typeInfo = particle_get_info(ps).emitters[ind].parttype;

	if (emitterInfo.mode == ps_mode_burst)
	{
		part_emitter_burst(newSystem, newEmitter, 
			typeInfo.ind, 
			emitterInfo.number);
	}
	else
	{
		part_emitter_stream(newSystem, newEmitter, 
			typeInfo.ind, 
			emitterInfo.number)
	}

    part_emitter_region(newSystem, newEmitter,
        emitterInfo.xmin,
        emitterInfo.xmax,
        emitterInfo.ymin,
        emitterInfo.ymax,
        emitterInfo.shape,
        emitterInfo.distribution);

    return newEmitter;
}

function part_emitter_type(ps, ind, parttype)
{
	var emitterInfo = particle_get_info(ps).emitters[ind];
	
	if (emitterInfo.mode == ps_mode_burst)
	{
		part_emitter_burst(ps, emitterInfo.ind, 
			parttype, 
			emitterInfo.number);
	}
	else
	{
		part_emitter_stream(ps, emitterInfo.ind, 
			parttype, 
			emitterInfo.number)
	}
}

function part_type_copy(ps, ind) 
{
	var partType = particle_get_info(ps).emitters[ind].parttype;
	var newPartType = part_type_create();
	
	if (partType.shape == -1)
	{
		part_type_sprite(newPartType, 
		partType.sprite,
		partType.animate,
		partType.stretch,
		partType.random);
	}
	else
	{
	    part_type_shape(newPartType, 
		partType.shape);
	}

    part_type_size_x(newPartType, 
        partType.size_xmin, 
        partType.size_xmax, 
        partType.size_xincr, 
        partType.size_xwiggle);
		
	part_type_size_y(newPartType, 
        partType.size_ymin, 
        partType.size_ymax, 
        partType.size_yincr, 
        partType.size_ywiggle);
	
	part_type_scale(newPartType,
		partType.xscale,
		partType.yscale);

    part_type_life(newPartType, 
        partType.life_min, 
        partType.life_max);

    part_type_color3(newPartType, 
        partType.color1, 
        partType.color2, 
        partType.color3);

    part_type_alpha3(newPartType, 
        partType.alpha1, 
        partType.alpha2, 
        partType.alpha3);

    part_type_speed(newPartType, 
        partType.speed_min, 
        partType.speed_max, 
        partType.speed_incr, 
        partType.speed_wiggle);
    
    part_type_direction(newPartType, 
        partType.dir_min, 
        partType.dir_max, 
        partType.dir_incr, 
        partType.dir_wiggle);

    part_type_gravity(newPartType, 
        partType.grav_amount, 
        partType.grav_dir);

    part_type_orientation(newPartType, 
        partType.ang_min, 
        partType.ang_max, 
        partType.ang_incr, 
        partType.ang_wiggle,
		partType.ang_relative);

    part_type_blend(newPartType, 
		partType.additive);
	
	return newPartType;
}

function list_all_sprites(list)
{
    var surf,no;
    surf = surface_create(1, 1);
    no = sprite_create_from_surface(surf, 0, 0, 1, 1, false, false, 0, 0);
    surface_free(surf);
    sprite_delete(no);
    for (var i = 0; i < no; i += 1) 
	{
        if (sprite_exists(i)) 
		{
            ds_list_add(list, sprite_get_name(i));
        }
    }
    return 0;
}

function list_all_fonts(list)
{
    var no;
    no = font_add_sprite(ats_button, ord("!"), true, 2);
	font_delete(no);
    for (var i=0; i<no; i+=1) 
	{
        if (font_exists(i)) 
		{
            ds_list_add(list,font_get_name(i));
        }
    }
    return 0;
}

function ds_list_convert_to_array(list)
{
	var arrayList = array_create(0);
	
	for (var i = 0; i < ds_list_size(list); i++)
	{
		array_push(arrayList, ds_list_find_value(list, i));
	}
	
	return arrayList;
}

function ds_array_convert_to_list(array)
{
	var list = ds_list_create();
	
	for (var i = 0; i < array_length(array); i++)
	{
		ds_list_add(list, array[i]);
	}
	
	return list;
}

function array_find_value_by_key(array, key)
{
	for (var i = 0; i < array_length(array); i++)
	{
		if (array[i].key == key)
		{
			return array[i];
		}
	}
}

function get_project_path()
{
	var projectPath = "";
	
	if (RUN_FROM_IDE)
	{
		projectPath = PROJECT_DIR;
	}
	else
	{
		projectPath = working_directory;
	}
	
	return projectPath;
}