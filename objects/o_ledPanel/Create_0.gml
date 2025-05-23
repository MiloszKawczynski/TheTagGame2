z = 32;
color = c_yellow;
colorForShader = [color_get_red(color) / 255,
				  color_get_green(color) / 255,
				  color_get_blue(color) / 255]

ledsPatterns = array_create(0);
ledIndex = 0;
ledSpeed = 1.75;

isDirty = true;

array_push(ledsPatterns, 
{
	name: "TOPDOWN",
	led: scr_ledPattern_TOPDOWN()
});

array_push(ledsPatterns, 
{
	name: "PLATFORM",
	led: scr_ledPattern_PLATFORM()
});

array_push(ledsPatterns, 
{
	name: "COUNTDOWN",
	led: scr_ledPattern_COUNTDOWN()
});

array_push(ledsPatterns, 
{
	name: "ARMEZ",
	led: scr_ledPattern_ARMEZ()
});

array_push(ledsPatterns, 
{
	name: "COLOR",
	led: scr_ledPattern_COLOR()
});

setColorTo = function(newColor)
{
	if (color != newColor)
	{
        color = newColor;
		colorForShader = [color_get_red(color) / 255,
						  color_get_green(color) / 255,
						  color_get_blue(color) / 255]
	}
}

changePatternTo = function(index)
{
	array_clear(leds);
	with(o_ledPanel)
	{
		frame = 0;
	}
	
	isDirty = true;
	offset = 0;
	ledIndex = index;
	array_copy(leds, 0, ledsPatterns[index].led, 0, array_length(ledsPatterns[index].led));
}

editor = function()
{
	ImGui_position_3(8);
	color = ImGui.ColorEdit3("Color", color);
	
	var offsetBefore = offset;
	offset = ImGui.InputInt("Offset", offset);
	
	if (offset != offsetBefore)
	{
		with(o_ledPanel)
		{
			frame = 0;
		}
		
		isDirty = true;
	}
	
	offset = clamp(offset, 0, array_length(leds));
	
	if (ImGui.BeginCombo("Led Pattern", ledsPatterns[ledIndex].name, ImGuiComboFlags.HeightLarge))
	{
		for (var i = 0; i < array_length(ledsPatterns); i++)
		{				
			if (ImGui.Selectable(ledsPatterns[i].name, i == ledIndex))
			{
				changePatternTo(i);
			}
		}
	
		ImGui.EndCombo();
	}
	
	ledSpeed = ImGui.InputFloat("Led Speed", ledSpeed);
}

model = fauxton_model_create(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1);
fauxton_model_draw_enable(model, true);

modelPositionUniform = shader_get_uniform(shd_defaultLed, "modelPosition");
timeUniform = shader_get_uniform(shd_defaultLed, "time");
ledUniform = shader_get_uniform(shd_defaultLed, "led");
colorUniform = shader_get_uniform(shd_defaultLed, "color");

leds = array_create(0);
array_copy(leds, 0, ledsPatterns[ledIndex].led, 0, array_length(ledsPatterns[ledIndex].led));
frame = 0;
offset = 0;

alarm[0] = 30;