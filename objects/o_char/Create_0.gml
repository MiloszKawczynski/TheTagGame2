if (global.debug3DCam)
{
	Camera.Target = id;
}

rightKey = ord("D");
leftKey = ord("A");
upKey = ord("W");
downKey = ord("S");
jumpKey = vk_space;

acceleration = 0.25;
deceleration = 0.25;
maximumSpeed = 3;
horizontalSpeed = 0;
verticalSpeed = 0;

gravitation = 0.25;
jumpForce = 5;