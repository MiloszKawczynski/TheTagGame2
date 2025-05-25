function createUI()
{
	ui = new UI();
	
	with(ui)
	{
		mainLayer = new Layer();
		mainLayer.setGrid(10, 10);
		
		leftColor = new Output();
		rightColor = new Output();
        isChasingCircleTag = new Output();
		isChasingCircleTag.setSprite(s_isChasingTagCircle);
        
		with(leftColor)
		{
			scr_makeDrawCircle();
		}
		
		with(rightColor)
		{
			scr_makeDrawCircle();
		}
        
        with(isChasingCircleTag)
        {
            scr_makeDrawCircleChasingTag();
        }
		
		chaseBar = new Output(, -10);
		chaseBar.setSprite(s_chaseBar);
		
		roundNumber = new Text("Round 0/16", f_chaseBar, fa_center, fa_middle,, -7);
		roundNumber.setColor(c_white);
		
		leftPortrait = new Output(15, -20);
		leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		leftPoints = new Text("0", f_chaseBarPoints, fa_center, fa_middle, 0, -6.5);
		
		rightPortrait = new Output(-15, -20);
		rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		rightPoints = new Text("0", f_chaseBarPoints, fa_center, fa_middle, 0, -6.5);
		
		roundTimer = new GradientBar(1, -5);
		roundTimer.setColor(c_red);
		with(roundTimer)
		{
			scr_makeTimerBar();
		}
		
		leftStamina = new GradientBar(1);
		rightStamina = new GradientBar(1);
		
		with(leftStamina)
		{
			scr_makeStaminaBar();
		}
		
		with(rightStamina)
		{
			scr_makeStaminaBar();
		}
		
		toStartTimer = new Text("", f_test);
		
		leftPlayerGroup = new Group();
		leftPlayerGroup.setGrid(1, 1);
		leftPlayerGroup.addComponent(0, 0, leftColor);
		leftPlayerGroup.addComponent(0, 0, leftPortrait);
		
		rightPlayerGroup = new Group();
		rightPlayerGroup.setGrid(1, 1);
		rightPlayerGroup.addComponent(0, 0, rightColor); 
		rightPlayerGroup.addComponent(0, 0, rightPortrait);
		
		chaseBarGroup = new Group();
		chaseBarGroup.setGrid(1, 1);
		chaseBarGroup.addComponent(0, 0, chaseBar);
		chaseBarGroup.addComponent(-1, -1, roundTimer);
		chaseBarGroup.addComponent(-1.15, -0.45, leftPlayerGroup);
		chaseBarGroup.addComponent(1.15, -0.45, rightPlayerGroup);
		chaseBarGroup.addComponent(0, 0, roundNumber);
		chaseBarGroup.addComponent(-0.75, 0, leftPoints);
		chaseBarGroup.addComponent(0.75, 0, rightPoints);
		chaseBarGroup.addComponent(-1.05, 0.1, isChasingCircleTag);
		chaseBarGroup.setProperties(0.2, 0.2);
		
		leftPlayerGroup.setProperties(0.125, 0.125);
		rightPlayerGroup.setProperties(0.125, 0.125);
		
		leftPortrait.setScale(0.4, 0.4);
		rightPortrait.setScale(-0.4, 0.4);
		
		leftPortrait.setShift(0, -7.5);
		rightPortrait.setShift(0, -7.5);
        
        isChasingCircleTag.setScale(0.175, 0.175);
		
		mainLayer.addComponent(5, 1.05, chaseBarGroup);
		mainLayer.addComponent(0, 0, leftStamina);
		mainLayer.addComponent(0, 0, rightStamina);
		
		mainLayer.addComponent(5, 5, toStartTimer);
	
		pushLayer(mainLayer);
	}
	
	characterColorUiUpdate = function()
	{
		with(ui)
		{
			leftColor.setColor(other.players[0].instance.color);
			leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, other.players[0].instance.portrait);
			leftStamina.setColor(other.players[0].instance.color);
			leftPoints.setColor(other.players[0].instance.color);
				
			if (array_length(other.players) == 2)
			{
				rightColor.setColor(other.players[1].instance.color);
				rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, other.players[1].instance.portrait);
				rightStamina.setColor(other.players[1].instance.color);
				rightPoints.setColor(other.players[1].instance.color);
			}
		}
	}
	
	imChasingSystem = part_system_copy(ps_imChasing, 0);
	imChasingType = part_type_copy(ps_imChasing, 0);
	part_emitter_type(imChasingSystem, 0, imChasingType);
	part_system_automatic_draw(imChasingSystem, false);
}

