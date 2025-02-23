event_inherited();

z = 32;
color = c_yellow;

ledsPatterns = array_create(0);
ledIndex = 0;
ledSpeed = 1;

array_push(ledsPatterns, 
{
	name: "PLATFORM",
	led: scr_ledPattern_PLATFORM()
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
	}
	
	offset = clamp(offset, 0, array_length(leds));
	
	if (ImGui.BeginCombo("Led Pattern", ledsPatterns[ledIndex].name, ImGuiComboFlags.HeightLarge))
	{
		for (var i = 0; i < array_length(ledsPatterns); i++)
		{				
			if (ImGui.Selectable(ledsPatterns[i].name, i == ledIndex))
			{
				array_clear(leds);
				with(o_ledPanel)
				{
					frame = 0;
				}
				
				offset = 0;
				ledIndex = i;
				array_copy(leds, 0, ledsPatterns[ledIndex].led, 0, array_length(ledsPatterns[ledIndex].led));
			}
		}
	
		ImGui.EndCombo();
	}
	
	ledSpeed = ImGui.InputInt("Led Speed", ledSpeed);
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