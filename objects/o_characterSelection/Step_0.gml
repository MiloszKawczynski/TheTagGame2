ui.step();

introAlpha = armez_timer(introAlpha);

var isChange = 0;

var p1Before = false;
var p2Before = false;

if (init)
{
    init = false;
    charChangeP1 = true;
    charChangeP2 = true;
    
    ui.characterLeftBck.setPositionInGrid(other.leftHide, 5.5);
    ui.characterRightBck.setPositionInGrid(other.rightHide, 5.5);
    ui.characterLeft.setPositionInGrid(other.leftHide, 5.5);
    ui.characterRight.setPositionInGrid(other.rightHide, 5.5);
}

if (!isP1Selected)
{
    if (input_check_pressed("rightKey", 0)) 
    { 
        p1Selected++; 
        isChange = 1; 
        charChangeP1 = true;
        p1Before = true;
        
        if (p1Selected >= 10)
        {
            p1Selected = 0;
        } 
    }
    
    if (input_check_pressed("leftKey", 0)) 
    { 
        p1Selected--; 
        isChange = -1;
        charChangeP1 = true; 
        p1Before = true;
        
        if (p1Selected < 0)
        {
            p1Selected = 9;
        } 
    }
    
    if (input_check_pressed("downKey", 0)) 
    { 
        p1Selected += 5; 
        isChange = 1; 
        charChangeP1 = true;
        p1Before = true;
        
        if (p1Selected >= 10)
        {
            p1Selected -= 10;
        } 
        
        while (p1Selected < 0)
        {
            p1Selected -= 5;
        }  
    }
    
    if (input_check_pressed("upKey", 0)) 
    { 
        p1Selected -= 5; 
        isChange = -1; 
        charChangeP1 = true;
        p1Before = true;
        
        if (p1Selected < 0)
        {
            p1Selected += 10;
        } 
        
        while (p1Selected > 10)
        {
            p1Selected -= 5;
        }  
    }
}

if (!isP2Selected)
{
    if (input_check_pressed("rightKey", 1))
    { 
        p2Selected++; 
        isChange = 1; 
        charChangeP2 = true; 
        p2Before = true;
        
        if (p2Selected >= 10)
        {
            p2Selected = 0;
        } 
    }
    
    if (input_check_pressed("leftKey", 1)) 
    { 
        p2Selected--; 
        isChange = -1;
        charChangeP2 = true;
        p2Before = true;
        
        if (p2Selected < 0)
        {
            p2Selected = 9;
        }  
    }
    
    if (input_check_pressed("downKey", 1)) 
    { 
        p2Selected += 5; 
        isChange = 1; 
        charChangeP2 = true;
        p2Before = true;
        
        if (p2Selected >= 10)
        {
            p2Selected -= 10;
        } 
        
        while (p2Selected < 0)
        {
            p2Selected -= 5;
        }  
    }
    
    if (input_check_pressed("upKey", 1)) 
    { 
        p2Selected -= 5; 
        isChange = -1; 
        charChangeP2 = true;
        p2Before = true;
        
        if (p2Selected < 0)
        {
            p2Selected += 10;
        } 
        
        while (p2Selected > 10)
        {
            p2Selected -= 5;
        }  
    }
}

if (input_check_pressed("acceptKey", 0) and !isP1Selected)
{
    audio_play_sound(sn_uiAccept, 0, false);
    
    isP1Selected = true;
    ui.characterSelectionSlotBorderP1.setColor(global.c_darkBlue);
    if (p1Selected == randomCharacter)
    {
        global.leftCharacter = irandom(array_length(global.characters) - 1);
        p1Selected = global.leftCharacter;
        charChangeP1 = true;
        p1Before = true;
        isChange = 1;
    }
    else 
    {
    	global.leftCharacter = p1Selected;
    }
    
    audio_play_sound(global.characters[global.leftCharacter].selectAudio, 0, false);
}

