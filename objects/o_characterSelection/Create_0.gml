event_inherited();

leftHide = -2;
rightHide = 12;
leftShow = 3.5;
rightShow = 6.5;

dividerX = 0;
dividerColor = global.c_neon;

tileY = 0;

p1Selected = 0;
p2Selected = 4;

isP1Selected = false;
isP2Selected = false;

charChangeP1 = true;
charChangeP2 = true;

init = true;
introAlpha = 0;

randomCharacter = 9;

window_set_fullscreen(true);

ui = new UI()

with(ui)
{
    mainLayer = new Layer(); 
    mainLayer.setGrid(10, 10);
		
    characterLeft = new Output()
    characterLeft.setSprite(sVN_adam);
    characterLeft.setScale(0.5, 0.5);
    
    characterRight = new Output()
    characterRight.setSprite(sVN_clea);
    characterRight.setScale(-0.5, 0.5);
    
    characterLeftBck = new Output()
    characterLeftBck.setSprite(sVN_adam);
    characterLeftBck.setScale(0.5, 0.5);
    
    characterRightBck = new Output()
    characterRightBck.setSprite(sVN_clea);
    characterRightBck.setScale(-0.5, 0.5);
    
    characterSelectionGroup = new Group();
    characterSelectionGroup.setGrid(1.2, 1.5);
    
    characterSelectionBox = new Output();
    characterSelectionBox.setSprite(s_characterSelectionBox);
    
    characterSelectionGroup.addComponent(0, 0, characterSelectionBox);
    
    var char = 0;
    for(var i = -2; i <= 2; i++)
    {
        var characterSelectionSlot = new Output();
        characterSelectionSlot.setSprite(s_characterSelectionSlot);
        
        with(characterSelectionSlot)
        {
            charID = char;
            sampler = shader_get_sampler_index(shd_characterSlot, "character")
            slotTexture = sprite_get_texture(s_characterSelectionSlot, 0);
            
            var drawSlot = function()
        	{
        		draw_sprite_ext(s_characterSelectionSlot, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
                
                shader_set(shd_characterSlot);
                texture_set_stage(sampler, slotTexture);
        		draw_sprite_ext(s_chaseBarPortraits, charID, posX, posY, scaleX, scaleY, 0, c_white, 1); 
                shader_reset();
        	}
        	setDrawFunction(drawSlot);
        }
        
        characterSelectionGroup.addComponent(i, -1, characterSelectionSlot);
        
        characterSelectionSlot = new Output();
        characterSelectionSlot.setSprite(s_characterSelectionSlot);
        
        with(characterSelectionSlot)
        {
            charID = char + 5;
            sampler = shader_get_sampler_index(shd_characterSlot, "character")
            slotTexture = sprite_get_texture(s_characterSelectionSlot, 0);
            
            var drawSlot = function()
        	{
        		draw_sprite_ext(s_characterSelectionSlot, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
                
                shader_set(shd_characterSlot);
                texture_set_stage(sampler, slotTexture);
        		draw_sprite_ext(s_chaseBarPortraits, charID, posX, posY, scaleX, scaleY, 0, c_white, 1); 
                shader_reset();
        	}
        	setDrawFunction(drawSlot);
        }
        
        characterSelectionGroup.addComponent(i, 1, characterSelectionSlot);
        characterSelectionSlot.setShift(-14, 0);
        
        char++;
    }
    
    characterSelectionSlotBorderP1 = new Output();
    with(characterSelectionSlotBorderP1)
    {
        var drawBorder = function()
        {
            draw_sprite_ext(s_characterSelectionSlotBorder, 0, posX, posY, scaleX, scaleY, 0, color, 1);
        }
        setDrawFunction(drawBorder);
    }
    
    characterSelectionSlotBorderP2 = new Output();
    with(characterSelectionSlotBorderP2)
    {
        var drawBorder = function()
        {
            draw_sprite_ext(s_characterSelectionSlotBorder, 1, posX, posY, scaleX, scaleY, 0, color, 1);
        }
        setDrawFunction(drawBorder);
    }
    
    
    characterSelectionGroup.addComponent(-1, -1, characterSelectionSlotBorderP1);
    characterSelectionGroup.addComponent(2, 1, characterSelectionSlotBorderP2);
    
    characterInfoGroupLeft = new Group();
    characterInfoGroupLeft.setGrid(1, 1);
    
    characterNameLeft = new Output();
    characterNameLeft.setSprite(s_characterSelectionName);
    
    characterNameTextLeft = new Text(global.characters[other.p1Selected].name, f_characterName, fa_left, fa_top);
    characterNameTextLeft.setColor(c_white);
    
    characterDescriptionLeft = new Output();
    characterDescriptionLeft.setSprite(s_characterSelectionDescription);
    
    characterDescriptionTextLeft = new Text(global.characters[other.p1Selected].desc, f_characterDesc, fa_left, fa_top);
    characterDescriptionTextLeft.setColor(c_white);
    
    with(characterDescriptionTextLeft)
    {
        tagPosition = -1;
        tagType = -1;
        
        skillTagPosition = -1;
        
        checkForTags = function()
        {
            tagPosition = -1;
            tagType = -1;
            
            skillTagPosition = string_pos("[rb]", content);
            
            tagPosition = string_pos("[A]", content);
            if (tagPosition!= 0)
            {
                tagType = 0;
            }
            
            breakPosition = string_last_pos("\n", (string_copy(content, 0, tagPosition)));
        }
        
        draw = function() 
		{
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_set_font(font);
			draw_set_halign(horizontalAlign);
			draw_set_valign(verticalAlign);
            
			if (!isSpacingEnable)
			{
				draw_text_transformed(posX, posY, string_replace(string_replace(content, "[A]", "  "), "[rb]", "  "), scaleX, scaleY, rotation);
                if (o_characterSelection.p1Selected != o_characterSelection.randomCharacter)
                {
                    draw_sprite_ext(s_xboxBumperButtons, 1, posX + string_width(string_copy(content, 0, skillTagPosition + 1)), posY + string_height(string_copy(content, 0, skillTagPosition)), 0.75, 0.75, 0, c_white, 1);
                }
                if (tagType != -1)
                {
                    draw_sprite_ext(s_xboxFaceButtons, tagType, posX + string_width(string_copy(content, 0, tagPosition - breakPosition)), posY + string_height(string_copy(content, 0, tagPosition)), 0.75, 0.75, 0, c_white, 1);
                }
			}
			else
			{
				for(var i = 0; i < ds_list_size(contentList); i++)
				{
					draw_text_transformed(posX + (spaceX * i), posY + (spaceY * i), ds_list_find_value(contentList, i), scaleX, scaleY, rotation);
				}
			}
			
			draw_set_alpha(1);
		};
    }
    
    characterDescriptionTextLeft.checkForTags();
    
    characterDificultyLeft = new LedBar(global.characters[other.p1Selected].dificulty, 3, 50);
    characterDificultyLeft.setSpriteSheet(s_characterSelectionDificulty);
    
    characterInfoGroupLeft.addComponent(0, 0, characterNameLeft);
    characterInfoGroupLeft.addComponent(0.25, 0.35, characterNameTextLeft);
    characterInfoGroupLeft.addComponent(1.9, 0.09, characterDificultyLeft);
    characterInfoGroupLeft.addComponent(0, 2, characterDescriptionLeft);
    characterInfoGroupLeft.addComponent(0.1, 2.2, characterDescriptionTextLeft);
    
    characterInfoGroupRight = new Group();
    characterInfoGroupRight.setGrid(1, 1);
    
    characterNameRight = new Output();
    characterNameRight.setSprite(s_characterSelectionName);
    characterNameRight.setScale(-1, 1);
    
    characterNameTextRight = new Text(global.characters[other.p2Selected].name, f_characterName, fa_right, fa_top);
    characterNameTextRight.setColor(c_white);
    
    characterDescriptionRight = new Output();
    characterDescriptionRight.setSprite(s_characterSelectionDescription);
    characterDescriptionRight.setScale(-1, 1);
    
    characterDescriptionTextRight = new Text(global.characters[other.p2Selected].desc, f_characterDesc, fa_right, fa_top);
    characterDescriptionTextRight.setColor(c_white);
    
    with(characterDescriptionTextRight)
    {
        tagType = -1;
        
        checkForTags = function()
        {
            tagPositionWidth = -1;
            skillTagPosition = -1;
            
            skillTagPositionWidth = -1;
            skillTagPositionHeight = -1;
            
            tagType = -1;
            
            split = string_split(content, "\n");
            
            for(var i = 0; i < array_length(split); i++)
            {
                skillTagPositionWidth = string_pos("[rb]", split[i]);
                if (skillTagPositionWidth != 0)
                {
                    skillTagPosition = string_pos("[rb]", content);
                    skillTagPositionWidth = string_width(string_copy(split[i], 0, skillTagPositionWidth + 1)) - string_width(split[i])
                    break;
                }
            }
            
            for(var i = 0; i < array_length(split); i++)
            {    
                tagPositionWidth = string_pos("[A]", split[i]);
                if (tagPositionWidth != 0)
                {
                    tagPositionHeight = string_height(string_copy(content, 0, string_pos("[A]", content)));
                    tagPositionWidth = string_width(string_copy(split[i], 0, tagPositionWidth + 1)) - string_width(split[i])
                    tagType = 0;
                    break;
                }
            }
        }
        
        draw = function() 
		{
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_set_font(font);
			draw_set_halign(horizontalAlign);
			draw_set_valign(verticalAlign);
            
			if (!isSpacingEnable)
			{
				var contentStripped = string_replace(string_replace(content, "[A]", "  "), "[rb]", "    ");
                var totalWidth = string_width(contentStripped);
                
                draw_text_transformed(posX, posY, contentStripped, scaleX, scaleY, rotation);
                
                if (o_characterSelection.p2Selected != o_characterSelection.randomCharacter)
                {
                    draw_sprite_ext(s_xboxBumperButtons, 1, posX + skillTagPositionWidth, posY +  + string_height(string_copy(content, 0, skillTagPosition)), 0.75, 0.75, 0, c_white, 1);
                }
                if (tagType != -1)
                {
                    draw_sprite_ext(s_xboxFaceButtons, tagType, posX + tagPositionWidth, posY + tagPositionHeight, 0.75, 0.75, 0, c_white, 1);
                }
			}
			else
			{
				for(var i = 0; i < ds_list_size(contentList); i++)
				{
					draw_text_transformed(posX + (spaceX * i), posY + (spaceY * i), ds_list_find_value(contentList, i), scaleX, scaleY, rotation);
				}
			}
			
			draw_set_alpha(1);
		};
    }
    
    characterDescriptionTextRight.checkForTags();
    
    characterDificultyRight = new LedBar(global.characters[other.p2Selected].dificulty, 3, 50);
    characterDificultyRight.setSpriteSheet(s_characterSelectionDificulty);
    
    characterInfoGroupRight.addComponent(0, 0, characterNameRight);
    characterInfoGroupRight.addComponent(-0.25, 0.35, characterNameTextRight);
    characterInfoGroupRight.addComponent(-1.9, 0.09, characterDificultyRight);
    characterInfoGroupRight.addComponent(0, 2, characterDescriptionRight);
    characterInfoGroupRight.addComponent(-0.1, 2.2, characterDescriptionTextRight);
    
    mainLayer.addComponent(other.leftHide, 5.5, characterLeft);
    mainLayer.addComponent(other.rightHide, 5.5, characterRight);
    
    mainLayer.addComponent(other.leftHide, 5.5, characterLeftBck);
    mainLayer.addComponent(other.rightHide, 5.5, characterRightBck);
    
    mainLayer.addComponent(other.leftHide - 3, 0.5, characterInfoGroupLeft);
    mainLayer.addComponent(other.rightHide + 3, 0.5, characterInfoGroupRight);
    
    mainLayer.addComponent(5, 12, characterSelectionGroup);
    
    pushLayer(mainLayer);
}
