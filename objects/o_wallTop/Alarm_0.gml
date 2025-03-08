editor = function()
{
	ImGui_position_3();
}

var levelPlate = -1;

switch(global.gameLevelName)
{
	case("basic"):
	{
		levelPlate = 0;
		break;
	}
	
	case("fire"):
	{
		levelPlate = 2;
		break;
	}
	
	case("santa"):
	{
		levelPlate = 4;
		break;
	}
}

if (levelPlate != -1)
{
	topModel = fauxton_model_create_plate(sprite_index, levelPlate, x, y, z, 0, 0, 0, 1, 1, 1, c_white, 1);
	fauxton_model_draw_enable(topModel, false);
}