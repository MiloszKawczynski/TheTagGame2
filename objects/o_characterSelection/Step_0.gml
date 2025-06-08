ui.step();

var isChange = 0;

var p1Before = false;
var p2Before = false;

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
    
if (isChange != 0)
{
    audio_play_sound(sn_uiHover, 0, false,,, 1 + isChange * 0.01);
}

if (p1Before)
{
    with(ui)
    {
        characterLeft.setPositionInGrid(3, 5.5);
        characterLeftBck.setPositionInGrid(-2, 5.5);
        characterLeftBck.setSprite(global.characters[max(other.p1Selected - 1, 0)].art);
    }
}

if (p2Before)
{
    with(ui)
    {
        characterRight.setPositionInGrid(7, 5.5);
        characterRightBck.setPositionInGrid(11, 5.5);
        characterRightBck.setSprite(global.characters[max(other.p2Selected - 1, 0)].art);
    }
}

if (input_check_pressed("interactionKey", 0) or input_check_pressed("interactionKey", 1))
{
    audio_play_sound(sn_uiAccept, 0, false);
}

if (input_check_pressed("leave", 0) or input_check_pressed("leave", 1))
{
    audio_play_sound(sn_uiCancel, 0, false);
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
            setPositionInGrid(lerp(posInGridX, -2, 0.2), 5.5);
            if (posInGridX <= -1.9)
            {
                o_characterSelection.charChangeP1 = false;
            }
        }
        
        with(characterLeftBck)
        {
            setPositionInGrid(lerp(posInGridX, 3, 0.2), 5.5);
        }
    }
    
    if (other.charChangeP2)
    {
        with(characterRight)
        {
            setPositionInGrid(lerp(posInGridX, 11, 0.2), 5.5);
            if (posInGridX >= 10.9)
            {
                o_characterSelection.charChangeP2 = false;
            }
        }
        
        with(characterRightBck)
        {
            setPositionInGrid(lerp(posInGridX, 7, 0.2), 5.5);
        }
    }
}

tileY++;

if (tileY > room_height)
{
    tileY = 0;
}