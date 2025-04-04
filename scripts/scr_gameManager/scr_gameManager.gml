function createUI()
{
	ui = new UI();
	
	with(ui)
	{
		mainLayer = new Layer();
		mainLayer.setGrid(10, 10);
		
		leftColor = new Output();
		rightColor = new Output();
		
		with(leftColor)
		{
			scr_makeDraCircle();
		}
		
		with(rightColor)
		{
			scr_makeDraCircle();
		}
		
		chaseBar = new Output(, -10);
		chaseBar.setSprite(s_chaseBar);
		
		roundNumber = new Text("Round 0/16", f_chaseBar);
		roundNumber.setColor(c_black);
		
		leftPortrait = new Output(15, -20);
		leftPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		leftPoints = new Text("0", f_chaseBar);
		
		rightPortrait = new Output(-15, -20);
		rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, 0);
		
		rightPoints = new Text("0", f_chaseBar);
		
		
		roundTimer = new GradientBar(1);
		roundTimer.setColor(c_red);
		roundTimer.setScale(0.2, 0.2);
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
		
		toStartTimer = new Text("3", f_test);
		toStartTimer.setScale(0, 0);
		
		chaseBarGroup = new Group();
		chaseBarGroup.setGrid(1, 1);
		//chaseBarGroup.addComponent(-0.835, -0.19, leftColor);
		//chaseBarGroup.addComponent(0.835, -0.19, rightColor);
		//chaseBarGroup.addComponent(0, 0, chaseBar);
		//chaseBarGroup.addComponent(-1, 0, leftPortrait);
		//chaseBarGroup.addComponent(1, 0, rightPortrait);
		//chaseBarGroup.addComponent(0, -0.42, roundNumber);
		//chaseBarGroup.addComponent(-1.27, -0.17, leftPoints);
		//chaseBarGroup.addComponent(1.27, -0.17, rightPoints);
		chaseBarGroup.addComponent(-1, -1, roundTimer);
		//chaseBarGroup.setProperties(0.6, 0.6);
		
		//rightPortrait.setScale(-0.6);
		
		mainLayer.addComponent(5, 1, chaseBarGroup);
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
				
			if (array_length(other.players) == 2)
			{
				rightColor.setColor(other.players[1].instance.color);
				rightPortrait.state.setSpriteSheet(s_chaseBarPortraits, other.players[1].instance.portrait);
				rightStamina.setColor(other.players[1].instance.color);
			}
		}
	}
	
	imChasingSystem = part_system_copy(ps_imChasing, 0);
	imChasingType = part_type_copy(ps_imChasing, 0);
	part_emitter_type(imChasingSystem, 0, imChasingType);
	part_system_automatic_draw(imChasingSystem, false);
}

