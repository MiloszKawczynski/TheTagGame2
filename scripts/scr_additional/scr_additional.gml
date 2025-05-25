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

function ImGui_position_2()
{
	var value = [x, y];
	
	ImGui.DragFloat2("Position", value);
	
	x = value[0];
	y = value[1];
	
	if (keyboard_check(vk_lshift))
	{
		if (value[0] != x)
		{
			x = value[0];
			var _x = x div 16;
			x = (_x * 16) + 8;
		}
		
		if (value[1] != y)
		{
			y = value[1];
			var _y = y div 16;
			y = (_y * 16) + 8;
		}
		
	}
	else 
	{
		x = value[0];
		y = value[1];
	}
}

function ImGui_position_3(grid = 16)
{
	var value = [x, y, z];

	ImGui.DragFloat3("Position", value);
	
	if (keyboard_check(vk_lshift))
	{
		if (value[0] != x)
		{
			x = value[0];
			var _x = x div grid;
			x = (_x * grid) + (grid / 2);
		}
		
		if (value[1] != y)
		{
			y = value[1];
			var _y = y div grid;
			y = (_y * grid) + (grid / 2);
		}
		
		if (value[2] != z) 
		{
			z = value[2];
			var _z = z div grid;
			z = (_z * grid) + (grid / 2);
		}
	}
	else 
	{
		x = value[0];
		y = value[1];
		z = value[2];	
	}
}

function ImGui_scale_2()
{
	var value = [image_xscale, image_yscale];
	var step = 1;
			
	ImGui.DragFloat2("Scale", value);
	
	image_xscale = value[0];
	image_yscale = value[1];
	
	if (keyboard_check(vk_lshift))
	{
		image_xscale = round(image_xscale);
		image_yscale = round(image_yscale);
	}
}

function changeAnimationState(condition, machine, newState)
{
	if (condition)
	{
		machine = newState;
		machine();
		image_speed = 1;
		image_index = 0;
		squash = 1;
		stretch = 1;
	}
	
	return machine;
}

function setXScaleWithHSpeed()
{
	var xScaleBefore = image_xscale
	if (sign(hspeed) != 0)
	{
		image_xscale = sign(hspeed);
	}
}

function playOnce()
{
	if (image_index >= image_number - 1)
	{
		image_speed = 0;
		return true;
	}
	
	return false;
}

function changeState(condition, machine, newState)
{
	if (condition)
	{
		machine = newState;
		machine();
	}
	
	return machine;
}

function world_to_gui(xx, yy, zz) 
{
	var view_mat = camera_get_view_mat(Camera.ThisCamera);
	var proj_mat = camera_get_proj_mat(Camera.ThisCamera);

	var vx = view_mat[0] * xx + view_mat[4] * yy + view_mat[8]  * zz + view_mat[12];
	var vy = view_mat[1] * xx + view_mat[5] * yy + view_mat[9]  * zz + view_mat[13];
	var vz = view_mat[2] * xx + view_mat[6] * yy + view_mat[10] * zz + view_mat[14];
	var vw = view_mat[3] * xx + view_mat[7] * yy + view_mat[11] * zz + view_mat[15];

	var clip_x = proj_mat[0] * vx + proj_mat[4] * vy + proj_mat[8]  * vz + proj_mat[12] * vw;
	var clip_y = proj_mat[1] * vx + proj_mat[5] * vy + proj_mat[9]  * vz + proj_mat[13] * vw;
	var clip_w = proj_mat[3] * vx + proj_mat[7] * vy + proj_mat[11] * vz + proj_mat[15] * vw;

	if (clip_w == 0) return [-1, -1];

	var ndc_x = clip_x / clip_w;
	var ndc_y = clip_y / clip_w;

	var pitch = Camera.pTo;

	if (pitch > 90 and pitch < 270) 
	{
		ndc_x = -ndc_x;
		ndc_y = -ndc_y;
	}

	var zoomed_x = ndc_x;
	var zoomed_y = ndc_y;

	var screen_x = (zoomed_x * 0.5 + 0.5) * display_get_gui_width();
	var screen_y = (1.0 - (zoomed_y * 0.5 + 0.5)) * display_get_gui_height();

	return [screen_x, screen_y];
}


