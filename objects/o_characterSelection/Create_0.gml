event_inherited();

tileY = 0;

p1Selected = 0;
p2Selected = 4;

charChangeP1 = false;
charChangeP2 = false;

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
        
        char++;
        
        characterSelectionGroup.addComponent(i, -1, characterSelectionSlot);
        
        characterSelectionSlot = new Output();
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
        
        characterSelectionGroup.addComponent(i, 1, characterSelectionSlot);
        characterSelectionSlot.setShift(-14, 0);
        
        char++;
    }
    
    characterSelectionSlotBorderP1 = new Output();
    with(characterSelectionSlotBorderP1)
    {
        var drawBorder = function()
        {
            draw_sprite_ext(s_characterSelectionSlotBorder, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
        }
        setDrawFunction(drawBorder);
    }
    
    characterSelectionSlotBorderP2 = new Output();
    with(characterSelectionSlotBorderP2)
    {
        var drawBorder = function()
        {
            draw_sprite_ext(s_characterSelectionSlotBorder, 1, posX, posY, scaleX, scaleY, 0, c_white, 1);
        }
        setDrawFunction(drawBorder);
    }
    
    
    characterSelectionGroup.addComponent(-2, -1, characterSelectionSlotBorderP1);
    characterSelectionGroup.addComponent(2, -1, characterSelectionSlotBorderP2);
    
    mainLayer.addComponent(3, 5.5, characterLeft);
    mainLayer.addComponent(7, 5.5, characterRight);
    
    mainLayer.addComponent(-2, 5.5, characterLeftBck);
    mainLayer.addComponent(11, 5.5, characterRightBck);
    
    mainLayer.addComponent(5, 8, characterSelectionGroup);
    
    pushLayer(mainLayer);
}
