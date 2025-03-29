if (!global.debugEdit)
{
	var areAnyDirty = false;
	
	// Check if any of the panels' data changed.
	with (o_ledPanel)
	{
		// We assume that every o_ledPanel has the same amount of patterns. Changing amount of patterns
		// during runtime is not supported.
		// TODO: If that is the case we might as well just store all the patterns once, instead of
		//       in every o_ledPanel, but I don't think they take too much space so leaving it as
		//       a todo for now.
		if (other.ledPatternsAmount == 0)
		{
			other.ledPatternsAmount = array_length(ledsPatterns);
		}
		
		if (!isDirty)
		{
			continue;
		}
		
		areAnyDirty = true;
		offsetsArray = []
		break;
	}
	
	// If at least one of the panels changed, recreate the whole pattern and offset maps.
	if (areAnyDirty)
	{
		ds_map_clear(ledPanelsMap);
		
		for (var i = 0; i < instance_number(o_ledPanel); i++)
		{
			var ledPanel = instance_find(o_ledPanel, i);
			ledPanel.isDirty = false;
			array_push(offsetsArray, ledPanel.offset);
		
			var ledSamePatternMap = ds_map_find_value(ledPanelsMap, ledPanel.ledIndex);
		
			if (is_undefined(ledSamePatternMap))
			{
				var newLedPattern = ds_map_create();
				ds_map_add(newLedPattern, ledPanel.offset, [ledPanel]);
				ds_map_add(ledPanelsMap, ledPanel.ledIndex, newLedPattern);
			}
			else
			{
				var ledSameOffsetArray = ds_map_find_value(ledSamePatternMap, ledPanel.offset)
				array_push(ledSameOffsetArray, ledPanel);
			}
		}
		
		offsetsArray = array_unique(offsetsArray)
	}

	shader_set(shd_defaultLed);
	RenderPipeline.default_world_shader_set(RenderPipeline.uniLed);
	
	var commonToAllSet = false;
	var lastColor = undefined;
	
	for (var i = 0; i < ledPatternsAmount; i++)
	{
		var ledSamePatternMap = ds_map_find_value(ledPanelsMap, i);
		
		if (is_undefined(ledSamePatternMap))
		{
			continue;
		}
		
		for (var k = 0; k < array_length(offsetsArray); k++)
		{
			// NOTE: We don't need to check if it is undefined because offsetsArray only contains
			//       offsets that are actually used
			var ledSameOffsetArray = ds_map_find_value(ledSamePatternMap, offsetsArray[k])
			
			var commonOffsetSet = false;
		
			for (var panel = 0; panel < array_length(ledSameOffsetArray); panel++)
			{
				with (ledSameOffsetArray[panel])
				{
					if (!commonToAllSet)
					{
						shader_set_uniform_f(timeUniform, current_time);
						commonToAllSet = true;
					}
				
					if (!commonOffsetSet)
					{
						shader_set_uniform_f_array(ledUniform, leds[frame + offset]);

						commonOffsetSet = true;
					}
					
					if (lastColor != color)
					{
						shader_set_uniform_f_array(colorUniform, colorForShader);

						lastColor = color;
					}
				
					shader_set_uniform_f_array(modelPositionUniform, [x, y]);

					fauxton_model_draw_override(model);
				}
			}
		}
	}

	shader_reset();
}