function updateUI()
{
	ui.step();
	
	with(ui)
	{
		roundNumber.setContent(string("Round {0}/16", other.rounds));
		leftPoints.setContent(string(other.players[0].points));
		roundTimer.setValue(other.chaseTime / other.maximumChaseTime);
		
		var leftPlayer = other.players[0].instance;
		
		var pos = [];
		
		if (other.isGravitationOn)
		{
			pos = world_to_gui(
				leftPlayer.x + leftPlayer.image_xscale * 28 + leftPlayer.hspeed,
				leftPlayer.y - 20 + leftPlayer.vspeed,
				leftPlayer.z);
		}
		else 
		{
			if (sign(leftPlayer.image_xscale) == 1) 
			{
				pos = world_to_gui(
					leftPlayer.x + leftPlayer.image_xscale * 16 + leftPlayer.hspeed,
					leftPlayer.y - 48 + leftPlayer.vspeed,
					leftPlayer.z);
			}
			else 
			{
				pos = world_to_gui(
					leftPlayer.x + leftPlayer.image_xscale * 36 + leftPlayer.hspeed,
					leftPlayer.y - 40 + leftPlayer.vspeed,
					leftPlayer.z);
			}
		}
		
		leftStamina.setValue(leftPlayer.skillEnergy);
		leftStamina.setShift(pos[0], pos[1]);
		leftStamina.setScale((0.8 * leftPlayer.image_xscale) / Camera.Zoom, 0.8 / Camera.Zoom);
	
		if (array_length(other.players) == 2)
		{
			rightPoints.setContent(string(other.players[1].points));
			
			var rightPlayer = other.players[1].instance;
			
			if (other.isGravitationOn)
			{
				pos = world_to_gui(
					rightPlayer.x + rightPlayer.image_xscale * 28 + rightPlayer.hspeed,
					rightPlayer.y - 20 + rightPlayer.vspeed,
					rightPlayer.z);
			}
			else 
			{
				if (sign(rightPlayer.image_xscale) == 1) 
				{
					pos = world_to_gui(
						rightPlayer.x + rightPlayer.image_xscale * 16 + rightPlayer.hspeed,
						rightPlayer.y - 48 + rightPlayer.vspeed,
						rightPlayer.z);
				}
				else 
				{
					pos = world_to_gui(
						rightPlayer.x + rightPlayer.image_xscale * 36 + rightPlayer.hspeed,
						rightPlayer.y - 40 + rightPlayer.vspeed,
						rightPlayer.z);
				}
			}
			
			rightStamina.setValue(rightPlayer.skillEnergy);
			rightStamina.setShift(pos[0], pos[1]);
			rightStamina.setScale((0.8 * rightPlayer.image_xscale) / Camera.Zoom, 0.8 / Camera.Zoom);
		}
		
		//--- Count down timer
		
		if (other.isGameOn)
		{
			var scale = lerp(toStartTimer.scaleX, 0, 0.075);
			toStartTimer.setScale(scale, scale);
				
			if (scale <= 0.1)
			{
				scale = 5;
				toStartTimer.setScale(scale, scale);
				var countdown = real(toStartTimer.content);
				if (countdown <= 1)
				{
					scale = 0; 
					//toStartTimer.setContent("GOOO!!!");
					toStartTimer.setScale(scale, scale);
					other.isCountdownActive = false;
				}
				else 
				{
					countdown--;
					toStartTimer.setContent(string(countdown));
				}
			}
		}
	}
		
	//--- Who is chasing Tag
	
	if (isGameOn)
	{
		var instTo = players[whoIsChasing].instance;
		var instFrom = instTo;
		
		if (playerWasCaught)
		{
			whoIsChasingTagPosition[0] = players[!whoIsChasing].instance.x;
			whoIsChasingTagPosition[1] = players[!whoIsChasing].instance.y;
			whoIsChasingTagPosition[2] = 0;
			whoIsChasingTagScale = 1;
			whoIsChasingStage = 0;
			whoIsChasingTagTimer = 0;
			playerWasCaught = false;
		}
		
		switch(whoIsChasingStage)
		{
			case(0):
			{
				if (point_distance(whoIsChasingTagPosition[0], whoIsChasingTagPosition[1], instTo.x, instTo.y) < 10)
				{
					whoIsChasingStage = 1;
				}
				
				whoIsChasingTagPosition[0] = lerp(whoIsChasingTagPosition[0], instTo.x, 0.1);
				whoIsChasingTagPosition[1] = lerp(whoIsChasingTagPosition[1], instTo.y, 0.1)
				break;
			}
		
			case(1):
			{
				whoIsChasingTagPosition[0] = lerp(whoIsChasingTagPosition[0], instTo.x, 0.1);
				whoIsChasingTagPosition[2] = animcurve_get_point(ac_whoIsChasingChange, 0, whoIsChasingTagTimer) * -15;
				whoIsChasingTagScale = animcurve_get_point(ac_whoIsChasingChange, 1, whoIsChasingTagTimer);
				whoIsChasingTagTimer = armez_timer(whoIsChasingTagTimer, 0.01);
				
				if (whoIsChasingTagScale <= 0.1)
				{
					whoIsChasingStage = 2;
					
					whoIsChasingTagScale = 0;
					part_type_color1(imChasingType, instTo.color);
					part_emitter_region(imChasingSystem, 0, instTo.x - 16, instTo.x + 16, instTo.y - 16, instTo.y + 16, ps_shape_rectangle, ps_distr_linear);
					part_emitter_burst(imChasingSystem, 0, imChasingType, 32);
				}
				
				break;
			}
		}
	}
}

function drawUI()
{
	if (global.debugEdit)
	{
		return;
	}
	
	ui.draw();
	
	var pos = [];

	pos = world_to_gui(
		whoIsChasingTagPosition[0],
		whoIsChasingTagPosition[1],
		whoIsChasingTagPosition[2]);

	draw_sprite_ext(s_isChasingTag, 3, pos[0], pos[1] - 60 / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, (0.4 * whoIsChasingTagScale) / Camera.Zoom, 0, c_white, 1);
}

function setGameRulesValues()
{
	maximumChaseTime = 1020;
	changesPerChase = 4;
	
	isGravitationOn = false;
	chaseTime = maximumChaseTime;
	isGameOn = false;
	rounds = 0;
	players = [];
	
	whoIsChasing = 0;
	playerWasCaught = false;
	whoIsChasingTagTimer = 0;
	whoIsChasingTagPosition = [0, 0, 0];
	whoIsChasingTagScale = 1;
	whoIsChasingStage = 1;
	
	isCountdownActive = false;
		
	vignetteTime = 0;
	vignettePulse = false;
	pulseCounter = 0;
}

