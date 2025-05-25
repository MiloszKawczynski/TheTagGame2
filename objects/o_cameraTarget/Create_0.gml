cameraMarginFactor = 2;

function reset()
{
    var _x = 0;
    var _y = 0;
    
    with(o_char)
    {
        _x += x;
        _y += y;
    }
    
    x = _x / instance_number(o_char);
    y = _y / instance_number(o_char);
    
    Camera.x = x;
    Camera.y = y;
}