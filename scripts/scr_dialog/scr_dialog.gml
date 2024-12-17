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
	firstPerson = noone;
	secondPerson = noone;
	
	isSpeaking = false;
	
	function dialogBox() constructor
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

	function dialogLine() constructor
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
	
	function dialogWave(_isHorizontalOrVertical, _speed, _chanel, _sync) constructor
	{
		isHorizontalOrVertical = _isHorizontalOrVertical;
		waveSpeed = _speed;
		chanel = _chanel;
		sync = _sync;
		
		wavePos = 0;
	}

	function dialogAccent(_name, _color, _textSpeed, _markup, _hideMarkup = true, _sdfEffects = undefined, _waveH=noone, _waveV=noone) constructor
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
		
		waveH = _waveH;
		waveV = _waveV;
		
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
	
	//To jest miejsce na fale do twoich akcentów
	whisperWave = new dialogWave(false, 1, 0, false);
	melodicWave = new dialogWave(true, 1, 0, false);
	
	sadWave = new dialogWave(false, 0.5, 1, false);
	
	demonicWaveH = new dialogWave(false, 1, 1, false);
	demonicWaveV = new dialogWave(true, 1, 2, false);
	
	accentImportant = new dialogAccent("Important", c_red, 1, "*", true);
	accentWhisper = new dialogAccent("Whisper", c_blue, 0.1, "~", true,,, whisperWave);
	accentMelodic = new dialogAccent("Melodic", make_color_rgb(72, 212, 86), 1, "@", true,, melodicWave);
	accentSad = new dialogAccent("Sad", c_navy, 0.5, "$", true,,, sadWave);
	accentDemonic = new dialogAccent("Demonic", c_red, 1, "^", true,, demonicWaveH, demonicWaveV);
	
	//Dodaj wszystkie akcenty do listy
	ds_list_add(accentList, accentImportant);
	ds_list_add(accentList, accentWhisper);
	ds_list_add(accentList, accentMelodic);	
	ds_list_add(accentList, accentSad);	
	ds_list_add(accentList, accentDemonic);	
	
	static prepere = function()
	{	
		if (dialogText == "")
		{
		//	instance_destroy(instance_nearest(0, 0, o_dialog));//Jak będziesz z tego korzystał w innych projektach zmień kurwa
		//	//Serio zmień zasadę działania dialogu z 
		//	//Stwórz -> Przygotuj -> Wygeneruj -> Usuń -> Powtórz
		//	//Na
		//	//Stwórz -> Przygotuj -> Wygeneruj -\
		//	//              \___________________/
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
					prepareForTalkerChange = true;
				}
				
				if (string_width(string_copy(dialogText, 1, j)) > width)
				{
					isEnter = true;
					if (string_char_at(dialogText, j + 1) == "¶")
					{
						dialogText = string_replace(dialogText, "¶", "");
						isBoxEnd = true;
						prepareForTalkerChange = true;
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
	
	static init = function(_firstPerson, _secondPerson, _dialog)
	{
		isSpeaking = true;
		
		firstPerson = _firstPerson;
		secondPerson = _secondPerson;
		
		//<-Zablokowanie gracza
	
		talker = firstPerson;
		prepareForTalkerChange = false;
		talkerChange = false;
		talkerChangeX = 0;
		
		box.clear();
	
		for(var i = 0; i < lines; i++)
		{
			box.addLine(new dialogLine());
		}

		drawSpeed = baseSpeed;
		
		//Zmiana wszystkich liter na małe ze względu na czcionkę. Nieprzydatne w innych projektach
		//Miejsce na przeprzygotowanie stringa do printu np. Zamiana końcówek ze względu na płeć
		//dialogText = string_lower(_dialog)
		dialogText = _dialog;

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
				if (prepareForTalkerChange)
				{
					prepareForTalkerChange = false;
					talkerChange = true;
				}
				prepere();
			}
			else
			{
				drawSpeed = fastSpeed;
			}
		}
	}
	
	static draw = function(_x, _y, width, height, cursorX, cursorY, portraitX, portraitY, size = 1)
	{
		///@func draw(_x, _y, width, height, cursorX, cursorY, portraitX, portraitY, size = 1)
		
		
		//ac_talkerChange - zmiana rozmówcy
		//ac_dialogWaveX - fale poziome
		//ac_dialogWaveY - fale pionowe
		//Wymagane krzywe animacji
		
		cursorX = _x + cursorX;
		cursorY = _y + cursorY;
		
		var cw = camera_get_view_width(view_camera[0]);
		var ch = camera_get_view_height(view_camera[0]);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(font);
		draw_set_color(baseColor);
		
		if (talkerChange)
		{
			if (talkerChangeX < 1)
			{
				talkerChangeX += 0.07;
			}
			else
			{
				talkerChangeX = 0;
				talkerChange = false;
				if (talker != firstPerson)
				{
					talker = firstPerson;
				}
				else
				{
					talker = secondPerson;
				}
			}
		}
		
		if talker==firstPerson
		{
			//talkerShift=(animcurve_get_point(ac_talkerChange,0,talkerChangeX)*-92);
		}
		else
		{
			//talkerShift=(animcurve_get_point(ac_talkerChange,0,talkerChangeX)*92)-91;
		}
		
		talkerShift = 0;
		
		draw_sprite_stretched(textboxSprite, 0, _x, _y, width, height)
		
		draw_sprite_ext(
		firstPerson,
		0,
		portraitX + talkerShift,
		portraitY + sin(current_time / 800) * 2,
		3.5 + abs(sin(current_time / 700)) * 0.25,
		3.5 + abs(sin(current_time / 700)) * 0.25,
		sin(current_time / 500) * 15,
		c_white,
		1);
		
		draw_sprite_ext(
		secondPerson,
		0,
		cw + portraitX - (2 * portraitX) + (92 + talkerShift),
		portraitY + sin(current_time / 800) * 2,
		-1 * (3.5 + abs(sin(current_time / 700)) * 0.25),
		3.5 + abs(sin(current_time / 700)) * 0.25,
		sin(current_time / 500) * 15,
		c_white,
		1);
		
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
						
						if (ac.waveH != noone)
						{
							var waveXFinalPos = ac.waveH.wavePos + (j * 0.1 * !ac.waveH.sync);
							while(waveXFinalPos > 1)
							{
								waveXFinalPos--;
							}
							//shiftX=animcurve_get_point(ac_dialogWaveX,ac.waveH.chanel,waveXFinalPos)
						}
						
						if (ac.waveV != noone)
						{
							var waveYFinalPos = ac.waveV.wavePos + ( j * 0.1 * !ac.waveV.sync);
							while(waveYFinalPos > 1)
							{
								waveYFinalPos--;
							}
							//shiftY=animcurve_get_point(ac_dialogWaveY,ac.waveV.chanel,waveYFinalPos)
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
				cursorX + spacingX + talkerShift + shiftX,
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