function setActiveSkills()
{
	enum skillTypes
	{
		sprint,
		dash,
		jumpBack
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
	jumpBack = new skill("jump back", 0.33, 0.01, 2, 0.33)
	
	array_push(skills, sprint, dash, jumpBack);
}

function setGameRulesFunctions()
{
	reset = function()
	{
		with(o_debugController)
		{
			scr_clearLog();
		}
		
		chaseTime = maximumChaseTime;
	
		if (global.debugIsGravityOn)
		{
			global.debugIsGravityOn = !global.debugIsGravityOn;
			scr_gravitationChange();
		}
		
		instance_activate_object(o_start);
		
		with(o_char)
		{
			var playerNumber = player;
			
			with(o_start)
			{
				if (playerNumber == linkToPlayer)
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
			
			log(string("P{0}: {1}", player + 1, other.players[player].points), color);
		}
		
		with(o_cameraTarget)
		{
			var _x = 0;
			var _y = 0;
			
			with(o_char)
			{
				_x += x;
				_y += y;
			}
			
			x = _x / instance_number(o_char);
			y = _y / instance_number(o_char);
			
			Camera.x = x;
			Camera.y = y;
		}
		
		o_debugController.previousTab = -1;
		
		if (isGameOn)
		{
			//wait(1.5);
		
			rounds++;
			
			if (rounds > 15)
			{
				var indexOfWinner = 0;
				for(var i = 0; i < array_length(players); i++)
				{
					if (players[i].points > players[indexOfWinner].points)
					{
						indexOfWinner = i;
					}
				}
				
				if (players[0].points == players[1].points)
				{
					log(string("Round {0}/15", rounds));
				}
				else
				{			
					log("END");
					log(string("WINNER: Player {0}", indexOfWinner), c_orange);
					
					startStop();
				}
			}
			else
			{		
				log(string("Round {0}/16", rounds));
			}
			
			with(ui)
			{
				toStartTimer.setContent("3");
				toStartTimer.setScale(5, 5);
			}
			isCountdownActive = true;
		}
		
		scr_vignetteReset();
	}
	
	startStop = function()
	{
		isGameOn = !isGameOn;
		
		if (isGameOn)
		{
			for (var i = 0; i < array_length(players); i++)
			{
				players[i].points = 0;
			}
			
			players[0].instance.isChasing = true;
			players[1].instance.isChasing = false;
			
			rounds = 0;
			chaseTime = maximumChaseTime;
			
			playerWasCaught = false;
			
			reset();
		}
		
		whoIsChasingTagPosition[0] = players[0].instance.x;
		whoIsChasingTagPosition[1] = players[0].instance.y;
	}
	
	gameLogic = function()
	{
		if (isGameOn and !isCountdownActive)
		{
			chaseTime--;
			
			for (var i = 0; i < 4; i++)
			{
				if ((chaseTime - (i * 40)) mod (maximumChaseTime div changesPerChase) == 0)
				{
					vignettePulse = true;
					
					if (i == 3)
					{
						audio_play_sound(sn_gravityChangeWarning, 0, false);
					}
				}
			}
			
			if (vignettePulse)
			{
				scr_vignettePulse();
			}
			else
			{
				if (pulseCounter == 0)
				{
					scr_vignettePullBack();
				}
			}
		
			if (chaseTime mod (maximumChaseTime div changesPerChase) == 0)
			{
				global.debugIsGravityOn = !global.debugIsGravityOn;
				scr_gravitationChange();
				log("CHANGE!", c_yellow);
			}
			
			if (chaseTime <= 0)
			{
				with(o_char)
				{
					if (!isChasing)
					{
						log(string("Player {0} ESCAPED!", player), color);
					}
				}
				
				players[!whoIsChasing].points++;
				
				reset();
			}
		}
	}
	
	caught = function()
	{
		log(string("Player {0} CAUGHT!", whoIsChasing), players[whoIsChasing].instance.color);
		
		whoIsChasingTagPosition[0] = players[whoIsChasing].instance.x;
		whoIsChasingTagPosition[1] = players[whoIsChasing].instance.y;
		
		whoIsChasing = !whoIsChasing;
		playerWasCaught = true;
	
		reset();
	}
}


function setPlayersDefaultMovementRules()
{
	maximumDefaultSpeed = 6;
	acceleration = 0.5;
	deceleration = 0.25;
	maximumSpeedDecelerationFactor = 0.25;
	jumpForce = 7;
	momentumJumpForce = 2;
	gravitation = 0.25;
	slopeAcceleration = 0.1;
	slopeDeceleration = 0.1;
	rampAcceleration = 0.05;
	rampDeceleration = 0.05;
	maximumSlopeSpeed = 3;
	maximumRampSpeed = 4.5;
	slopeSpeedTransitionFactor = 0.5;
	maximumCoyoteTime = 10;
	obstacleRange = 60;
	maximumObstacleJumpForce = 10;
	minimumObstacleJumpForce = 5;
	maximumJumpBuffor = 10;
}
