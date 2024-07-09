event_inherited();

var dokumentacjaJestRobiona = !true;

if (dokumentacjaJestRobiona)
{
	ui = new UI();

	with(ui)
	{
		mainLayer = new Layer();
		mainLayer.setGrid(3, 3, true);

		output = new Output();
		
		with(output)
		{
			time = 0;
			var normal = function()
			{
				time = timer(time, 0.03, 2 * pi);
				draw_sprite_ext(ats_checkboxOwnUncheck, 0, posX, posY, 1, 1, sin(time) * 45, c_white, 1);
				
			}
			
			setDrawFunction(normal);
		}
		
		mainLayer.addComponent(1, 1, output);

		pushLayer(mainLayer);
	}
}
else
{
	ui = new UI();

	with(ui)
	{
		mainLayer = new Layer();
		mainLayer.setGrid(1, 8);
	
		#region Input
			#region Buttons
			//---Buttons
	
			buttonGroup = new Group();
			buttonGroup.setGrid(4, 2)
	
			buttonText = new Text("Buttons", atf_font, fa_left,, 8);
			buttonText.setScale(0.5, 0.5);
	
			var buttonFunction = function()
			{
				show_debug_message("Clicked!");
			}
	
			buttonComplex = new Button(buttonFunction);
			buttonComplex.setSpriteSheet(ats_button);
	
			buttonAnimated = new Button(buttonFunction);
			buttonAnimated.setSprites(ats_buttonNormal, ats_buttonHover, ats_buttonPress, ats_buttonFocus);
	
			buttonOwn = new Button(buttonFunction);
			with(buttonOwn)
			{
				time = 0;
		
				var normal = function()
				{
					time = timer(time, 0.35, 2 * pi);
					draw_set_color(c_red);
					scr_p5Button([7, 2, 35, 10, 2, 15, 30, 18, 23, 22, 29, 20, 23, 27, 46, 25]);
					draw_set_color(c_black);
					scr_p5Button([2, 5, 32, 11, 14, 25, 27, 20, 46, 25], pi);
			
					var _x = posX + sin(time) * -0.5;
					var _y = posY + sin(time) * 0.5;
			
					draw_sprite(ats_buttonOwn, 0, _x, _y);
				}
		
				var hover = function()
				{
					time = timer(time, 0.15, 2 * pi);
					draw_set_color(c_black);
					scr_p5Button([7, 2, 35, 10, 2, 15, 30, 18, 23, 22, 29, 20, 23, 27, 46, 25]);
					draw_set_color(c_red);
					scr_p5Button([2, 5, 32, 11, 14, 25, 27, 20, 46, 25], pi);
			
					var _x = posX + sin(time) * -0.5;
					var _y = posY + sin(time) * 0.5;
			
					draw_sprite_ext(ats_buttonOwn, 0, _x, _y,1,1,0,c_black,1);
				}
		
				var press = function()
				{
					time = timer(time, 0.15, 2 * pi);
					draw_set_color(c_black);
					scr_p5Button([7, 2, 35, 10, 2, 15, 30, 18, 23, 22, 29, 20, 23, 27, 46, 25]);
					draw_set_color(c_red);
					scr_p5Button([2, 5, 32, 11, 14, 25, 27, 20, 46, 25], pi);
			
					var _x = posX + sin(time) * -0.5;
					var _y = posY + sin(time) * 0.5;
			
					draw_sprite_ext(ats_buttonOwn, 0, _x, _y,1,1,0,c_yellow,1);
				}
		
				var focus = function()
				{
					time = timer(time, 0.35, 2 * pi);
					draw_set_color(c_aqua);
					scr_p5Button([3, 21, 39, 3, 41, 25], pi * 3 / 4);
					draw_set_color(c_red);
					scr_p5Button([7, 2, 35, 10, 2, 15, 30, 18, 23, 22, 29, 20, 23, 27, 46, 25]);
					draw_set_color(c_black);
					scr_p5Button([2, 5, 32, 11, 14, 25, 27, 20, 46, 25], pi);
			
					var _x = posX + sin(time) * -0.5;
					var _y = posY + sin(time) * 0.5;
			
					draw_sprite(ats_buttonOwn, 0, _x, _y);
				}
		
				setDrawFunctions(normal, hover, press, focus, 48, 32);
			}
	
			buttonGroup.addComponent(1, 1, buttonComplex);
			buttonGroup.addComponent(2, 1, buttonAnimated);
			buttonGroup.addComponent(3, 1, buttonOwn);
	
			#endregion
			#region Checboxes
			//---Checkboxes

			checkboxGroup = new Group();
			checkboxGroup.setGrid(4, 2)
	
			checkboxText = new Text("Checkboxes", atf_font, fa_left,, 8);
			checkboxText.setScale(0.5, 0.5);
	
			var checkboxFunction = function(_value)
			{
				if (_value)
				{
					show_debug_message("Checked!");
				}
				else
				{
					show_debug_message("Unchecked!");
				}
			}
	
			checkboxComplex = new Checkbox(checkboxFunction);
			checkboxComplex.setSpriteSheet(ats_checkboxUnchecked, ats_checkboxChecked);
	
			checkboxAnimated = new Checkbox(checkboxFunction);
			checkboxAnimated.setSprites(ats_checkboxUncheckNormal, ats_checkboxCheckNormal, ats_checkboxUncheckHover, ats_checkboxCheckHover, ats_checkboxUncheckPress, ats_checkboxCheckPress, ats_checkboxUncheckFocus, ats_checkboxCheckFocus);
	
			checkboxOwn = new Checkbox(checkboxFunction);
			with(checkboxOwn)
			{
				time = 0;
		
				var normal = function(_value)
				{
					draw_set_alpha(1);
					time = timer(time, 0.05, 2 * pi);
			
					if (!_value)
					{
						draw_sprite_ext(ats_checkboxOwnUncheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
					}
					else
					{
						draw_sprite_ext(ats_checkboxOwnCheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
						draw_set_alpha(sin(time));
						draw_sprite_ext(ats_checkboxOwnGlow, 0, posX, posY, 1, 1, sin(time), c_white, sin(time)); 
					}
					draw_set_alpha(1);
				}
		
				var hover = function(_value)
				{
					draw_set_alpha(1);
					time = timer(time, 0.05, 2 * pi);
			
					if (!_value)
					{
						draw_sprite_ext(ats_checkboxOwnUncheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
					}
					else
					{
						draw_sprite_ext(ats_checkboxOwnCheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
						draw_set_alpha(sin(time));
						draw_sprite_ext(ats_checkboxOwnGlow, 0, posX, posY, 1, 1, sin(time), c_white, sin(time)); 
					}
					draw_set_alpha(1);
				}
		
				var press = function(_value)
				{
					draw_set_alpha(1);
					time = timer(time, 0.05, 2 * pi);
			
					draw_sprite_ext(ats_checkboxOwnPress, 0, posX, posY, 1, 1, sin(time), c_white, 1); 

					draw_set_alpha(1);
				}
		
				var focus = function(_value)
				{
					draw_set_alpha(1);
					time = timer(time, 0.05, 2 * pi);
			
					draw_sprite_ext(ats_checkboxOwnBackground, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
			
					if (!_value)
					{
						draw_sprite_ext(ats_checkboxOwnUncheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
					}
					else
					{
						draw_sprite_ext(ats_checkboxOwnCheck, 0, posX, posY, 1, 1, sin(time), c_white, 1); 
						draw_set_alpha(time);
						draw_sprite_ext(ats_checkboxOwnGlow, 0, posX, posY, 1, 1, sin(time), c_white, sin(time)); 
					}
					draw_set_alpha(1);
				}
		
				setDrawFunctions(normal, hover, press, focus, 32, 32);
			}
	
			checkboxGroup.addComponent(1, 1, checkboxComplex);
			checkboxGroup.addComponent(2, 1, checkboxAnimated);
			checkboxGroup.addComponent(3, 1, checkboxOwn);
			#endregion
			#region Sliders
			//---Sliders
			sliderGroup = new Group();
			sliderGroup.setGrid(4, 2)
	
			sliderText = new Text("Sliders", atf_font, fa_left,, 8);
			sliderText.setScale(0.5, 0.5);
	
			var sliderFunction = function(_value)
			{
				show_debug_message("Slide {0}!", _value);
		
				gradientBarAnimated1.setValue(_value);
				gradientBarAnimated2.setValue(_value);
				gradientBarOwn.setValue(_value);
		
				pointBarOwn.setValue(floor(lerp(0, 6, _value)))
			}
	
			sliderComplex = new Slider(sliderFunction);
			sliderComplex.setSpriteSheet(ats_slider, ats_sliderDot);
	
			sliderAnimated = new Slider(sliderFunction);
			sliderAnimated.setSprites(ats_slider, ats_sliderDotNormal, ats_sliderDotHover, ats_sliderDotPress, ats_sliderDotFocus);
			sliderAnimated.setMargin(10, 10);
	
			sliderOwn = new Slider(sliderFunction);
			sliderOwn.setMargin(10, 5);
			with(sliderOwn)
			{
				mouse_xPrevious = 0;
				time = 0;
		
				_ps = part_system_create();
				part_system_draw_order(_ps, true);
		
				_ptype1 = part_type_create();
				part_type_shape(_ptype1, pt_shape_pixel);
				part_type_size(_ptype1, 0.4, 0.6, 0.02, 0.1);
				part_type_scale(_ptype1, 1, 1);
				part_type_speed(_ptype1, 0.5, 0.5, 0.005, 0);
				part_type_direction(_ptype1, 80, 100, 0, 0);
				part_type_gravity(_ptype1, 0, 270);
				part_type_orientation(_ptype1, 0, 0, 0, 1, false);
				part_type_colour3(_ptype1, $00FAFF, $0077FF, $000091);
				part_type_alpha3(_ptype1, 1, 0.788, 0);
				part_type_blend(_ptype1, false);
				part_type_life(_ptype1, 5, 30);
		
				_pemit1 = part_emitter_create(_ps);
				part_emitter_region(_ps, _pemit1, -24, 24, -8, 8, ps_shape_rectangle, ps_distr_gaussian);
				part_emitter_stream(_ps, _pemit1, _ptype1, -2);
		
				var slider = function()
				{
					part_system_position(_ps, posX + 6, posY - 6);
					part_type_alpha3(_ptype1, value / 1, value / 1 * 0.788, 0);
	
					draw_sprite(ats_sword, 1, posX, posY);
					draw_sprite_ext(ats_swordRedBlade, 1, posX, posY, 1, 1, 0, c_white, value / 1);
				}
		
				var normal = function()
				{
					var _x = posX - ((width / 2) - left) + ((width - (left + right)) * value);
					var _y = posY;
					draw_sprite(ats_cloth, 1, _x, _y);
				}
		
				var hover = function(_value)
				{
					var _x = posX - ((width / 2) - left) + ((width - (left + right)) * value);
					var _y = posY;
					draw_sprite(ats_cloth, 3, _x, _y);
				}
		
				var press = function(_value)
				{
					var _x = posX - ((width / 2) - left) + ((width - (left + right)) * value);
					var _y = posY;
			
					var _subimg = 1;
					if (abs(mouse_x - mouse_xPrevious) > 0.5)
					{
						_subimg = sign(mouse_x - mouse_xPrevious) + 1;
					}
			
					draw_sprite(ats_cloth, _subimg, _x, _y);
			
					mouse_xPrevious = mouse_x;
				}
		
				var focus = function(_value)
				{
					time = timer(time, 0.03);
			
					var _x = posX - ((width / 2) - left) + ((width - (left + right)) * time) - 3;
					draw_sprite_ext(ats_swordGlow, 0, _x, posY, 1, 1, 0, c_white, max(sin(time * pi + pi / 3), 0.25));
			
					_x = posX - ((width / 2) - left) + ((width - (left + right)) * value);
					var _y = posY;
					draw_sprite(ats_cloth, 1, _x, _y);
				}
		
				setDrawFunctions(slider, normal, hover, press, focus, 48, 16);
			}
	
			sliderGroup.addComponent(1, 1, sliderComplex);
			sliderGroup.addComponent(2, 1, sliderAnimated);
			sliderGroup.addComponent(3, 1, sliderOwn);
	
			#endregion
			#region Radios
			//---Radios
			radioGroup = new Group();
			radioGroup.setGrid(4, 2)
	
			radioText = new Text("Radios", atf_font, fa_left,, 8);
			radioText.setScale(0.5, 0.5);
	
			var radioFunction = function(_value)
			{
				show_debug_message("Radio {0}!", _value);
		
				if(!is_string(_value))
				{
					pointBarComplex.setValue(_value);
					pointBarAnimated.setValue(_value);
				//	pointBarComplex.setValue(_value);
				}
			}
	
			radioComplex = new Radio(radioFunction, ["A", "B", "C", "D"], 16, 0,, -24);
			radioComplex.setSpriteSheet(ats_radioUnchecked, ats_radioChecked);
	
			radioAnimated = new Radio(radioFunction, ["A", "B", "C"], 0, 16, 1);;
			radioAnimated.setSprites(ats_radioNormal, ats_radioCheck, ats_radioHover, ats_radioHoverCheck, ats_radioPress, ats_radioPressCheck, ats_radioFocus, ats_radioFocusCheck);
			radioAnimated.setReturnText();
			radioAnimated.setDrawText(atf_font, fa_left,, 12, 1);
	
			radioOwn = new Radio(radioFunction, ["Cool", "Radio", "Buttons"], 0, 16, 2,, 8);
			radioOwn.setDrawText(atf_smallFont, fa_left, fa_middle, 3, -7);
			radioOwn.setReturnText();
			with(radioOwn)
			{
				time = 0;
				spriteTime = 0;
		
				var normal = function(_value)
				{
					time = timer(time, 0.02, 2 * pi);
			
					scr_sonic06Radio([1, 4, 3, 2, 1, 7, 4, 2, 4, 10, 5, 1, 7, 13, 11, 1, 10, 14, 25, 1, 25, 14, 47, 1, 47, 14]);
			
					if (_value)
					{	
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_aqua);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_aqua);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_aqua);
						draw_sprite_ext(ats_glowArrows, 0, posX - 8.5, posY - 8.5, 1, 1, 0, c_white, lerp(0.3, 0.75, sin(time)));
					}
					else
					{
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_gray);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_gray);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_gray);
					}
				}
		
				var hover = function(_value)
				{
					spriteTime = timer(spriteTime, sprite_get_speed(ats_glowArrowsAnimated) / game_get_speed(gamespeed_fps), sprite_get_number(ats_glowArrowsAnimated));
			
					scr_sonic06Radio([1, 4, 3, 2, 1, 7, 4, 2, 4, 10, 5, 1, 7, 13, 11, 1, 10, 14, 25, 1, 25, 14, 47, 1, 47, 14]);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_aqua);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_aqua);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_aqua);
					draw_sprite_ext(ats_glowArrowsAnimated, spriteTime, posX - 8.5, posY - 8.5, 1, 1, 0, c_white, 1);
				}
		
				var press = function(_value)
				{
					spriteTime = timer(spriteTime, sprite_get_speed(ats_glowArrowsAnimated) / game_get_speed(gamespeed_fps), sprite_get_number(ats_glowArrowsAnimated));
			
					scr_sonic06Radio([1, 4, 3, 2, 1, 7, 4, 2, 4, 10, 5, 1, 7, 13, 11, 1, 10, 14, 25, 1, 25, 14, 47, 1, 47, 14]);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_aqua);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_aqua);
					scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_aqua);
					draw_sprite_ext(ats_glowArrowsAnimated, spriteTime, posX - 8.5, posY - 8.5, 1, 1, 0, c_white, 1);
				}
		
				var focus = function(_value)
				{
					time = timer(time, 0.02, 2 * pi);
			
					scr_sonic06Radio([1, 4, 3, 2, 1, 7, 4, 2, 4, 10, 5, 1, 7, 13, 11, 1, 10, 14, 25, 1, 25, 14, 47, 1, 47, 14]);
			
					if (_value)
					{	
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_aqua);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_aqua);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_aqua);
						draw_sprite_ext(ats_glowArrows, 0, posX - 8.5, posY - 8.5, 1, 1, 0, c_white, lerp(0.3, 0.75, sin(time)));
					}
					else
					{
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13],,, c_gray);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 4,, c_gray);
						scr_sonic06Arrow([11, 2, 11, 5, 12, 4, 12, 6, 13, 6, 14, 7, 13, 7, 14, 8, 13, 9, 12, 9, 12, 11, 11, 10, 11, 13], 8,, c_gray);
					}
				}
		
				setDrawFunctions(normal, hover, press, focus, 48, 32);
			}
	
			radioGroup.addComponent(1, 1, radioComplex);
			radioGroup.addComponent(2, 1, radioAnimated);
			radioGroup.addComponent(3, 1, radioOwn);
	
			#endregion
			#region InputTexts
			//---Inputs
			inputGroup = new Group();
			inputGroup.setGrid(4, 2)
	
			inputText = new Text("Inputs", atf_font, fa_left,, 8, 16);
			inputText.setScale(0.5, 0.5);
	
			var inputFunction = function(_value)
			{
				show_debug_message("Input {0}!", _value);
			}
	
			inputComplex = new InputText(inputFunction, 5, "Red",, 16);
			inputComplex.setSpriteSheet(ats_input);
			inputComplex.setIgnoreCharacters(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]);
	
			inputAnimated = new InputText(inputFunction, 4, "2137",, 16);
			inputAnimated.setSprites(ats_inputNormal, ats_inputHover, ats_inputPress, ats_inputFocus);
			inputAnimated.setAcceptableCharacters(["2", "1", "3", "7"]);
	
			inputOwn = new InputText(inputFunction, 7, "HatTime",, 16);
	
			with(inputOwn)
			{
				time = 0;
				text.setShift(-25, 0);
				text.setScale(0.6, 0.6);
				text.setSpacing(9);
		
				var normal = function(_value)
				{
					draw_sprite(ats_inputOwn, 0, posX, posY);
					text.draw();
				}
		
				var hover = function(_value)
				{
					time = timer(time, 0.1, pi * 2);
					draw_sprite(ats_inputOwn, 0, posX, posY);
					text.draw();
					draw_sprite(ats_inputPencil, 0, device_mouse_x_to_gui(0) + sin(time), device_mouse_y_to_gui(0) - sin(time));
				}
		
				var press = function(_value)
				{
					draw_sprite(ats_inputOwn, 0, posX, posY);
					text.draw();
					draw_sprite(ats_inputPencil, 0, device_mouse_x_to_gui(0) - 1, device_mouse_y_to_gui(0) + 1);
				}
		
				var focus = function(_value)
				{
					time = timer(time, 0.1, pi * 2);
					draw_sprite(ats_inputOwn, 0, posX, posY);
					text.draw();
			
					if (string_length(content) == maxCharacters)
					{
						draw_sprite_ext(ats_inputPencil, 0, posX - 24 + (text.spaceX * string_length(content)) + sin(time), posY - 6 + cos(time), 1, 1, 180, c_white, 1);
					}
					else
					{
						draw_sprite(ats_inputPencil, 0, posX - 18 + (text.spaceX * string_length(content)) + sin(time), posY - 10 + cos(time));
					}
				}
		
				setDrawFunctions(normal, hover, press, focus, 80, 48);
			}
	
			inputGroup.addComponent(1, 1, inputComplex);
			inputGroup.addComponent(2, 1, inputAnimated);
			inputGroup.addComponent(3, 1, inputOwn);
	
			#endregion
			#region DragAndDrops
			//---DragAndDrops
			dragAndDropGroup = new Group();
			dragAndDropGroup.setGrid(4, 2)
	
			dragAndDropText = new Text("Drag and Drops", atf_font, fa_left,, 8);
			dragAndDropText.setScale(0.5, 0.5);
	
			var dragFunction = function(_x, _y)
			{
				show_debug_message("Drag x: {0} y: {1}!", _x, _y);
			}
	
			var dropFunction = function(_x, _y)
			{
				show_debug_message("Drop x: {0} y: {1}!", _x, _y);
			}
	
			dragAndDropComplex = new DragAndDrop(dragFunction, dropFunction);
			dragAndDropComplex.setSpriteSheet(ats_dragAndDrop);
	
			dragAndDropAnimated = new DragAndDrop(dragFunction, dropFunction);
			dragAndDropAnimated.setSprites(ats_dragAndDropNormal, ats_dragAndDropHover, ats_dragAndDropPress, ats_dragAndDropFocus);
	
			dragAndDropOwn = new DragAndDrop(dragFunction, dropFunction,, -16);
	
			with(dragAndDropOwn)
			{
				time = 0;
				mouse_xPrevious = 0;
				draged = 0;
		
				var normal = function(_value)
				{
					draw_sprite(ats_panda, 0, posX, posY);
				}
		
				var hover = function(_value)
				{
					draw_sprite(ats_panda, 0, posX, posY);
					draw_sprite(ats_graber, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
				}
		
				var press = function(_value)
				{
					if (abs(mouse_x - mouse_xPrevious) > 0.5)
					{
						draged = 2;
						if (sign(mouse_x - mouse_xPrevious) == 1)
						{
							draw_sprite(ats_pandaGrab, 5, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
						}
						else
						{
							draw_sprite(ats_pandaGrab, 2, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
						}
					}
					else
					{
						time = timer(time, sprite_get_speed(ats_pandaGrab) / game_get_speed(gamespeed_fps), sprite_get_number(ats_pandaGrab));
				
						if (draged > 0)
						{				
							if (time == 0)
							{
								draged --;
							}
							draw_sprite(ats_pandaGrab, time, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
						}
						else
						{
							draw_sprite(ats_pandaGrab, 3, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0));
						}
					}
			
					mouse_xPrevious = mouse_x;
				}
		
				var focus = function(_value)
				{
					draw_sprite(ats_panda, 0, posX, posY);
				}
		
				setDrawFunctions(normal, hover, press, focus, 20, 20);
			}
	
			dragAndDropGroup.addComponent(1, 1, dragAndDropComplex);
			dragAndDropGroup.addComponent(2, 1, dragAndDropAnimated);
			dragAndDropGroup.addComponent(3, 1, dragAndDropOwn);
	
			#endregion
			#region Grab
			//---Grab
			grab = new Grab(, buttonGroup);
	
			#endregion
		#endregion
		#region Output
			#region GradientBar
			//---GradientBar
	
			gradientBarText = new Text("Gradient Bar", atf_font, fa_left,, 8);
			gradientBarText.setScale(0.5, 0.5);
	
			gradientBarGroup = new Group();
			gradientBarGroup.setGrid(4, 2);
	
			// Gradient bar don't have complex version so I show two types of animated one instead
	
			gradientBarAnimated1 = new GradientBar(0.25);
			gradientBarAnimated1.setSprites(ats_gradientBarBackground, ats_gradientBarValueBasic, ats_gradientBarFront);
	
			gradientBarAnimated2 = new GradientBar(0.5);
			gradientBarAnimated2.setSprites(ats_gradientBarBackground, ats_gradientBarValueAnimated, ats_gradientBarFront);
	
			gradientBarOwn = new GradientBar(0.75, 16);
	
			with(gradientBarOwn)
			{
				time = 0;
		
				var draw = function()
				{					
					time = timer(time, 0.05, 2 * pi);
			
					var _path = path_duplicate(atpth_circle);
					path_shift(_path, posX - width / 2, posY - height / 2);
			
					var _path2 = path_duplicate(atpth_line);
					path_shift(_path2, posX - width / 2, posY - height / 2);
			
					var barValue = 1 - value;
			
					var c_lightGreen = make_color_rgb(100, 235, 16);
					var c_lightYellow = make_color_rgb(184, 255, 51);
		
			
					draw_set_color(c_black);
			
					draw_ribbon(_path2, 4, 0.01);
					draw_ribbon_color(_path2, 3, c_lightYellow, c_lightGreen, 0.01, max(barValue * 2, 0.01));

					draw_ribbon(_path, 4, 0.01,, 0.9);
					draw_ribbon_color(_path, 3, c_lightYellow, c_lightGreen, 0.01, 0.9 - (value * 2), 0.89);
			
					draw_sprite_ext(ats_micky, 0, posX, posY, 1, 1, sin(time) * 2, c_white, 1);
				}
		
				setDrawFunction(draw, 32, 32);
			}
	
			gradientBarGroup.addComponent(1, 1, gradientBarAnimated1);
			gradientBarGroup.addComponent(2, 1, gradientBarAnimated2);
			gradientBarGroup.addComponent(3, 1, gradientBarOwn);
	
			#endregion
			#region PointBar
			//---PointBar
	
			pointBarText = new Text("Point Bar", atf_font, fa_left,, 8);
			pointBarText.setScale(0.5, 0.5);
	
			pointBarGroup = new Group();
			pointBarGroup.setGrid(4, 2);
	
			pointBarComplex = new PointBar(2, 3, 16,, -16);
			pointBarComplex.setSpriteSheet(ats_pointBarValue);
	
			pointBarAnimated = new PointBar(1, 3,, 16, ,-16);
			pointBarAnimated.setSprites(ats_pointBarEmpty, ats_pointBarFull);
	
			pointBarOwn = new PointBar(3, 6, 7,, -16);
	
			with(pointBarOwn)
			{
				time = 0;
		
				var draw = function()
				{						
					var _posX = posX;
					var _posY = posY;
			
					time = timer(time, 0.03, 1);
			
					for(var i = 0; i < maxValue; i++)
					{	
						var hearthJump = 0;
						var hearthBump = 1;
				
						if (value <= 3)
						{
							var timeTmp = (time + (i / maxValue));
					
							while(timeTmp > 1)
							{
								timeTmp--;
							}
					
							hearthJump = animcurve_get_point(atac_hearth, 0, timeTmp) * 2;
						}
						else
						{
							var timeTmp = (time + (i / maxValue));
					
							while(timeTmp > 1)
							{
								timeTmp--;
							}
					
							hearthBump = 1 + animcurve_get_point(atac_hearth, 0, timeTmp) * 0.1;
						}
				
						posX = _posX + (i * horizontalDisplacement);
						posY = _posY + (i * verticalDisplacement);
				
						var _submimg;
				
						_submimg = i mod 2;
				
						if (i >= value)
						{
							_submimg += 2;
						}
				
						draw_sprite_ext(ats_pointBarOwn, _submimg, posX, posY + hearthJump, hearthBump, hearthBump, 0, c_white, 1);
				
						i++;
				
						if (i >= maxValue)
						{
							break;
						}
				
						_submimg = i mod 2;
				
						if (i >= value)
						{
							_submimg += 2;
						}
				
						draw_sprite_ext(ats_pointBarOwn, _submimg, posX, posY + hearthJump, hearthBump, hearthBump, 0, c_white, 1);
					}
			
					posX = _posX;
					posY = _posY;
				}
		
				setDrawFunctions(draw, 32, 32);
			}
	
			pointBarGroup.addComponent(1, 1, pointBarComplex);
			pointBarGroup.addComponent(2, 1, pointBarAnimated);
			pointBarGroup.addComponent(3, 1, pointBarOwn);
	
			#endregion
		#endregion
		#region Scroll
		//---Scroll
	
		scroll = new Scroll(height, height / 8,, -16); 
		scroll.setMargin(5, 5);
		scroll.setSpriteSheet(ats_scroll, ats_scrollDot);
		scroll.setSmooth(atac_scroll);
	
		#endregion
		
		#region AddingComponentsToLayer
		//---AddingComponentsToLayer
	
		mainLayer.addComponent(0, 1, buttonText);
		mainLayer.addComponent(0, 0.5, buttonGroup);
	
		mainLayer.addComponent(0, 2, checkboxText);
		mainLayer.addComponent(0, 1.5, checkboxGroup);
	
		mainLayer.addComponent(0, 3, sliderText);
		mainLayer.addComponent(0, 2.5, sliderGroup);
	
		mainLayer.addComponent(0, 4, radioText);
		mainLayer.addComponent(0, 3.5, radioGroup);
	
		mainLayer.addComponent(0, 6, gradientBarText);
		mainLayer.addComponent(0, 5.5, gradientBarGroup);
	
		mainLayer.addComponent(0, 7, pointBarText);
		mainLayer.addComponent(0, 6.5, pointBarGroup);
	
		mainLayer.addComponent(0, 8, inputText);
		mainLayer.addComponent(0, 7.5, inputGroup);
	
		mainLayer.addComponent(0, 10, dragAndDropText);
		mainLayer.addComponent(0, 9.5, dragAndDropGroup);
	
		mainLayer.addComponent(1, 11.5, grab);
	
		mainLayer.addComponent(1, 1, scroll);
	
		pushLayer(mainLayer);
		#endregion
	}
}