if (player == 0)
{
	rightKey = ord("D");
	leftKey = ord("A");
	upKey = ord("W");
	downKey = ord("S");
	jumpKey = vk_space;
	interactionKey = vk_lshift;
	color = c_red;
	isChasing = true;
}

if (player == 1)
{
	rightKey = vk_right;
	leftKey = vk_left;
	upKey = vk_up;
	downKey = vk_down;
	jumpKey = vk_rcontrol;
	interactionKey = vk_rshift;
	color = c_blue;
	isChasing = true;
}

maximumDefaultSpeedModificator = 0;
accelerationModificator = 0;
decelerationModificator = 0;
maximumSpeedDecelerationFactorModificator = 0;
jumpForceModificator = 0;
momentumJumpForceModificator = 0;
gravitationModificator = 0;
slopeAccelerationModificator = 0;
slopeDecelerationModificator = 0;
rampAccelerationModificator = 0;
rampDecelerationModificator = 0;
maximumSlopeSpeedModificator = 0;
maximumRampSpeedModificator = 0;
slopeSpeedTransitionFactorModificator = 0;
maximumCoyoteTimeModificator = 0;
obstacleRangeModificator = 0;
maximumObstacleJumpForceModificator = 0;
minimumObstacleJumpForceModificator = 0;
maximumJumpBufforModificator = 0;

function setupStats()
{
	maximumDefaultSpeed = o_gameManager.maximumDefaultSpeed + maximumDefaultSpeedModificator;
	acceleration = o_gameManager.acceleration + accelerationModificator;
	deceleration = o_gameManager.deceleration + decelerationModificator;
	maximumSpeedDecelerationFactor = o_gameManager.maximumSpeedDecelerationFactor + maximumSpeedDecelerationFactorModificator;
	jumpForce = o_gameManager.jumpForce + jumpForceModificator;
	momentumJumpForce = o_gameManager.momentumJumpForce + momentumJumpForceModificator;
	gravitation = o_gameManager.gravitation + gravitationModificator;
	slopeAcceleration = o_gameManager.slopeAcceleration + slopeAccelerationModificator;
	slopeDeceleration = o_gameManager.slopeDeceleration + slopeDecelerationModificator;
	rampAcceleration = o_gameManager.rampAcceleration + rampAccelerationModificator;
	rampDeceleration = o_gameManager.rampDeceleration + rampDecelerationModificator;
	maximumSlopeSpeed = o_gameManager.maximumSlopeSpeed + maximumSlopeSpeedModificator;
	maximumRampSpeed = o_gameManager.maximumRampSpeed + maximumRampSpeedModificator;
	slopeSpeedTransitionFactor = o_gameManager.slopeSpeedTransitionFactor + slopeSpeedTransitionFactorModificator;
	maximumCoyoteTime = o_gameManager.maximumCoyoteTime + maximumCoyoteTimeModificator;
	obstacleRange = o_gameManager.obstacleRange + obstacleRangeModificator;
	maximumObstacleJumpForce = o_gameManager.maximumObstacleJumpForce + maximumObstacleJumpForceModificator;
	minimumObstacleJumpForce = o_gameManager.minimumObstacleJumpForce + minimumObstacleJumpForceModificator;
	maximumJumpBuffor = o_gameManager.maximumJumpBuffor + maximumJumpBufforModificator;
}

setupStats();

maximumSpeed = 6;
desiredHorizontalDirection = 0;
desiredVerticalDirection = 0;
horizontalSpeed = 0;
verticalSpeed = 0;
lastDirection = 0;
jumpBuffor = 0;
coyoteTime = 0;
isGrounded = false;
groundImOn = noone;

maximumCaughtRange = 0;

with(o_char)
{
	if (obstacleRange > other.maximumCaughtRange)
	{
		other.maximumCaughtRange = obstacleRange;
	}
}

surface = surface_create(maximumCaughtRange * 2, maximumCaughtRange * 2);

circleRadius = shader_get_uniform(shd_obstacleRing, "circleRadius");

nearestPlayer = id;
canCaught = false;