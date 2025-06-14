#region Macros & Globals (ignore)
	global.__SYSTEM_RENDER_QUEUE = ds_list_create();
	global.__SYSTEM_DEFAULT_STATE = gpu_get_state();
	global.__SYSTEMBUFFERMAPS = ds_map_create();

	#macro RENDER_QUEUE global.__SYSTEM_RENDER_QUEUE
	#macro BUFFER_MAPS global.__SYSTEMBUFFERMAPS
	
	#macro gm_DefaultState global.__SYSTEM_DEFAULT_STATE
	
#endregion

// Rendering functions
function pipeline_initiate()
{
	if ( !ds_exists(RENDER_QUEUE, ds_type_list) )	RENDER_QUEUE = ds_list_create();
	if ( !ds_exists(BUFFER_MAPS, ds_type_map) )		BUFFER_MAPS = ds_map_create();
	
	///@func pipeline_initiate()
	
	// default static buffer
	texref = sprite_get_texture(ico_texref, 0);
	default_shader = ( RenderShader == noone ? shd_default : RenderShader );
	fidelity_matrix = [];
	
	// Create fidelity matrices
	function render_build_fidelity() {
		///@func render_build_fidelity()
		if ( array_length(fidelity_matrix) < RENDER_FIDELITY ) 
		{
			for ( var i=0; i<round(RENDER_FIDELITY); i++ ){
				var zxtra = 1/RENDER_FIDELITY;
				fidelity_matrix[i] = matrix_build(0, 0, zxtra * i, 0, 0, 0, 1, 1, 1);
			}	
		}
	}
	uni = {
		amb_col : shader_get_uniform(shd_default, "ambient_color"),
		sun_col : shader_get_uniform(shd_default, "sun_color"),
		sun_int : shader_get_uniform(shd_default, "sun_intensity"),
		sun_pos : shader_get_uniform(shd_default, "sun_pos"),
			
		light_num		: shader_get_uniform(shd_default, "lightTotal"),
		light_position	: shader_get_uniform(shd_default, "lightPos"),
		light_color		: shader_get_uniform(shd_default, "lightColor"),
		light_range		: shader_get_uniform(shd_default, "lightRange"),
			
		light_is_cone	: shader_get_uniform(shd_default, "lightIsCone"),
		light_direction : shader_get_uniform(shd_default, "lightDirection"),
		light_cutoff	: shader_get_uniform(shd_default, "lightCutoffAngle")
	}
	
	uniReplace = {
		amb_col : shader_get_uniform(shd_defaultReplaceWhite, "ambient_color"),
		sun_col : shader_get_uniform(shd_defaultReplaceWhite, "sun_color"),
		sun_int : shader_get_uniform(shd_defaultReplaceWhite, "sun_intensity"),
		sun_pos : shader_get_uniform(shd_defaultReplaceWhite, "sun_pos"),
			
		light_num		: shader_get_uniform(shd_defaultReplaceWhite, "lightTotal"),
		light_position	: shader_get_uniform(shd_defaultReplaceWhite, "lightPos"),
		light_color		: shader_get_uniform(shd_defaultReplaceWhite, "lightColor"),
		light_range		: shader_get_uniform(shd_defaultReplaceWhite, "lightRange"),
			
		light_is_cone	: shader_get_uniform(shd_defaultReplaceWhite, "lightIsCone"),
		light_direction : shader_get_uniform(shd_defaultReplaceWhite, "lightDirection"),
		light_cutoff	: shader_get_uniform(shd_defaultReplaceWhite, "lightCutoffAngle")
	}
	
	uniLed = {
		amb_col : shader_get_uniform(shd_defaultLed, "ambient_color"),
		sun_col : shader_get_uniform(shd_defaultLed, "sun_color"),
		sun_int : shader_get_uniform(shd_defaultLed, "sun_intensity"),
		sun_pos : shader_get_uniform(shd_defaultLed, "sun_pos"),
			
		light_num		: shader_get_uniform(shd_defaultLed, "lightTotal"),
		light_position	: shader_get_uniform(shd_defaultLed, "lightPos"),
		light_color		: shader_get_uniform(shd_defaultLed, "lightColor"),
		light_range		: shader_get_uniform(shd_defaultLed, "lightRange"),
			
		light_is_cone	: shader_get_uniform(shd_defaultLed, "lightIsCone"),
		light_direction : shader_get_uniform(shd_defaultLed, "lightDirection"),
		light_cutoff	: shader_get_uniform(shd_defaultLed, "lightCutoffAngle")
	}
	
	uniGround = {
		amb_col : shader_get_uniform(shd_defaultGround, "ambient_color"),
		sun_col : shader_get_uniform(shd_defaultGround, "sun_color"),
		sun_int : shader_get_uniform(shd_defaultGround, "sun_intensity"),
		sun_pos : shader_get_uniform(shd_defaultGround, "sun_pos"),
			
		light_num		: shader_get_uniform(shd_defaultGround, "lightTotal"),
		light_position	: shader_get_uniform(shd_defaultGround, "lightPos"),
		light_color		: shader_get_uniform(shd_defaultGround, "lightColor"),
		light_range		: shader_get_uniform(shd_defaultGround, "lightRange"),
			
		light_is_cone	: shader_get_uniform(shd_defaultGround, "lightIsCone"),
		light_direction : shader_get_uniform(shd_defaultGround, "lightDirection"),
		light_cutoff	: shader_get_uniform(shd_defaultGround, "lightCutoffAngle")
	}
	
	
	function default_world_shader_set(_uni = uni){
		
		var uniforms = _uni;
	
		var uAmbCol = fauxton_world_environment.ambient_color;
		var uSunCol = fauxton_world_environment.sun_color;

		shader_set_uniform_f_array(uniforms.amb_col, WorldEnvironment.acol);
		shader_set_uniform_f_array(uniforms.sun_col, WorldEnvironment.scol);
			
		shader_set_uniform_f(uniforms.sun_int, fauxton_world_environment.sun_intensity);
		var s = fauxton_world_environment.sun_pos;
		shader_set_uniform_f_array(uniforms.sun_pos, s);
		
		// Lights		
		var _LightNum = instance_number(__fauxtonLight);
		shader_set_uniform_f(uniforms.light_num, _LightNum);
		
		if ( _LightNum > 0 )
        {
            var lPos = [];
    		var lCol = [];
    		var lRad = [];
    		var lType = [];
    		var lDir = [];
    		var lCutoff = [];
            
			for ( var i=0; i<_LightNum; i++ )
			{
				var lightId = instance_find(__fauxtonLight, i);
				array_insert(lPos, 0, lightId.x, lightId.y, lightId.z);
					
				var _c = color_return(lightId.color);
				array_insert(lCol, 0, _c[0], _c[1], _c[2]);
					
				array_insert(lRad, 0, lightId.range);
				
				array_insert(lType, 0, lightId.light_type);
				switch(lightId.light_type)
				{
					case eLightType.Point:
						array_insert(lCutoff, 0, dcos(360));
						array_insert(lDir, 0, 0, 0, 0);
					break;
					
					case eLightType.Spot:
						array_insert(lCutoff, 0, dcos( lightId.cutoff_angle ));
						array_insert(lDir, 0, 
							dcos(lightId.angle) * dcos(lightId.z_angle), 
							dsin(lightId.angle) * dcos(lightId.z_angle), 
							dsin(lightId.z_angle)
						);
					break;
				}
			}
			shader_set_uniform_f_array(uniforms.light_is_cone, lType);
			shader_set_uniform_f_array(uniforms.light_direction, lDir);
			shader_set_uniform_f_array(uniforms.light_cutoff,  lCutoff);
			
			shader_set_uniform_f_array(uniforms.light_position, lPos);
			shader_set_uniform_f_array(uniforms.light_color, lCol);
			shader_set_uniform_f_array(uniforms.light_range, lRad);
		}
	}
	render_build_fidelity();
	function load_buffer_maps() 
	{		
		
		if (!global.loadStaticBuffers and o_gameManager.alarm[0] == -1)
		{
			// Load all buffer maps
			for ( var i=ds_map_find_first(BUFFER_MAPS); !is_undefined(i); i = ds_map_find_next(BUFFER_MAPS, i) )
			{
				var b = BUFFER_MAPS[? i];
				if ( !b.loaded ){
					// Load and write to buffers 
					var l = b.load_pos + b.load_chunk;
					l = clamp(l, 0, ds_list_size(b.load_queue));
					var align = string_split(i, "_");
					var ha = real(align[2]);
					var va = real(align[3]);
					
					for ( var j = b.load_pos; j<l; j++ ) 
					{
						b.load_pos++;
						var m = b.load_queue[| j];
						
						__FauxtonWriteStaticSpriteStack( b.buffer, m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], ha, va);
					}
					
					// Complete loading
					if ( b.load_pos == ds_list_size(b.load_queue) )
					{
						show_debug_message("Buffer '"+string(i)+"': Succesfully Loaded! ");
						b.loaded = true;	
						ds_list_destroy(b.load_queue);
						if ( b.buffer < 0 ) { buffer_delete(b.buffer); b.buffer = -1; exit; }
						b.vertex_buffer = vertex_create_buffer_from_buffer(b.buffer, SYSTEM_VERTEX_FORMAT);
						
						if (global.saveStaticBuffers)
						{
							b.buffer = buffer_compress(b.buffer, 0, buffer_tell(b.buffer));
							buffer_save(b.buffer, get_project_path() + "content/buffers/" + string("{0}_{1}.sav", global.gameLevelName, i));
						}
						
						buffer_delete(b.buffer);
						vertex_freeze(b.vertex_buffer);
					}
				}
			}
		}
		else 
		{
			for ( var i=ds_map_find_first(BUFFER_MAPS); !is_undefined(i); i = ds_map_find_next(BUFFER_MAPS, i) )
			{
				var b = BUFFER_MAPS[? i];
				if ( !b.loaded )
				{
					b.buffer = buffer_load(get_project_path() + "content/buffers/" + string("{0}_{1}.sav", global.gameLevelName, i));
					b.buffer = buffer_decompress(b.buffer);
					
					b.loaded = true;	
					ds_list_destroy(b.load_queue);
					if ( b.buffer < 0 ) { buffer_delete(b.buffer); b.buffer = -1; exit; }
					b.vertex_buffer = vertex_create_buffer_from_buffer(b.buffer, SYSTEM_VERTEX_FORMAT);
					buffer_delete(b.buffer); 
					vertex_freeze(b.vertex_buffer);
				}
			}
		}
	}
	function render_buffer_maps()
	{
		for ( var b = ds_map_find_first(BUFFER_MAPS); !is_undefined(b); b = ds_map_find_next(BUFFER_MAPS, b) )
		{
			var buff = BUFFER_MAPS[? b];
			if ( !buff.loaded ){ continue; }
			
			// Buffer shader
			shader_set(buff.shader);
			default_world_shader_set();
			
			// Override shader
			if ( buff.uniform_script == -1 ){
				FauxtonUniformControl(buff.shader);
			} else {
				buff.uniform_script();	
			}
			
			if ( buff.matrix != -1 )
			{
				matrix_set(matrix_world, buff.matrix);
			}
			vertex_submit(buff.vertex_buffer, pr_trianglelist, texref);
		}
	}
}
function pipeline_load()
{
	if (instance_exists(o_gameManager) and o_gameManager.alarm[0] == -1)
	{
		render_build_fidelity();
		if ( !instance_exists(WorldEnvironment) )
		{
			fauxton_world_set_default_environment();	
		}

		load_buffer_maps();
	}
}
function pipeline_cleanup()
{
	// Cleanup buffer & buffer map
	for ( var i=ds_map_find_first(BUFFER_MAPS); !is_undefined(i); i = ds_map_find_next(BUFFER_MAPS, i)) {
		var _vb = BUFFER_MAPS[? i];
		if ( _vb.vertex_buffer != -1  )
		{
			vertex_delete_buffer(_vb.vertex_buffer);
		}
		if ( buffer_exists(_vb.buffer ) )
		{
			buffer_delete(_vb.buffer); 	
		}
		if ( ds_exists(_vb.load_queue, ds_type_list) ) ds_list_destroy(_vb.load_queue);
	}
	ds_map_destroy(BUFFER_MAPS);
	BUFFER_MAPS = ds_map_create();
	
	// Reset to gm's default state
	gpu_set_state(gm_DefaultState);
}
function pipeline_roomend(){
	// Clear our render queue
	ds_list_clear(RENDER_QUEUE);	
}
function pipeline_render()
{
	// Render the static buffer
	if ( RENDER_FIDELITY > 1 )
	{
		for ( var i=0; i<RENDER_FIDELITY; i++ )
		{
			matrix_set(matrix_world, fidelity_matrix[i]);
			render_buffer_maps();
		}
	} 
	else
	{
		render_buffer_maps();
	}
	
	// Render models
	shader_set(default_shader);
	default_world_shader_set();
	
	for ( var i=0; i<ds_list_size(RENDER_QUEUE); i++ )
	{	
		var m = RENDER_QUEUE[| i];
		if ( m == -1 ) { continue; }
		if ( !m.draw_enable ){ continue; }
		matrix_set(matrix_world, m.matrix_id);
		vertex_submit(m.model_id, pr_trianglelist, m.texture);
	}
	
	// Reset all shaders
	shader_reset();
	matrix_reset();
}
function pipeline_render_to_screen()
{
	// Reset matrices
	matrix_reset();
	
	if ( !instance_exists(Camera) )
	{
		gpu_set_state(gm_DefaultState);
		exit;
	}
	
	//if (!surface_exists(screenSurface))
	//{
	//	screenSurface = surface_create(800, 450);
	//}
	
	//surface_set_target(screenSurface);
	//draw_clear_alpha(c_white, 1);

	// Draw application surface & Post-processing
	var width = surface_get_width( application_surface );
	var height = surface_get_height( application_surface );
	var xScale = gui_width / width;
	var yScale = gui_height / height;
	
	if (Camera.pTo <= 90 or global.debugEdit)
	{
		draw_surface_stretched( application_surface, 0, 0, gui_width, gui_height );
	}
	else
	{
		draw_surface_general( application_surface, 0, 0, width, height, gui_width, gui_height, xScale, yScale, 180, c_white, c_white, c_white, c_white, 1);
	}
	
	//surface_reset_target();
}
