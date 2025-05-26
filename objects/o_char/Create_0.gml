scr_setupSprites();
armScale = 0;
armX = x;
armY = y;

if (player == 0)
{
	color = c_red;
	skill = skillTypes.sprint;
	pasive = new o_gameManager.pasiveSkills();
    pasive.wallJump = true;
	
	portrait = 1;
    art = sVN_adam;
}

if (player == 1)
{
	color = c_lime;
	skill = skillTypes.sprint;
	pasive = new o_gameManager.pasiveSkills();
	
	portrait = 2;
    art = sVN_trickster;
}

o_gameManager.players[player] = 
{
	instance: id,
	points: 0
};

var playerId = player;
var playrtArt = art;
with(o_gameManager.ui)
{
    if (playerId == 0)
    {
        leftFullBodyPortrait.state.setSpriteSheet(playrtArt, 0);
    }
    else 
    {
    	rightFullBodyPortrait.state.setSpriteSheet(playrtArt, 0);
    }
}

maximumDefaultSpeedModificator = 0;
accelerationModificator = 0;
decelerationModificator = 0;
maximumSpeedDecelerationFactorModificator = 0;
jumpForceModificator = 0;
maxJumpNumberModificator = 0;
momentumJumpForceModificator = 0;
gravitationModificator = 0;
slopeAccelerationModificator = 0;
slopeDecelerationModificator = 0;
slopeMinSpeedModificator = 0;
rampAccelerationModificator = 0;
rampDecelerationModificator = 0;
rampMinSpeedModificator = 0;
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
    
    if (pasive.noUpHillPenalty)
    {
        slopeMinSpeed = maximumDefaultSpeed - o_gameManager.slopeMinSpeed;
        rampMinSpeed = maximumDefaultSpeed - o_gameManager.rampMinSpeed;
    }
    else 
    {
    	slopeMinSpeed = o_gameManager.slopeMinSpeed + slopeMinSpeedModificator;
        rampMinSpeed = o_gameManager.rampMinSpeed + rampMinSpeedModificator;
    }
    
	acceleration = o_gameManager.acceleration + accelerationModificator;
	deceleration = o_gameManager.deceleration + decelerationModificator;
	maximumSpeedDecelerationFactor = o_gameManager.maximumSpeedDecelerationFactor + maximumSpeedDecelerationFactorModificator;
	jumpForce = o_gameManager.jumpForce + jumpForceModificator;
	maxJumpNumber = o_gameManager.maxJumpNumber + maxJumpNumberModificator;
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
	
	o_gameManager.characterColorUiUpdate();
}

setupStats();

maximumSpeed = 6;
desiredHorizontalDirection = 0;
desiredVerticalDirection = 0;
horizontalSpeed = 0;
verticalSpeed = 0;
lastDirection = 0;
jumpBuffor = 0;
jumpNumber = 0;
coyoteTime = 0;
wallJumpCoyoteTime = 0;
isGrounded = false;
groundImOn = noone;
lastWallDirection = 0;
isAirDashUsed = false;
airHorizontalSpeed = 0;
driftDirection = 0;
driftSpeed = 0;
driftMeter = 0;

maximumCaughtRange = 0;

isReady = false;

with(o_char)
{
	if (obstacleRange > other.maximumCaughtRange)
	{
		other.maximumCaughtRange = obstacleRange;
	}
}

surface = surface_create(maximumCaughtRange * 2, maximumCaughtRange * 2);

nearestPlayer = id;
canCaught = false;
slap = false;

afterimageList = ds_list_create();

setAfterImageUniform = function(alphaDecay, color)
{
	shader_set_uniform_f(shader_get_uniform(shd_afterimage, "alphaDecay"), alphaDecay);	
	shader_set_uniform_f(shader_get_uniform(shd_afterimage, "color"), color_get_red(color) / 255, color_get_green(color) / 255, color_get_blue(color) / 255);	
}

setChasingOutlineUniform = function(uvs, color, hand)
{
	shader_set_uniform_f(shader_get_uniform(shd_outline, "size"), texture_get_texel_width(sprite_get_texture(sprite_index, image_index)), texture_get_texel_height(sprite_get_texture(sprite_index, image_index)));
	shader_set_uniform_f(shader_get_uniform(shd_outline, "thick"), thick);
	shader_set_uniform_f(shader_get_uniform(shd_outline, "glow"), glow);
	shader_set_uniform_f(shader_get_uniform(shd_outline, "time"), current_time);
	shader_set_uniform_f(shader_get_uniform(shd_outline, "uvs"), uvs[0], uvs[1], uvs[2], uvs[3]);
	shader_set_uniform_f(shader_get_uniform(shd_outline, "hand"), hand);
	shader_set_uniform_f_array(shader_get_uniform(shd_outline, "color"), 
	[
		color_get_red(color) / 255,
		color_get_green(color) / 255,
		color_get_blue(color) / 255,
	]);
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

thick = 7;
glow = 0;

function reset()
{
    with(o_start)
    {
        if (other.player == linkToPlayer)
        {
            other.x = x;
            other.y = y;
        }
    }
    
    speed = 0;
    hspeed = 0;
    vspeed = 0;
    desiredHorizontalDirection = 0;
    desiredVerticalDirection = 0;
    horizontalSpeed = 0;
    verticalSpeed = 0;
    skillEnergy = 1;
    
    nearestPlayer = id;
    canCaught = false;
    
    thick = 7;
    glow = 0;
    
    isReady = false;
    
    log(string("P{0}: {1}", player + 1, o_gameManager.players[player].points), color);
}