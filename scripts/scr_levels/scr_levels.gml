function level(_name) constructor 
{
    name = _name;
    topWall = asset_get_index(string("s_wallTopMask_{0}", name));
	shadow = sprite_add(get_project_path() + string("shadowMask_{0}.png", name), 0, false, false, 1600 / 2, 896 / 2);
}

function scr_createLevels()
{
    basic = new level("basic");
    santa = new level("santa");
    fire = new level("fire");
    shaft = new level("shaft");
    side = new level("side");
    serpent = new level("serpent");
    dot = new level("dot");
    empty = new level("empty");
    
    
    global.levels = array_create();
    array_push(global.levels, basic, santa, fire, shaft, side, serpent, dot);
    
    if (DEBUG)
    {
        array_push(global.levels, empty);
    }
}