x = room_width / 2;
y = room_height / 2;
z = 32;

topModel = fauxton_model_create_ext(sprite_index, x, y, z, 0, 0, 0, 1, 1, 1, c_white, 1);

editor = function()
{
	ImGui_position_3();
}

fauxton_model_draw_enable(topModel, false);
