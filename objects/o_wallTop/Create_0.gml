x = room_width / 2;
y = room_height / 2;
z = 33;

topModel = undefined;

editor = function()
{
	ImGui_position_3();
}

var sprite = "s_wallTopMask_" + global.gameLevelName;

if (sprite != "s_wallTopMask_" and sprite != "s_wallTopMask_empty")
{
	topModel = fauxton_model_create_plate(asset_get_index(sprite), 0, x, y, z, 0, 0, 0, 1, 1, 1, c_white, 1);
	fauxton_model_draw_enable(topModel, false);
}