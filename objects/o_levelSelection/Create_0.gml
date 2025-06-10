event_inherited();

tileY = 0;

selected = 1;

ui = new UI()

with(ui)
{
    mainLayer = new Layer(); 
    mainLayer.setGrid(10, 10);
    
    mainLevelView = new Output();
    mainLevelView.setSprite(s_levelSelectionMain);
    
    var levelSelected = other.selected;
    
    with(mainLevelView)
    {
        value = levelSelected;
        
        var drawView = function()
        { 
            draw_sprite_ext(s_levelSelectionMain, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
            draw_sprite_stretched(global.levels[value].shadow, 0, posX - width / 2 + 19.5, posY - height / 2 + 34, width - 19 - 18, height - 34 - 34); 
        }
        setDrawFunction(drawView);
    }

    levelsCarousel = array_create();
    
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
                draw_sprite_ext(s_levelSelectionSub, 0, posX, posY, scaleX, scaleY, 0, c_white, 1);
                draw_sprite_stretched(global.levels[value].shadow, 0, posX - width * scaleX / 2 + 17 * scaleX, posY - height * scaleY / 2 + 5 * scaleY, (width - 34) * scaleX, (height - 10) * scaleY); 
                draw_sprite_ext(s_levelSelectionSub, 1, posX, posY, scaleX, scaleY, 0, c_white, 1);
            }
            setDrawFunction(drawView);
        }
        
        array_push(levelsCarousel, subLevelView)
        
        mainLayer.addComponent(-2, 2 + j * 2, subLevelView);
    }
    
    arrowUp = new Output();
    arrowUp.setSprite(s_levelSelectionArrow);
    arrowUp.setScale(1, -1);
    
    arrowDown = new Output();
    arrowDown.setSprite(s_levelSelectionArrow);
    
    levelName = new Text(global.levels[other.selected].name, f_characterName);
    levelName.setColor(global.c_discordBlack);
    
    mainLayer.addComponent(12, 5, mainLevelView);
    mainLayer.addComponent(12, 2.5, levelName);
    
    mainLayer.addComponent(2.1, 0.5, arrowUp);
    mainLayer.addComponent(1.4, 9.5, arrowDown);
    
    pushLayer(mainLayer);
}
