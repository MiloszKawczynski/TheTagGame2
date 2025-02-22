event_inherited();

z = 32;
color = c_yellow;

editor = function()
{
	ImGui_position_3();
	color = ImGui.ColorEdit3("Color", color);
	offset = ImGui.InputInt("Offset", offset, 1);
}

model = fauxton_model_create(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1);
fauxton_model_draw_enable(model, true);

modelPositionUniform = shader_get_uniform(shd_defaultLed, "modelPosition");
timeUniform = shader_get_uniform(shd_defaultLed, "time");
ledUniform = shader_get_uniform(shd_defaultLed, "led");
colorUniform = shader_get_uniform(shd_defaultLed, "color");

leds = scr_ledPattern_COLOR();
frame = 0;
offset = 0;

alarm[0] = 30;