if (input_check_pressed("acceptKey", 1) and !isP2Selected)
{
    audio_play_sound(sn_uiAccept, 0, false);
    
    isP2Selected = true;
    ui.characterSelectionSlotBorderP2.setColor(global.c_darkBlue);
    if (p2Selected == randomCharacter)
    {
        global.rightCharacter = irandom(array_length(global.characters) - 1);
        p2Selected = global.rightCharacter;
        charChangeP2 = true;
        p2Before = true;
        isChange = 1;
    }
    else 
    {
    	global.rightCharacter = p2Selected;
    }
    
    audio_play_sound(global.characters[global.rightCharacter].selectAudio, 0, false);
}
    
if (isChange != 0)
{
    audio_play_sound(sn_uiHover, 0, false,,, 1 + isChange * 0.01);
}

if (p1Before)
{
    with(ui)
    {
        characterLeft.setPositionInGrid(other.leftShow, 5.5);
        characterLeftBck.setPositionInGrid(other.leftHide, 5.5);
        
        if (other.p1Selected == other.randomCharacter)
        {
            characterLeft.setSprite(characterLeftBck.state.sprite);
            characterLeftBck.setSprite(sVN_random); 
            characterNameTextLeft.setContent("Losowy biegacz"); 
            characterDescriptionTextLeft.setContent("???\n\n???"); 
            characterDificultyLeft.setValue([1, 1, 1]);
        }
        else 
        {
        	characterLeft.setSprite(characterLeftBck.state.sprite);
            characterLeftBck.setSprite(global.characters[other.p1Selected].art); 
            characterNameTextLeft.setContent(global.characters[other.p1Selected].name); 
            characterDescriptionTextLeft.setContent(global.characters[other.p1Selected].desc); 
            characterDescriptionTextLeft.checkForTags();
            characterDificultyLeft.setValue(global.characters[other.p1Selected].dificulty);
        }
    }
}

if (p2Before)
{
    with(ui)
    {
        characterRight.setPositionInGrid(other.rightShow, 5.5);
        characterRightBck.setPositionInGrid(other.rightHide, 5.5);
        
        if (other.p2Selected == other.randomCharacter)
        {
            characterRight.setSprite(characterRightBck.state.sprite);
            characterRightBck.setSprite(sVN_random); 
            characterNameTextRight.setContent("Losowy biegacz"); 
            characterDescriptionTextRight.setContent("???\n\n???"); 
            characterDificultyRight.setValue([1, 1, 1]);
        }
        else 
        {
        	characterRight.setSprite(characterRightBck.state.sprite);
            characterRightBck.setSprite(global.characters[other.p2Selected].art); 
            characterNameTextRight.setContent(global.characters[other.p2Selected].name); 
            characterDescriptionTextRight.setContent(global.characters[other.p2Selected].desc); 
            characterDescriptionTextRight.checkForTags();
            characterDificultyRight.setValue(global.characters[other.p2Selected].dificulty);
        }
    }
}

if (input_check_pressed("leave", 0) and !isP2Selected)
{
    audio_play_sound(sn_uiCancel, 0, false);
    ui.characterSelectionSlotBorderP1.setColor(c_white);
    
    isP1Selected = false;
}

if (input_check_pressed("leave", 1) and !isP1Selected)
{
    audio_play_sound(sn_uiCancel, 0, false);
    ui.characterSelectionSlotBorderP2.setColor(c_white);
    
    isP2Selected = false;
}
    
