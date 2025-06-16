ui.step();

tileY++;

if (tileY > room_height)
{
    tileY = 0;
}

var isChangeLeft = 0;
var isChangeRight = 0;

if (!p1Accepted)
{
    if (input_check_pressed("upKey", 0)) 
    { 
        selectedLeft--; 
        isChangeLeft = 1;
    }
    
    if (input_check_pressed("downKey", 0)) 
    { 
        selectedLeft++;
        isChangeLeft = -1;
    }
}

if (!p2Accepted)
{
    if (input_check_pressed("upKey", 1)) 
    { 
        selectedRight--; 
        isChangeRight = 1;
    }
    
    if (input_check_pressed("downKey", 1)) 
    { 
        selectedRight++;
        isChangeRight = -1;
    }
}

if (isChangeLeft != 0)
{
    if (selectedLeft < 0)
    {
        selectedLeft = array_length(global.levels) - 1;
    }
    
    if (selectedLeft >= array_length(global.levels))
    {
        selectedLeft = 0;
    }
    
    ui.levelNameLeft.setContent(global.levels[selectedLeft].name); 
    
    if (isChangeLeft == 1)
    {
        ui.arrowUpLeft.setScale(1.5, -1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarouselLeft); i++)
            {
                var j = i;
                
                if (i >= 1)
                {
                    j++;
                }
                
                if (i == 3)
                {
                	j = 1;
                }
                
                j--;
                
                with(levelsCarouselLeft[i])
                {
                    setPositionInGrid(1.6, 2 + j * 2);
                    if (j == 1)
                    {
                        setScale(1, 1);
                    }
                    else 
                    {
                    	setScale(0.6, 0.6);
                    }
                }
            }
        }
    }
    
    if (isChangeLeft == -1)
    {
        ui.arrowDownLeft.setScale(1.5, 1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarouselLeft); i++)
            {
                var j = i;
                
                if (i >= 1)
                {
                    j++;
                }
                
                if (i == 3)
                {
                	j = 1;
                }
                
                j++;
                
                with(levelsCarouselLeft[i])
                {
                    setPositionInGrid(1.6, 2 + j * 2);
                    if (j == 1)
                    {
                        setScale(1, 1);
                    }
                    else 
                    {
                    	setScale(0.6, 0.6);
                    }
                }
            }
        }
    }
    
    ui.mainLevelViewLeft.value = selectedLeft;
    
    audio_play_sound(sn_uiHover, 0, false,,, 1 + isChangeLeft * 0.01);
}

if (isChangeRight != 0)
{
    if (selectedRight < 0)
    {
        selectedRight = array_length(global.levels) - 1;
    }
    
    if (selectedRight >= array_length(global.levels))
    {
        selectedRight = 0;
    }
    
    ui.levelNameRight.setContent(global.levels[selectedRight].name); 
    
    if (isChangeRight == 1)
    {
        ui.arrowUpRight.setScale(1.5, -1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarouselRight); i++)
            {
                var j = i;
                
                if (i >= 2)
                {
                    j++;
                }
                
                if (i == 3)
                {
                	j = 2;
                }
                
                j--;
                
                with(levelsCarouselRight[i])
                {
                    setPositionInGrid(8.4, 2 + j * 2);
                    if (j == 2)
                    {
                        setScale(1, 1);
                    }
                    else 
                    {
                    	setScale(0.6, 0.6);
                    }
                }
            }
        }
    }
    
    if (isChangeRight == -1)
    {
        ui.arrowDownRight.setScale(1.5, 1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarouselRight); i++)
            {
                var j = i;
                
                if (i >= 2)
                {
                    j++;
                }
                
                if (i == 3)
                {
                	j = 2;
                }
                
                j++;
                
                with(levelsCarouselRight[i])
                {
                    setPositionInGrid(8.4, 2 + j * 2);
                    if (j == 2)
                    {
                        setScale(1, 1);
                    }
                    else 
                    {
                    	setScale(0.6, 0.6);
                    }
                }
            }
        }
    }
    
    ui.mainLevelViewRight.value = selectedRight;
    
    audio_play_sound(sn_uiHover, 0, false,,, 1 + isChangeRight * 0.01);
}

with(ui.arrowDownLeft)
{
    setPositionInGrid(lerp(posInGridX, 1.6, 0.2), lerp(posInGridY, 9.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, 1, 0.2));
}

with(ui.arrowUpLeft)
{
    setPositionInGrid(lerp(posInGridX, 1.6, 0.2), lerp(posInGridY, 0.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, -1, 0.2));
}

with(ui.arrowDownRight)
{
    setPositionInGrid(lerp(posInGridX, 8.4, 0.2), lerp(posInGridY, 9.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, 1, 0.2));
}

with(ui.arrowUpRight)
{
    setPositionInGrid(lerp(posInGridX, 8.4, 0.2), lerp(posInGridY, 0.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, -1, 0.2));
}

