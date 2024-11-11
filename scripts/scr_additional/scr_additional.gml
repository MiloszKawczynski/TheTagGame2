function instance_nearest_notme(_x, _y, obj) 
{
    var inst = noone;
    var distClosest = infinity;
    with (obj) 
	{
        var dist = point_distance(x, y, _x, _y);
        if (id != other.id and dist < distClosest) 
		{
            inst = id;
            distClosest = dist;
        }
    }
    return inst;
}

function wait(time)
{
	var tend = get_timer() + (time * 1000000);
	while(get_timer() < tend)
	{
		//do nothing
	}
}