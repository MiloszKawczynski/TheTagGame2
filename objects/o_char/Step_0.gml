var horizontal = keyboard_check(rightKey) - keyboard_check(leftKey);
var vertical = keyboard_check(downKey) - keyboard_check(upKey);
	
horizontalSpeed += horizontal * acceleration;
verticalSpeed += vertical * acceleration;
	
var collided = false;
	
if y < 0 and verticalSpeed < 0
{
	verticalSpeed = 0
}
	
if y > room_height and verticalSpeed > 0
{
	verticalSpeed = 0
}
	
if x < 0 and horizontalSpeed < 0
{
	horizontalSpeed = 0
}
	
if x > room_width and horizontalSpeed > 0
{
	horizontalSpeed = 0
}
	
if horizontal == 0
{
	horizontalSpeed -= sign(horizontalSpeed) * deceleration;
}
	
if vertical == 0
{
	verticalSpeed -= sign(verticalSpeed) * deceleration;
}

horizontalSpeed = clamp(horizontalSpeed, -maximumSpeed, maximumSpeed);
verticalSpeed = clamp(verticalSpeed, -maximumSpeed, maximumSpeed);
speed = min(point_distance(0, 0, horizontalSpeed, verticalSpeed), maximumSpeed);

if speed < deceleration
{
	speed = 0;
}

if (global.debug3DCam)
{
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed) + Camera.Forward;
	Camera.MouseLock = mouse_check_button(mb_right);
}
else
{
	direction = point_direction(0, 0, horizontalSpeed, verticalSpeed);
}

if place_meeting(x+hspeed,y,o_block)
{
	while(place_free(x+sign(hspeed),y))
	{
		x+=sign(hspeed);
	}
		
	hspeed=0;
}
	
if place_meeting(x,y+vspeed,o_block)
{
	while(place_free(x,y+sign(vspeed)))
	{
		y+=sign(vspeed);
	}
		
	vspeed=0;
}
	
if place_meeting(x+hspeed,y+vspeed,o_block)
{
	while(place_free(x+sign(hspeed),y+sign(vspeed)))
	{
		x+=sign(hspeed);
		y+=sign(vspeed);
	}
		
	hspeed=0;
	vspeed=0;
}