if (global.debugEdit)
{
	draw_set_color(c_white);
	
	var objectSprite = object_get_sprite(editorCurrentObject);
	
	var objectWidth = sprite_get_width(objectSprite);
	var objectHeight = sprite_get_height(objectSprite);
	
	var xScale = 1;
	var yScale = 1;
	
	if (editorDirection == EditorDirectionType.topLeft or editorDirection == EditorDirectionType.bottomRight)
	{
		xScale = -1;
	}
	
	if (keyboard_check(vk_alt))
	{
		xScale *= -1;
		yScale = -1;
	}
	
	if (editorCurrentObject == o_start)
	{
		draw_sprite_ext(object_get_sprite(editorCurrentObject), instance_number(o_start), cursorX + objectWidth / 2, cursorY + objectHeight / 2, xScale, yScale, 0, c_white, 1);
	}
	else
	{
		draw_sprite_ext(object_get_sprite(editorCurrentObject), 0, cursorX + objectWidth / 2, cursorY + objectHeight / 2, xScale, yScale, 0, c_white, 1);
	}
	draw_rectangle(cursorX, cursorY, cursorX + objectWidth, cursorY + objectHeight, true);
	
	if (cursorX != cursorXPressed or cursorY != cursorYPressed)
	{
		var left = cursorXPressed;
		var right = cursorX;
		var top = cursorYPressed;
		var bottom = cursorY;
		
		if (cursorX < cursorXPressed)
		{
			left = cursorX;
			right = cursorXPressed;
		}
			
		if (cursorY < cursorYPressed)
		{
			top = cursorY;
			bottom = cursorYPressed;
		}
		
		draw_set_color(c_lime);
		
		if (editorSlopeCreation and !mouse_check_button(mb_right))
		{
			switch(editorDirection)
			{
				case(EditorDirectionType.bottomRight):
				{
					draw_line(left, top, right + objectWidth, bottom + objectHeight);
					
					if (yScale == 1)
					{
						draw_line(left, top, left, bottom + objectHeight);
						draw_line(left, bottom + objectHeight, right + objectWidth, bottom + objectHeight);
					}
					else
					{
						draw_line(right + objectWidth, top, right + objectWidth, bottom + objectHeight);
						draw_line(left, top, right + objectWidth, top);
					}
										
					break;
				}
					
				case(EditorDirectionType.topRight):
				{
					draw_line(left, bottom + objectHeight, right + objectWidth, top);
					
					if (yScale == 1)
					{
						draw_line(left, bottom + objectHeight, right + objectWidth, bottom + objectHeight);
						draw_line(right + objectWidth, bottom + objectHeight, right + objectWidth, top);
					}
					else
					{
						draw_line(left, top, right + objectWidth, top);
						draw_line(left, bottom + objectHeight, left, top);
					}
										
					break;
				}

				case(EditorDirectionType.bottomLeft):
				{
					draw_line(left, bottom + objectHeight, right + objectWidth, top);
					
					if (yScale == 1)
					{
						draw_line(left, bottom + objectHeight, right + objectWidth, bottom + objectHeight);
						draw_line(right + objectWidth, bottom + objectHeight, right + objectWidth, top);
					}
					else
					{
						draw_line(left, top, right + objectWidth, top);
						draw_line(left, bottom + objectHeight, left, top);
					}
										
					break;
				}
					
				case(EditorDirectionType.topLeft):
				{
					draw_line(left, top, right + objectWidth, bottom + objectHeight);
					
					if (yScale == 1)
					{
						draw_line(left, bottom + objectHeight, right + objectWidth, bottom + objectHeight);
						draw_line(left, bottom + objectHeight, left, top);
					}
					else
					{
						draw_line(left, top, right + objectWidth, top);
						draw_line(right + objectWidth, bottom + objectHeight, right + objectWidth, top);
					}
					
					break;
				}
			}
		}
		else
		{		
			draw_rectangle(left, top, right + objectWidth, bottom + objectHeight, true);
		}
	}
	
	if (editorMirror)
	{
		draw_set_color(c_red);
		draw_line_width(room_width / 2, 0, room_width / 2, room_height, 2);
	}
	
	if (editorFlip)
	{
		draw_set_color(c_red);
		draw_line_width(0, room_height / 2, room_width, room_height / 2, 2);
	}
}