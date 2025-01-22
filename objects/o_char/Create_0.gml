if (player == 0)
{
	color = c_purple;
	skill = skillTypes.sprint;
	
	portrait = 1;
}

if (player == 1)
{
	color = c_lime;
	skill = skillTypes.sprint;
	
	portrait = 2;
}

o_gameManager.players[player] = 
{
	instance: id,
	points: 0
};

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
skillEnergy = 1;
skillRecharging = false;
skillUsed = false;
isSkillActive = 0;

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
	
	skillUsage = o_gameManager.skills[skill].usage;
	skillReplenish = o_gameManager.skills[skill].replenish;
	skillValue = o_gameManager.skills[skill].value;
	skillRechargePercentage = o_gameManager.skills[skill].rechargePercentage;
	
	o_gameManager.uiUpdate();
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
canCaught = false;afterimageList = ds_list_create();
afterimageList = ds_list_create();

setAfterImageUniform = function(alphaDecay, color)
{
	shader_set_uniform_f(shader_get_uniform(shd_afterimage, "alphaDecay"), alphaDecay);	
	shader_set_uniform_f(shader_get_uniform(shd_afterimage, "color"), color_get_red(color) / 255, color_get_green(color) / 255, color_get_blue(color) / 255);	
}

z = 0;

runTrailSystem = part_system_copy(ps_runTrail, 0);
runTrailType = part_type_copy(ps_runTrail, 0);
part_type_color1(runTrailType, color)
part_emitter_type(runTrailSystem, 0, runTrailType);

part_system_automatic_draw(runTrailSystem, false);

runTrailSurface = undefined;

scr_setupTopDownAnimationStates();
scr_setupPlatformAnimationStates();

angle = 0;
stretch = 1;
squash = 1;