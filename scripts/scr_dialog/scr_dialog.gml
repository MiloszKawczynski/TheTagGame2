function dialogMain(_width, _lines, _key, _color, _baseSpeed, _fastSpeed, _sprite, _font) constructor
{
	width = _width;
	key = _key;
	baseColor = _color;
	baseSpeed = _baseSpeed;
	fastSpeed = _fastSpeed;
	textboxSprite = _sprite;
	font = _font;
	lines = _lines;
	
	dialogText = "";
	drawSpeed = baseSpeed;
	allTalkers = undefined;
	talkers = undefined;
	
	isSpeaking = false;
	
	dictionary = ds_list_create();
	
	static dialogBox = function() constructor
	{
		lineList = ds_list_create();
		isDialogEnded = false;
	
		static addLine = function(line)
		{
			ds_list_add(lineList, line);
		}
	
		static getSize = function()
		{
			return ds_list_size(lineList);
		}
		
		static getNumberOfFullLines = function()
		{
			var numberOfFullLines = 0;
			for(var i = 0; i < getSize(); i++)
			{
				if (ds_list_find_value(lineList, i).lineText != "")
				{
					numberOfFullLines++;
				}
			}
			return numberOfFullLines;
		}
		
		static getLineText = function(_line)
		{
			return ds_list_find_value(lineList, _line).showText;
		}
	
		static setLineText = function(_line, _lineText)
		{
			ds_list_find_value(lineList, _line).setText(_lineText);
		}
		
		static showLineLetters = function(_line, _letters)
		{
			ds_list_find_value(lineList, _line).showLetters(_letters);
		}
		
		static clear = function()
		{
			for(var i = 0; i < getSize(); i++)
			{
				var l = ds_list_find_value(lineList, i)
				delete l;
			}
			ds_list_clear(lineList);
		}
		
		static getActiveLine = function()
		{
			for(var i = 0; i < getNumberOfFullLines(); i++)
			{
				var l = ds_list_find_value(lineList, i)
				if (!l.isDrawn())
				{
					return i;
				}
			}
			isDialogEnded = true;
			return ds_list_find_value(lineList, 0)
		}
	}

	static dialogLine = function() constructor
	{
		drawnLetters = 0;
		lineText = "";
		showText = "";
		
		static isDrawn = function()
		{
			return lineText == showText;
		}
	
		static setText = function(_lineText)
		{
			lineText = _lineText;
		}
		
		static showLetters = function(letters)
		{
			if drawnLetters < string_length(lineText)
			{
				drawnLetters += letters;
				if (drawnLetters > string_length(lineText))
				{
					drawnLetters = string_length(lineText);
				}
				showText = string_copy(lineText, 1, drawnLetters);
			}
			else
			{
				return true;
			}
		}
	}
	
	static dialogWave = function(_isHorizontalOrVertical, _speed, _chanel, _sync) constructor
	{
		isHorizontalOrVertical = _isHorizontalOrVertical;
		waveSpeed = _speed;
		chanel = _chanel;
		sync = _sync;
		factor = 1;
		
		wavePos = 0;
	}

	static dialogAccent = function(_name, _color, _textSpeed, _markup, _hideMarkup = true, _sdfEffects = undefined, _waveH=noone, _waveV=noone) constructor
	{
		name = _name;
		color = _color;
		textSpeed = _textSpeed;
		markup = _markup;
		hideMarkup = _hideMarkup;
		sdfEffects = _sdfEffects
		isSdfEnable = false;
		if  (sdfEffects != undefined)
		{
			isSdfEnable = true;
		}
		
		waveH =
		{
			isEnable: false,
			isHorizontalOrVertical: true,
			waveSpeed: 1,
			chanel: 0,
			sync: true,
			factor: 1,
		
			wavePos: 0
		}
		
		waveV =
		{
			isEnable: false,
			isHorizontalOrVertical: false,
			waveSpeed: 1,
			chanel: 0,
			sync: true,
			factor: 1,
		
			wavePos: 0
		}
		
		isOpen = false;
	
		isActive = false;
		lastPlace = -1;
		
		static waveUpdate = function()
		{
			if (waveH != noone)
			{
				waveH.wavePos += (waveH.waveSpeed / 50);
				if (waveH.wavePos > 1) {waveH.wavePos = 0;}
			}
			if (waveV != noone)
			{
				waveV.wavePos += (waveV.waveSpeed / 50);
				if (waveV.wavePos > 1) {waveV.wavePos = 0;}
			}
		}
	}
		
	box = new dialogBox();
	
	accentList = ds_list_create();
	
	static prepere = function()
	{	
		if (dialogText == "")
		{
			isSpeaking = false;
			return;
		}
		
		box.clear();
		
		repeat(lines)
		{
			box.addLine(new dialogLine());
		}
		
		drawSpeed = baseSpeed;
		
		for(var i = 0; i < box.getSize(); i++)
		{
			for(var j = 0; j < string_length(dialogText); j++)
			{
				var isEnter = false;
				var isBoxEnd = false;
				
				if (string_char_at(dialogText, j) == "`")
				{
					dialogText = string_replace(dialogText, "`", "");
					isEnter = true;
				}
				
				if (string_char_at(dialogText, j) == "¶")
				{
					dialogText = string_replace(dialogText, "¶", "");
					isEnter = true;
					isBoxEnd = true;
					nodeChange = true;
				}
				
				if (string_width(string_copy(dialogText, 1, j)) > width)
				{
					isEnter = true;
					if (string_char_at(dialogText, j + 1) == "¶")
					{
						dialogText = string_replace(dialogText, "¶", "");
						isBoxEnd = true;
						nodeChange = true;
					}
				}
				
				if (j == string_length(dialogText) - 1)
				{
					box.setLineText(i, dialogText);
					dialogText = "";
					isBoxEnd = true;
					break;
				}
				
				if (isEnter)
				{
					while (string_char_at(dialogText, j) != " ")
					{
						j--;
					}
					
					box.setLineText(i, string_copy(dialogText, 1, j));
					dialogText = string_delete(dialogText, 1, j);
					break;
				}
			}
			
			if (isBoxEnd)
			{
				break;
			}
		}
	}
	
	static init = function(_dialog, _allTalkers = undefined)
	{
		isSpeaking = true;
		
		allTalkers = _allTalkers;
		
		boxIndex = 0;
		
		talkers = ds_list_find_value(allTalkers, boxIndex);
		
		//<-Lock Player
	
		nodeChange = false;
		
		box.clear();
	
		for(var i = 0; i < lines; i++)
		{
			box.addLine(new dialogLine());
		}

		drawSpeed = baseSpeed;
		
		dialogText = _dialog;
		
		for (var i = 0; i < ds_list_size(dictionary); i++)
		{
			var entry = ds_list_find_value(dictionary, i);
				
			dialogText = string_replace_all(dialogText, entry.key, entry.value);
		}

		box.isDialogEnded = false;
		
		prepere();
	}
	
	static speak = function(_line)
	{
		box.showLineLetters(_line, drawSpeed);
	}
	
	static logic = function()
	{
		if (keyboard_check_released(key))
		{
			keyboard_clear(key);
			if (box.isDialogEnded)
			{
				box.isDialogEnded = false;
				if (nodeChange)
				{
					nodeChange = false;
					boxIndex++;
					talkers = ds_list_find_value(allTalkers, boxIndex);
				}
				prepere();
			}
			else
			{
				drawSpeed = fastSpeed;
			}
		}
	}
	
	static draw = function(_x, _y, width, height, cursorX, cursorY, portraitX, portraitY, portraitSpacing = 100, portraitScale = 1, size = 1)
	{
		cursorX = _x + cursorX;
		cursorY = _y + cursorY;
		
		var cw = camera_get_view_width(view_camera[0]);
		var ch = camera_get_view_height(view_camera[0]);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(font);
		draw_set_color(baseColor);
		
		//draw_sprite_stretched(textboxSprite, 0, _x, _y, width, height)
		
		var left = 0;
		var right = 0;
		
		for (var i = 0; i < array_length(talkers) ; i++)
		{
			var talker = talkers[i];
			
			if (talker.sprite == undefined)
			{
				continue;
			}
			
			var alpha = 0.25;
			
			if (talker.isActive)
			{
				alpha = 1;
			}
			
			if (talker.isMirrored)
			{
				draw_sprite_ext(talker.sprite, talker.image, cw - (portraitX + (right * portraitSpacing)), portraitY, -portraitScale, portraitScale, 0, c_white, alpha);
				right++;
			}
			else
			{
				draw_sprite_ext(talker.sprite, talker.image, portraitX + (left * portraitSpacing), portraitY, portraitScale, portraitScale, 0, c_white, alpha);
				left++;
			}
		}
        
        draw_sprite_stretched(textboxSprite, 0, _x, _y, width, height)
        draw_sprite_ext(s_characterSelectionName, 0, _x + 30, _y + 15, 0.4, 0.4, 0, c_white, 1);
        draw_set_font(f_countDown);
        draw_text(_x + 90, _y + 45, "Adam");
        draw_set_font(font);
		
		speak(box.getActiveLine());
		
		for(var o = 0; o < ds_list_size(accentList); o++)
		{
			var ac = ds_list_find_value(accentList, o);
					
			ac.isActive = false;
			ac.lastPlace = -1;
			ac.waveUpdate();
		}
					
		
		for(var i = 0; i < box.getNumberOfFullLines(); i++)
		{			
			spacingY = i * string_height(box.getLineText(0)) * size;
			
			for(var j = 0; j < string_length(box.getLineText(i)); j++)
			{
				if (j == 0)
				{
					spacingX = 0;
				}
				else
				{
					spacingX += string_width(string_copy(box.getLineText(i), j + 1, 1));
				}
				
				draw_set_color(baseColor);
				if (drawSpeed != fastSpeed)
				{
					drawSpeed = baseSpeed;
				}
				
				var skipLetter = false;
				var shiftX = 0
				var shiftY = 0
				
				font_enable_effects(font, false);
				
				for(var o = 0; o < ds_list_size(accentList); o++)
				{
					var ac = ds_list_find_value(accentList, o);
					
					if (ac.isActive)
					{
						if (drawSpeed != fastSpeed)
						{
							drawSpeed = baseSpeed * ac.textSpeed;
						}
						
						if (ac.isSdfEnable)
						{
							draw_set_color(c_white);
							font_enable_effects(font, true, ac.sdfEffects);
						}
						else
						{
							draw_set_color(ac.color);
						}
						
						if (ac.waveH.isEnable)
						{
							var waveXFinalPos = ac.waveH.wavePos + (j * 0.1 * !ac.waveH.sync);
							while(waveXFinalPos > 1)
							{
								waveXFinalPos--;
							}
							
							shiftX = animcurve_get_point(ac_dialogWaveX,ac.waveH.chanel,waveXFinalPos) * ac.waveH.factor;
						}
						
						if (ac.waveV.isEnable)
						{
							var waveYFinalPos = ac.waveV.wavePos + ( j * 0.1 * !ac.waveV.sync);
							while(waveYFinalPos > 1)
							{
								waveYFinalPos--;
							}
							
							shiftY = animcurve_get_point(ac_dialogWaveY,ac.waveV.chanel,waveYFinalPos) * ac.waveV.factor;
						}
					}
					
					if (ac.markup == string_char_at(box.getLineText(i), j + 1))
					{
						if (ac.lastPlace != (j + 1) * ((i + 1) * 100))
						{
							ac.isActive =! ac.isActive;
							ac.lastPlace = (j + 1) * ((i + 1) * 100);
							
							if (ac.hideMarkup)
							{
								skipLetter = true;
							}
							
							if (ac.isActive)
							{
								if (drawSpeed != fastSpeed)
								{
									drawSpeed = baseSpeed * ac.textSpeed;
								}
								
								if (ac.isSdfEnable)
								{
									draw_set_color(c_white);
									font_enable_effects(font, true, ac.sdfEffects);
								}
								else
								{
									draw_set_color(ac.color);
								}
							}
						}
					}
				}
				
				if (skipLetter)
				{
					spacingX -= string_width(string_copy(box.getLineText(i), j + 1, 1));
					continue;
				}
				
				draw_text_transformed(
				cursorX + spacingX + shiftX,
				cursorY + spacingY + shiftY,
				string_char_at(box.getLineText(i), j + 1),
				size,
				size,
				0)
			}
		}
	}
	
	static drawDebug = function(_x, _y, cursorX, cursorY)
	{
		draw_set_color(c_red);
		draw_set_font(font);
		draw_rectangle(_x + cursorX, _y + cursorY, _x + width, _y + (lines * string_height("A")), true);
	}
}