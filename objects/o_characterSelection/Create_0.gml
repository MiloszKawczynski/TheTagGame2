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
