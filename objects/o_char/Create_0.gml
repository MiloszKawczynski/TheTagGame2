rightKey = ord("D");
//rightKey = vk_right;
leftKey = ord("A");
//leftKey = vk_left;
upKey = ord("W");
//upKey = vk_up;
downKey = ord("S");
//downKey = vk_down;
jumpKey = vk_space;
interactionKey = vk_shift;

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

horizontalSpeed = 0;
verticalSpeed = 0;

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