function drawUI()
{
	if (global.debugEdit)
	{
		return;
	}
	
	ui.draw();
	
    if (uiState == UIcountdownState
        or uiState == UIbreathState)
    {
    	var pos = [];
    
    	pos = world_to_gui(
    		whoIsChasingTagPosition[0],
    		whoIsChasingTagPosition[1],
    		whoIsChasingTagPosition[2]);
    
    	draw_sprite_ext(s_isChasingTag, 3, pos[0], pos[1] - 60 / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, 0, c_white, 1);
    }
}

function setGameRulesValues()
{
	maximumChaseTime = 1020;
	changesPerChase = 4;
	
	isGravitationOn = false;
	chaseTime = maximumChaseTime;
	rounds = 0;
	players = [];
	
	whoIsChasing = 0;
	playerWasCaught = false;
	whoIsChasingTagTimer = 0;
	whoIsChasingTagPosition = [0, 0, 0];
	whoIsChasingTagScale = 1;
	whoIsChasingStage = 1;
		
	vignetteTime = 0;
	vignettePulse = false;
	pulseCounter = 0;
    
    breathTimer = 0;
}

function setActiveSkills()
{
	enum skillTypes
	{
		sprint,
		dash,
		jumpBack,
		//gravityManipulation,
        //teleport,
        float,
        drift
	}
	
	skill = function(_name, _usage, _replenish, _value, _rechargePercentage) constructor
	{
		name = _name;
		usage = _usage;
		replenish = _replenish;
		value = _value;
		rechargePercentage = _rechargePercentage;
	}
	
	skills = [];
	
	sprint = new skill("sprint", 0.01, 0.01, 0.33, 0);
	dash = new skill("dash", 1, 0.005, 2, 1);
	jumpBack = new skill("jump back", 0.33, 0.01, 2, 0.33);
	gravityManipulation = new skill("gravity manipulation", 0.01, 0.01, 1, 1);
    teleport = new skill("teleport", 1, 0.005, 20, 1);
    float = new skill("float", 0.02, 0.005, 5, 0.33);
    drift = new skill("drift", 0.03, 0.1, 10, 0.33);
	
	array_push(skills, sprint, dash, jumpBack, float, drift);
}

function setPasiveSkills()
{
	pasiveSkills = function() constructor
	{
		wallJump = false;
        alwaysPerfectVault = false;
        noUpHillPenalty = false;
        airDash = false;
        autoCatch = false;
	}
}

function setPlayersDefaultMovementRules()
{
	maximumDefaultSpeed = 6;
	acceleration = 0.5;
	deceleration = 0.25;
	maximumSpeedDecelerationFactor = 0.25;
	jumpForce = 7;
	maxJumpNumber = 1;
	momentumJumpForce = 2;
	gravitation = 0.25;
	slopeAcceleration = 0.1;
	slopeDeceleration = 0.1;
    slopeMinSpeed = 0.1;
	rampAcceleration = 0.05;
	rampDeceleration = 0.05;
	rampMinSpeed = 0.05;
	maximumSlopeSpeed = 3;
	maximumRampSpeed = 4.5;
	slopeSpeedTransitionFactor = 0.5;
	maximumCoyoteTime = 10;
	obstacleRange = 60;
	maximumObstacleJumpForce = 10;
	minimumObstacleJumpForce = 5;
	maximumJumpBuffor = 10;
}