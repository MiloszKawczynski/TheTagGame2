o_gameManager.players[player] = 
{
	instance: id,
	points: 0
};

characterID = characterTypes.adam;

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
skillUsageModificator = 0;
skillReplenishModificator = 0;
skillValueModificator = 0;

obstacleSurface = undefined;

function setupStats(isCharacterSet)
{
    if (isCharacterSet)
    {
        var characterReference;
        characterReference = global.characters[characterID];
        
        color = characterReference.color;
        skill = characterReference.active;
        pasive = characterReference.pasive;
        art = characterReference.art;
        miniArt = characterReference.miniArt;
        vignetteID = characterReference.vignetteID;
        
        scr_setupSprites(characterReference);
    }
    
    var playerId = player;
    var playerArt = art;
    var playerMiniArt = miniArt;
    var playerColor = color;
    
    with(o_gameManager.ui)
    {
        if (playerId == 0)
        {
            leftFullBodyPortrait.state.setSpriteSheet(playerArt, 0);
            leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, playerMiniArt);
            leftColor.setColor(playerColor);
            leftStamina.setColor(playerColor);
            leftPoints.setColor(playerColor);
        }
        else 
        {
        	rightFullBodyPortrait.state.setSpriteSheet(playerArt, 0);
            rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, playerMiniArt);
            rightColor.setColor(playerColor);
            rightStamina.setColor(playerColor);
            rightPoints.setColor(playerColor);
        }
    }
    
    skillEnergy = 1;
    skillRecharging = false;
    skillUsed = false;
    isSkillActive = 0;
    
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
	
    skillType = skill.type;
	skillUsage = skill.usage + skillUsageModificator;
	skillReplenish = skill.replenish + skillReplenishModificator;
	skillValue = skill.value + skillValueModificator;
	skillRechargePercentage = skill.rechargePercentage;
    
    runTrailSystem = part_system_copy(ps_runTrail, 0);
    runTrailType = part_type_copy(ps_runTrail, 0);
    part_type_color1(runTrailType, color)
    part_emitter_type(runTrailSystem, 0, runTrailType);
    
    part_system_automatic_draw(runTrailSystem, false);
    
    runTrailSurface = undefined;
    
    if (surface_exists(obstacleSurface))
    {
        surface_resize(obstacleSurface, obstacleRange * 2, obstacleRange * 2)
    }
    else 
    {
    	obstacleSurface = surface_create(obstacleRange * 2, obstacleRange * 2);
    }
}

setupStats(true);

maximumSpeed = maximumDefaultSpeed;
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

isReady = false;

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

scr_setupTopDownAnimationStates();
scr_setupPlatformAnimationStates();

angle = 0;
stretch = 1;
squash = 1;

thick = 7;
glow = 0;

armScale = 0;
armX = x;
armY = y;

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
    
    topDownAnimationState = topDownIdleState;
    platformAnimationState = platformIdleState;
    
    log(string("P{0}: {1}", player + 1, o_gameManager.players[player].points), color);
}