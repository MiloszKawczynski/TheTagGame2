function createUI()
{
	ui = new UI();
	
	with(ui)
	{
		mainLayer = new Layer();
		mainLayer.setGrid(10, 10, false);
		
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
		
		chaseBarGroup = new Group();
		chaseBarGroup.setGrid(1, 1, false);
		chaseBarGroup.addComponent(-0.835, -0.19, leftColor);
		chaseBarGroup.addComponent(0.835, -0.19, rightColor);
		chaseBarGroup.addComponent(0, 0, chaseBar);
		chaseBarGroup.addComponent(-1, 0, leftPortrait);
		chaseBarGroup.addComponent(1, 0, rightPortrait);
		chaseBarGroup.addComponent(0, -0.42, roundNumber);
		chaseBarGroup.addComponent(-1.27, -0.17, leftPoints);
		chaseBarGroup.addComponent(1.27, -0.17, rightPoints);
		chaseBarGroup.setProperties(0.6, 0.6);
		
		rightPortrait.setScale(-0.6);
		
		mainLayer.addComponent(5, 1, chaseBarGroup);
		mainLayer.addComponent(0, 0, leftStamina);
		mainLayer.addComponent(0, 0, rightStamina);
	
		pushLayer(mainLayer);
	}
	
	uiUpdate = function()
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
}

function updateUI()
{
	ui.step();
	
	with(ui)
	{
		roundNumber.setContent(string("Round {0}/16", other.rounds));
		leftPoints.setContent(string(other.players[0].points));
		//ui.timeBar.setValue(chaseTime / maximumChaseTime);
		
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
	}
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
				if (playerNumber == image_index)
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
			
			log(string("P{0}: {1}", player + 1, other.players[player].points), color);
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
		}
		
		isChasingTagAlpha = 1;
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
		}
		
		isChasingTagAlpha = 1;
		whoIsChasingTagPosition[0] = players[0].instance.x;
		whoIsChasingTagPosition[1] = players[0].instance.y;
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
