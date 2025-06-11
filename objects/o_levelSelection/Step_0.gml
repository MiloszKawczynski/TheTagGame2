ui.step();

tileY++;

if (tileY > room_height)
{
    tileY = 0;
}

var isChange = 0;

if (input_check_pressed("upKey", 0)) 
{ 
    selected++; 
    isChange = -1;
}

if (input_check_pressed("downKey", 0)) 
{ 
    selected--;
    isChange = 1;
}

if (isChange != 0)
{
    if (selected < 0)
    {
        selected = array_length(global.levels) - 1;
    }
    
    if (selected >= array_length(global.levels))
    {
        selected = 0;
    }
    
    ui.levelName.setContent(global.levels[selected].name); 
    
    if (isChange == 1)
    {
        ui.arrowDown.setScale(1.5, 1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarousel); i++)
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
                
                with(levelsCarousel[i])
                {
                    setPositionInGrid(lerp(2.1, 1.4, j / 3), 2 + j * 2);
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
    
    if (isChange == -1)
    {
        ui.arrowUp.setScale(1.5, -1.5);
        
        with(ui)
        {
            for (var i = 0; i < array_length(levelsCarousel); i++)
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
                
                with(levelsCarousel[i])
                {
                    setPositionInGrid(lerp(2.1, 1.4, j / 3), 2 + j * 2);
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
    
    ui.mainLevelView.value = selected;
    
    audio_play_sound(sn_uiHover, 0, false,,, 1 + isChange * 0.01);
}

with(ui.arrowDown)
{
    setPositionInGrid(lerp(posInGridX, 1.4, 0.2), lerp(posInGridY, 9.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, 1, 0.2));
}

with(ui.arrowUp)
{
    setPositionInGrid(lerp(posInGridX, 2.1, 0.2), lerp(posInGridY, 0.5, 0.2));
    setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, -1, 0.2));
}


with(ui.mainLevelView)
{
    setPositionInGrid(lerp(posInGridX, 6.8, 0.2), lerp(posInGridY, 5, 0.2));
}

with(ui.levelName)
{
    setPositionInGrid(lerp(posInGridX, 6.8, 0.2), lerp(posInGridY, 2.5, 0.2));
}

with(ui)
{
    for (var i = 0; i < array_length(levelsCarousel); i++)
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
        
        with(levelsCarousel[i])
        {
            setPositionInGrid(lerp(posInGridX, lerp(2.1, 1.4, j / 3) , 0.2), lerp(posInGridY, 2 + j * 2, 0.2));
            if (j == 1)
            {
                setScale(lerp(scaleX, 1, 0.2), lerp(scaleY, 1, 0.2));
            }
            else 
            {
            	setScale(lerp(scaleX, 0.6, 0.2), lerp(scaleY, 0.6, 0.2));
            }
            
            shift(-isChange);
        }
    }
}

if (input_check_pressed("interactionKey", 0))
{
    audio_play_sound(sn_uiAccept, 0, false);
    
    global.gameLevelName = global.levels[selected].name;
    
    room_goto(r_levelEditor);
}