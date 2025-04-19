keyboardShare = [10];
firstFreePlayer = 0;
isBindingFinilize = false;
numberOfPlayers = 4;

isWSADBind = false;
isArrowsBind = false;

input_source_mode_set(INPUT_SOURCE_MODE.FIXED);

input_source_set(INPUT_KEYBOARD, 10);
input_profile_set("keyboard_and_mouse", 10);

window_set_fullscreen(true);

function drawSlot(x, y, id)
{
	draw_set_font(f_test);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	var isActive = id == firstFreePlayer;
	var isPopulated = input_profile_get(id) != "_undefined" and input_profile_get(id) != undefined;
	
	var size = 300;
	var margin = 10;
	var x1 = x - size / 2;
	var y1 = y - size / 2;
	var x2 = x1 + size;
	var y2 = y1 + size;
	
	draw_set_color(c_black);
	draw_text(x, y1 - margin * 2, string("Player {0}", id + 1));
	
	draw_set_color(c_black);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_color(c_white);
	draw_rectangle(x1 + margin, y1 + margin, x2 - margin, y2 - margin * 2, false);
	
	if (!isActive)
	{
		draw_set_color(c_black);
		draw_set_alpha(0.75);
		
		if (isPopulated)
		{
			draw_set_color(c_lime);
			draw_set_alpha(0.25);
			
			if (isBindingFinilize)
			{
				draw_set_alpha(0.75);
			}
		}
		
		draw_rectangle(x1 + margin, y1 + margin, x2 - margin, y2 - margin * 2, false);
		draw_set_alpha(1);
	}
	
	draw_set_color(c_black);
	if (isPopulated)
	{
		switch(input_profile_get(id))
		{
			case("P1"):
			{
				draw_text(x, y, "WSAD\nbackspace\nto disconnect");
				break;
			}
			case("P2"):
			{
				draw_text(x, y, "^V<>\nend\nto disconnect");
				break;
			}
			case("gamepad"):
			{
				draw_text(x, y, "pad\nB / O\nto disconnect");
				break;
			}
		}
	}
	else 
	{
		if (isActive)
		{
			draw_text(x, y, "Press\nSPACE / RSHIFT\nA / X");
		}
	}
}

function calculateFirstFreePlayer()
{
	for (var i = 0; i < numberOfPlayers; i++)
	{
		if (input_profile_get(i) == "_undefined")
		{
			firstFreePlayer = i;
			break;
		}
	}
}

function disconnectPlayer(id)
{
	input_source_clear(id);
	input_profile_set("_undefined", id);
	
	if (input_profile_get(id + 1) == "_undefined")
	{
		return;
	}
	
	switch(input_profile_get(id + 1))
	{
		case("P1"):
		{
			input_source_set(INPUT_KEYBOARD, id,, false);
			input_profile_set("P1", id);	
			disconnectPlayer(id + 1);
			break;
		}
		
		case("P2"):
		{
			input_source_set(INPUT_KEYBOARD, id,, false);
			input_profile_set("P2", id);	
			disconnectPlayer(id + 1);
			break;
		}
		
		case("gamepad"):
		{
			input_source_set(input_source_get_array(id + 1)[0], id,, false);
			disconnectPlayer(id + 1);
			break;
		}
	}
}