with(ui.mainLevelViewLeft)
{
    if (other.roulette <= other.rouletteWinner)
    {
        if (other.rouletteWinner == 1)
        {
            setPositionInGrid(lerp(posInGridX, 5, 0.2), lerp(posInGridY, 5, 0.2));
            setScale(lerp(scaleX, 3, 0.1), lerp(scaleY, 3, 0.1));
            
            if (scaleX >= 2.9)
            {
                room_goto(r_levelEditor);
            }
        }
        else 
        {
        	setScale(lerp(scaleX, 0, 0.5), lerp(scaleY, 0, 0.5));
        }
    }
    else 
    {
    	setPositionInGrid(lerp(posInGridX, 5.1, 0.2), lerp(posInGridY, 3, 0.2));
    }
    
    blink = lerp(blink, 0, lerp(0.1, 0.01, 1 - (other.roulette / (7 - other.rouletteWinner))));
}

with(ui.mainLevelViewRight)
{
    if (other.roulette <= other.rouletteWinner)
    {
        if (other.rouletteWinner == 0)
        {
            setPositionInGrid(lerp(posInGridX, 5, 0.2), lerp(posInGridY, 5, 0.2));
            setScale(lerp(scaleX, 3, 0.1), lerp(scaleY, 3, 0.1));
            
            if (scaleX >= 2.9)
            {
                room_goto(r_levelEditor);
            }
        }
        else 
        {
        	setScale(lerp(scaleX, 0, 0.5), lerp(scaleY, 0, 0.5));
        }
    }
    else 
    {
    	setPositionInGrid(lerp(posInGridX, 4.9, 0.2), lerp(posInGridY, 7, 0.2));
    }
    blink = lerp(blink, 0, lerp(0.1, 0.01, 1 - (other.roulette / (7 - other.rouletteWinner))));
}

with(ui.levelNameLeft)
{
    setPositionInGrid(lerp(posInGridX, 5.1, 0.2), lerp(posInGridY, 1, 0.2));
}

with(ui.levelNameRight)
{
    setPositionInGrid(lerp(posInGridX, 4.9, 0.2), lerp(posInGridY, 9, 0.2));
}

with(ui)
{
    for (var i = 0; i < array_length(levelsCarouselLeft); i++)
    {
        var j = i;
        
        if (i >= 1)
        {
            j++;
        }
        
        if (i == 3)
        {
        	j = 1;
        }
        
        with(levelsCarouselLeft[i])
        {
            setPositionInGrid(lerp(posInGridX, 1.6, 0.2), lerp(posInGridY, 2 + j * 2, 0.2));
            if (j == 1)
            {
                setScale(lerp(scaleX, 0.9, 0.2), lerp(scaleY, 0.9, 0.2));
            }
            else 
            {
                if (o_levelSelection.p1Accepted)
                {
                    setScale(lerp(scaleX, 0.4, 0.2), lerp(scaleY, 0.4, 0.2));
                    setColor(global.c_discordBlack);
                }
                else 
                {
                	setScale(lerp(scaleX, 0.6, 0.2), lerp(scaleY, 0.6, 0.2));
                    setColor(c_white);
                }
            }
            
            shift(-isChangeLeft);
        }
    }
    
    for (var i = 0; i < array_length(levelsCarouselRight); i++)
    {
        var j = i;
        
        if (i >= 2)
        {
            j++;
        }
        
        if (i == 3)
        {
        	j = 2;
        }
        
        with(levelsCarouselRight[i])
        {
            setPositionInGrid(lerp(posInGridX, 8.4, 0.2), lerp(posInGridY, 2 + j * 2, 0.2));
            if (j == 2)
            {
                setScale(lerp(scaleX, 0.9, 0.2), lerp(scaleY, 0.9, 0.2));
            }
            else 
            {
            	if (o_levelSelection.p2Accepted)
                {
                    setScale(lerp(scaleX, 0.4, 0.2), lerp(scaleY, 0.4, 0.2));
                    setColor(global.c_discordBlack);
                }
                else 
                {
                	setScale(lerp(scaleX, 0.6, 0.2), lerp(scaleY, 0.6, 0.2));
                    setColor(c_white);
                }
            }
            
            shift(-isChangeRight);
        }
    }
}

if (input_check_pressed("acceptKey", 0))
{
    audio_play_sound(sn_uiAccept, 0, false);
    
    p1Accepted = true;
}

if (input_check_pressed("acceptKey", 1))
{
    audio_play_sound(sn_uiAccept, 0, false);
    
    p2Accepted = true;
}

if (input_check_pressed("leave", 0) and !p2Accepted)
{
    audio_play_sound(sn_uiCancel, 0, false);
    
    p1Accepted = false;
}

if (input_check_pressed("leave", 1) and !p1Accepted)
{
    audio_play_sound(sn_uiCancel, 0, false);
    
    p2Accepted = false;
}

if (p1Accepted and p2Accepted)
{
    if (rouletteWinner == 1)
    {
        global.gameLevelName = global.levels[selectedLeft].name;
    }
    else 
    {
    	global.gameLevelName = global.levels[selectedRight].name;
    }
    
    if (roulette > rouletteWinner)
    {
        if (ui.mainLevelViewLeft.blink < 0.1 and ui.mainLevelViewRight.blink < 0.1)
        {
            if (roulette mod 2 == 0)
            {
                with(ui.mainLevelViewLeft)
                {
                    blink = 1;
                }
            }
            else 
            {
            	with(ui.mainLevelViewRight)
                {
                    blink = 1;
                }
            }
            
            roulette--;
            audio_play_sound(sn_uiHover, 0, false);
        }
    }
}

if (keyboard_check_pressed(ord("R")))
{
    instance_create_depth(x, y, depth, o_levelSelection);
    instance_destroy();
}