if (player == 0)
{
	rightKey = ord("D");
	leftKey = ord("A");
	upKey = ord("W");
	downKey = ord("S");
	jumpKey = vk_space;
	interactionKey = vk_lshift;
	color = c_red;
}

if (player == 1)
{
	rightKey = vk_right;
	leftKey = vk_left;
	upKey = vk_up;
	downKey = vk_down;
	jumpKey = vk_rshift;
	interactionKey = vk_rcontrol;
	color = c_blue;
}


acceleration = 0.5;
deceleration = 0.25;
maximumSpeedDecelerationFactor = 0.25;

maximumSpeed = 6;

maximumDefaultSpeed = 6;

maximumRampSpeed = 4.5;
maximumSlopeSpeed = 3;

slopeAcceleration = 0.1;
rampAcceleration = 0.05;

slopeSpeedTransitionFactor = 0.5;

desiredHorizontalDirection = 0;
desiredVerticalDirection = 0;
horizontalSpeed = 0;
verticalSpeed = 0;
lastDirection = 0;

gravitation = 0.25;
jumpForce = 7;
momentumJumpForce = 2;
jumpBuffor = 0;
maximumJumpBuffor = 10;

coyoteTime = 0;
maximumCoyoteTime = 10;

isGrounded = false;
groundImOn = noone;

obstacleRange = 60;
minimumObstacleJumpForce = 5;
maximumObstacleJumpForce = 10;