event_inherited();

tileY = 0;

p1Accepted = false;
p2Accepted = false;

selectedLeft = 1;
selectedRight = 2;

roulette = 7;
rouletteWinner = choose(0, 1);

ui = new UI()

with(ui)
{
    mainLayer = new Layer(); 
    mainLayer.setGrid(10, 10);
    
    mainLevelViewLeft = new Output();
    mainLevelViewLeft.setSprite(s_levelSelectionMain);
    mainLevelViewLeft.setScale(0.7, 0.7);
    
    mainLevelViewRight = new Output();
    mainLevelViewRight.setSprite(s_levelSelectionMain);
    mainLevelViewRight.setScale(0.7, 0.7);
    
    var mainViews = [mainLevelViewLeft, mainLevelViewRight];
    
    for(var i = 0; i < array_length(mainViews); i++)
    {
        var levelSelected = 1;
        
        with(mainViews[i])
        {
            value = levelSelected + i;
            blink = 0;
            
            var drawView = function()
            { 
                draw_sprite_ext(s_levelSelectionMain, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
                draw_sprite_ext(global.levels[value].topWall, 1, posX, posY, scaleX * 0.58, scaleY * 0.53, 0, c_white, 1);
                draw_sprite_ext(s_wallTopMask_empty, 1, posX, posY, scaleX * 0.58, scaleY * 0.53, 0, c_white, blink);
            }
            setDrawFunction(drawView);
        }
    }

    levelsCarouselLeft = array_create();
    
    for (var i = 0; i <= 4; i++)
    {
        var j = i;
        
        if (i == 1)
        {
            continue;
        }
        
        if (i == 4)
        {
        	j = 1;
        }
        
        var subLevelView = new Output();
        subLevelView.setSprite(s_levelSelectionSub);
        subLevelView.setScale(0.6, 0.6);
        
        if (j == 1)
        {
            subLevelView.setScale(1, 1);
        }
        
        with(subLevelView)
        {
            value = levelSelected - 1 + j;
            
            shift = function(_value)
            {
                value += _value;
                
                if (value < 0)
                {
                    value = array_length(global.levels) - 1;
                }
                
                if (value >= array_length(global.levels))
                {
                    value = 0;
                }
            }
            
            var drawView = function()
            {
                draw_sprite_ext(s_levelSelectionSub, 0, posX, posY, scaleX, scaleY, 0, color, 1);
                draw_sprite_stretched_ext(global.levels[value].shadow, 0, posX - width * scaleX / 2 + 17 * scaleX, posY - height * scaleY / 2 + 5 * scaleY, (width - 34) * scaleX, (height - 10) * scaleY, color, 1); 
                draw_sprite_ext(s_levelSelectionSub, 1, posX, posY, scaleX, scaleY, 0, color, 1);
            }
            setDrawFunction(drawView);
        }
        
        array_push(levelsCarouselLeft, subLevelView)
        
        mainLayer.addComponent(-2, 2, subLevelView);
    }
    
    levelsCarouselRight = array_create();
    
    for (var i = 0; i <= 4; i++)
    {
        var j = i;
        
        if (i == 2)
        {
            continue;
        }
        
        if (i == 4)
        {
        	j = 2;
        }
        
        var subLevelView = new Output();
        subLevelView.setSprite(s_levelSelectionSub);
        subLevelView.setScale(0.6, 0.6);
        
        if (j == 2)
        {
            subLevelView.setScale(1, 1);
        }
        
        with(subLevelView)
        {
            value = levelSelected - 1 + j;
            
            shift = function(_value)
            {
                value += _value;
                
                if (value < 0)
                {
                    value = array_length(global.levels) - 1;
                }
                
                if (value >= array_length(global.levels))
                {
                    value = 0;
                }
            }
            
            var drawView = function()
            {
                draw_sprite_ext(s_levelSelectionSub, 0, posX, posY, scaleX, scaleY, 0, color, 1);
                draw_sprite_stretched_ext(global.levels[value].shadow, 0, posX - width * scaleX / 2 + 17 * scaleX, posY - height * scaleY / 2 + 5 * scaleY, (width - 34) * scaleX, (height - 10) * scaleY, color, 1); 
                draw_sprite_ext(s_levelSelectionSub, 1, posX, posY, scaleX, scaleY, 0, color, 1);
            }
            setDrawFunction(drawView);
        }
        
        array_push(levelsCarouselRight, subLevelView)
        
        mainLayer.addComponent(12, 2, subLevelView);
    }
    
    arrowUpLeft = new Output();
    arrowUpLeft.setSprite(s_levelSelectionArrow);
    arrowUpLeft.setScale(1, -1);
    
    arrowDownLeft = new Output();
    arrowDownLeft.setSprite(s_levelSelectionArrow);
    
    arrowUpRight = new Output();
    arrowUpRight.setSprite(s_levelSelectionArrow);
    arrowUpRight.setScale(1, -1);
    
    arrowDownRight = new Output();
    arrowDownRight.setSprite(s_levelSelectionArrow);
    
    levelNameLeft = new Text(global.levels[other.selectedLeft].name, f_characterName);
    levelNameLeft.setColor(global.c_discordBlack);
    
    levelNameRight = new Text(global.levels[other.selectedRight].name, f_characterName);
    levelNameRight.setColor(global.c_discordBlack);
    
    mainLayer.addComponent(5, -4, levelNameLeft);
    mainLayer.addComponent(5, 14, levelNameRight);
    
    mainLayer.addComponent(-2, 0.5, arrowUpLeft);
    mainLayer.addComponent(-2, 9.5, arrowDownLeft);
    
    mainLayer.addComponent(12, 0.5, arrowUpRight);
    mainLayer.addComponent(12, 9.5, arrowDownRight);
    
    mainLayer.addComponent(5, -4, mainLevelViewLeft);
    mainLayer.addComponent(5, 14, mainLevelViewRight);
    
    pushLayer(mainLayer);
}