with(ui)
{
    var p1x = (other.p1Selected mod 5) - 2;
    var p2x = (other.p2Selected mod 5) - 2;
    var p1y = (other.p1Selected div 5) * 2 - 1;
    var p2y = (other.p2Selected div 5) * 2 - 1;
    
    with(characterSelectionSlotBorderP1)
    {
        setPositionInGrid(lerp(posInGridX, p1x, 0.2), lerp(posInGridY, p1y, 0.2));
        setShift(lerp(shiftX, (p1y + 1 / 2) * -8, 0.2), 0);
    }
    
    with(characterSelectionSlotBorderP2)
    {
        setPositionInGrid(lerp(posInGridX, p2x, 0.2), lerp(posInGridY, p2y, 0.2));
        setShift(lerp(shiftX, (p2y + 1 / 2) * -8, 0.2), 0);
    }
    
    if (other.charChangeP1)
    {
        with(characterLeft)
        {
            setPositionInGrid(lerp(posInGridX, o_characterSelection.leftHide, 0.2), posInGridY);
        }
        
        with(characterLeftBck)
        {
            setPositionInGrid(lerp(posInGridX, o_characterSelection.leftShow, 0.2), posInGridY);
        }
        
        if (characterLeft.posInGridX <= o_characterSelection.leftHide + 0.01 and characterLeftBck.posInGridX >= o_characterSelection.leftShow - 0.01)
        {
            o_characterSelection.charChangeP1 = false;
        }
    }
    
    if (other.charChangeP2)
    {
        with(characterRight)
        {
            setPositionInGrid(lerp(posInGridX, o_characterSelection.rightHide, 0.2), posInGridY);
        }
        
        with(characterRightBck)
        {
            setPositionInGrid(lerp(posInGridX, o_characterSelection.rightShow, 0.2), posInGridY);
        }
        
        if (characterRight.posInGridX >= o_characterSelection.rightHide - 0.01 and characterRightBck.posInGridX <= o_characterSelection.rightShow + 0.01)
        {
            o_characterSelection.charChangeP2 = false;
        }
    }
}

tileY++;

if (tileY > room_height)
{
    tileY = 0;
}

if (isP1Selected and isP2Selected)
{
    var isAnySelectionAudioIsPlaying = false;
    for (var i = 0; i < array_length(global.characters); i++)
    {
        if (audio_is_playing(global.characters[i].selectAudio))
        {
            isAnySelectionAudioIsPlaying = true;
            break;
        }
    }
    
    if (!isAnySelectionAudioIsPlaying)
    {
        with(ui.characterSelectionGroup)
        {
            setPositionInGrid(posInGridX, lerp(posInGridY, 12, 0.2));
        }
        
        with(ui.characterLeft)
        {
            setPositionInGrid(lerp(posInGridX, other.leftHide, 0.2), posInGridY);
        }
        
        with(ui.characterLeftBck)
        {
            setPositionInGrid(lerp(posInGridX, other.leftHide, 0.2), posInGridY);
        }
        
        with(ui.characterInfoGroupLeft)
        {
            setPositionInGrid(lerp(posInGridX, other.leftHide - 3, 0.2), posInGridY);
        }
        
        with(ui.characterRight)
        {
            setPositionInGrid(lerp(posInGridX, other.rightHide, 0.2), posInGridY);
        }
        
        with(ui.characterRightBck)
        {
            setPositionInGrid(lerp(posInGridX, other.rightHide, 0.2), posInGridY);
        }
        
        with(ui.characterInfoGroupRight)
        {
            setPositionInGrid(lerp(posInGridX, other.rightHide + 3, 0.2), posInGridY);
        }
        
        dividerX = lerp(dividerX, -room_width * 0.2, 0.2);
        dividerColor = merge_color(dividerColor, global.c_discordBlack, 0.2);
        
        if (!instance_exists(o_levelSelection))
        {
            var inst = instance_create_depth(x, y, depth - 1, o_levelSelection);
            inst.tileY = tileY;
        }
        
        if (abs(dividerX - (-room_width * 0.2) < 0.01))
        {
            instance_destroy();
        }
    }
}
else 
{
	with(ui.characterSelectionGroup)
    {
        setPositionInGrid(posInGridX, lerp(posInGridY, 8, 0.2));
    }
    
    with(ui.characterInfoGroupLeft)
    {
        setPositionInGrid(lerp(posInGridX, 0.4, 0.2), posInGridY);
    }
    
    with(ui.characterInfoGroupRight)
    {
        setPositionInGrid(lerp(posInGridX, 9.6, 0.2), posInGridY);
    }
}