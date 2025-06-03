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
        
        chaseBarPointsPocketLeft = new Output(, -10);
		chaseBarPointsPocketLeft.setSprite(s_chaseBarPointsPocket);
        
        chaseBarPointsPocketRight = new Output(, -10);
		chaseBarPointsPocketRight.setSprite(s_chaseBarPointsPocket);
		
		roundNumber = new Text("Round 0/16", f_chaseBar, fa_center, fa_middle,, -7);
		roundNumber.setColor(c_white);
		
		leftPortrait = new Output(15, -20);
		leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		leftPoints = new Text("0", f_chaseBarPoints, fa_center, fa_middle, 0, -6);
		
		rightPortrait = new Output(-15, -20);
		rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		rightPoints = new Text("0", f_chaseBarPoints, fa_center, fa_middle, 0, -6);
		
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
		
		toStartTimer = new Text("", f_countDown);
		
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
		chaseBarGroup.addComponent(0, 0, chaseBarPointsPocketLeft);
		chaseBarGroup.addComponent(0, 0, chaseBarPointsPocketRight);
		chaseBarGroup.addComponent(-1, -1, roundTimer);
		chaseBarGroup.addComponent(-1.15, -0.45, leftPlayerGroup);
		chaseBarGroup.addComponent(1.15, -0.45, rightPlayerGroup);
		chaseBarGroup.addComponent(0, 0, roundNumber);
		chaseBarGroup.addComponent(-0.75, 0, leftPoints);
		chaseBarGroup.addComponent(0.75, 0, rightPoints);
		chaseBarGroup.addComponent(-1.05, 0.1, isChasingCircleTag);
		chaseBarGroup.setProperties(0.2, 0.2);
        
        chaseBarPointsPocketRight.setScale(-0.2, 0.2);
		
		leftPlayerGroup.setProperties(0.125, 0.125);
		rightPlayerGroup.setProperties(0.125, 0.125);
		
		leftPortrait.setScale(0.4, 0.4);
		rightPortrait.setScale(-0.4, 0.4);
		
		leftPortrait.setShift(0, -7.5);
		rightPortrait.setShift(0, -7.5);
        
        isChasingCircleTag.setScale(0.175, 0.175);
		
        mainLayer.addComponent(0, 0, leftStamina);
		mainLayer.addComponent(0, 0, rightStamina);
		mainLayer.addComponent(5, 1.05, chaseBarGroup);
		
		mainLayer.addComponent(5, 5, toStartTimer);
        
        leftFullBodyPortrait = new Output(0, 0);
		rightFullBodyPortrait = new Output(0, 0);
        
        leftFullBodyPortrait.setScale(0.225, 0.225);
        rightFullBodyPortrait.setScale(-0.225, 0.225);
        
        mainLayer.addComponent(-2, 5, leftFullBodyPortrait);
		mainLayer.addComponent(12, 5, rightFullBodyPortrait);
        
	
		pushLayer(mainLayer);
	}
	
	imChasingSystem = part_system_copy(ps_imChasing, 0);
	imChasingType = part_type_copy(ps_imChasing, 0);
	iChatchedType = part_type_copy(ps_iCatched, 0);
	part_emitter_type(imChasingSystem, 0, imChasingType);
	part_system_automatic_draw(imChasingSystem, false);
}

function drawUI()
{
	if (global.debugEdit)
	{
		return;
	}
	
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
    
    if (uiState == UIbreathState)
    {
        var shockPositionPlayer = players[whoIsChasing].instance;
        var shockPosition = array_create(3);
        shockPosition[0] = shockPositionPlayer.x;
        shockPosition[1] = shockPositionPlayer.y;
        shockPosition[2] = 0;
        
        var shockGUIPosition = world_to_gui(shockPosition[0], shockPosition[1], shockPosition[2]);
        
        draw_sprite_ext(s_shockBubble, 0, shockGUIPosition[0], shockGUIPosition[1], shockScale / Camera.Zoom, shockScale / Camera.Zoom, 0, c_white, 1);
    }
    
    ui.draw();
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
    shockScale = 2;
		
	vignetteTime = 0;
	vignettePulse = false;
	pulseCounter = 0;
    
    breathTimer = 0;
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
	slopeSpeedTransitionFactor = 0.5;
	maximumCoyoteTime = 10;
	obstacleRange = 60;
	catchRange = 60;
	maximumObstacleJumpForce = 10;
	minimumObstacleJumpForce = 5;
	maximumJumpBuffor = 10;
}