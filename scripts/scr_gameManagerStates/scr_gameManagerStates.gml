//--- UI States

function setupUIStates()
{
    UIfreeState = function()
    {
        updateBar();
        updateStamina();
    }
    
    UIreadyState = function()
    {
        updateBar();
        updateStamina();
        updateCountdown();
    }
    
    UIcountdownState = function()
    {
        updateBar();
        updateStamina();
        updateCountdown();
        updateWhoIsChasing();
    }
    
    UIgameState = function()
    {
        updateBar();
        updateStamina();
    }
    
    UIbreathState = function()
    {
        updateBar();
        updateWhoIsChasing();
    }
    
    //--- UI update functions

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
            if (leftPlayer.skillEnergy == 1)
            {
                leftStamina.setAlpha(lerp(leftStamina.alpha, 0, 0.2));
            }
            else 
            {
            	leftStamina.setAlpha(lerp(leftStamina.alpha, 1, 0.2));
            }
        
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
                if (rightPlayer.skillEnergy == 1)
                {
                    rightStamina.setAlpha(lerp(rightStamina.alpha, 0, 0.2));
                }
                else 
                {
                	rightStamina.setAlpha(lerp(rightStamina.alpha, 1, 0.2));
                }
            }
        }
    }
    
    function updateCountdown()
    {
        var scale = countDownScale;
        var content = countDownContent;
        
        with(ui)
    	{
            toStartTimer.setScale(scale, scale);
            toStartTimer.setContent(string(content));
        }
    }
    
    function updateWhoIsChasing()
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

//--- logic States

function setupLogicStates()
{
    logicOnce = true;
    
    freeState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            uiState = changeState(true, uiState, UIfreeState);
        }
        
        if (isEveryoneReady())
        {
            start();
        }
    }
    
    readyState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            countDownScale = 5;
            countDownContent = "Ready?";
            
            uiState = changeState(true, uiState, UIreadyState);
        }
        
        if (isEveryoneReady())
        {
            start();
        }
    }
    
    countdownState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            countDownScale = 5;
            countDownContent = 3;
            
            uiState = changeState(true, uiState, UIcountdownState);
        }
        
        if (countdownLogic())
        {
            logicOnce = true;
            logicState = changeState(true, logicState, gameState);
        }
    }
    
    gameState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            uiState = changeState(true, uiState, UIgameState);
        }
        
        updateGameTime();
    }
    
    //--- logic functions

    function isEveryoneReady()
    {
        for(var i = 0; i < array_length(players); i++)
        {
            if (!players[i].instance.isReady)
            {
                return false;
            }
        }
        
        return true;
    }
    
    function startStop()
	{
        if (logicState == freeState)
        {
            start();
        }
        else 
        {
        	stop();
        }
    }
    
    function start()
    {
        logicOnce = true;
        logicState = changeState(true, logicState, countdownState);
        
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
        
        whoIsChasingTagPosition[0] = players[0].instance.x;
        whoIsChasingTagPosition[1] = players[0].instance.y;
    }
    
    function stop()
    {
        logicOnce = true;
        logicState = changeState(true, freeState, countdownState);
    
        whoIsChasingTagPosition[0] = players[0].instance.x;
        whoIsChasingTagPosition[1] = players[0].instance.y;
    }
    
    function reset()
    {
        scr_clearLog();
        
        chaseTime = maximumChaseTime;
    
        if (isGravitationOn)
        {
            isGravitationOn = !isGravitationOn;
            scr_gravitationChange();
        }
        
        instance_activate_object(o_start);
        
        with(o_char)
        {
            reset();
        }
        
        with(o_cameraTarget)
        {
            reset();
        }
        
        if (instance_exists(o_debugController))
        {
            o_debugController.previousTab = -1;
        }
        
        scr_vignetteReset();
    }
    
    function countdownLogic()
    {
        countDownScale = lerp(countDownScale, 0, 0.075);
            
        if (countDownScale <= 0.1)
        {
            countDownScale = 5;

            if (countDownContent <= 1)
            {
                countDownScale = 0;
                uiState();
                return true;
            }
            else 
            {
                countDownContent--;
            }
        }
        
        return false;
    }
    	
    function updateGameTime()
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
            isGravitationOn = !isGravitationOn;
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
            advanceToNextRound();
        }
    }
    
    function advanceToNextRound()
    {
        rounds++;
        
        logicOnce = true;
        logicState = changeState(true, logicState, countdownState);
        
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
                
                stop();
            }
        }
        else
        {		
            log(string("Round {0}/16", rounds));
        }
        
    }
    
    function caught()
	{
		log(string("Player {0} CAUGHT!", whoIsChasing), players[whoIsChasing].instance.color);
		
		whoIsChasingTagPosition[0] = players[whoIsChasing].instance.x;
		whoIsChasingTagPosition[1] = players[whoIsChasing].instance.y;
		
		whoIsChasing = !whoIsChasing;
		playerWasCaught = true;
	
		reset();
        advanceToNextRound();
	}
}
