//--- UI States

function setupUIStates()
{
    freeState = function()
    {
        updateBar();
        updateStamina();
    }
    
    countdownState = function()
    {
        updateBar();
        updateStamina();
        updateCountdown();
        updateWhoIsChasing();
    }
    
    gameState = function()
    {
        updateBar();
        updateStamina();
    }
    
    breathState = function()
    {
        updateBar();
        updateWhoIsChasing();
    }
}

function updateBar()
{
    with(ui)
	{
        roundNumber.setContent(string("Round {0}/16", other.rounds));
        leftPoints.setContent(string(other.players[0].points));
        roundTimer.setValue(other.chaseTime / other.maximumChaseTime);
        
        isChasingCircleTag.posInGridX = lerp(isChasingCircleTag.posInGridX, 1.05 * lerp(-1, 1, other.whoIsChasing), 0.1);
        isChasingCircleTag.scaleX = lerp(isChasingCircleTag.scaleX, 0.175 * lerp(1, -1, other.whoIsChasing), 0.1);
    }
}

function updateStamina()
{
    with(ui)
	{
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

function updateCountdown()
{
    with(ui)
	{
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
}

function updateWhoIsChasing()
{
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