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
        updateStamina();
    }
    
    UIPointState = function()
    {
        updateBar();
        updateStamina();
        updateFullBodyPortrait();
    }
    
    UIWinState = function()
    {
        updateWinScreen();
    }
    
    UITransitionEndState = function()
    {
        updateTransitionScreen();
    }
    
    //--- UI update functions

    function updateBar()
    {
        with(ui)
    	{
            roundNumber.setContent(string("Round {0}/16", other.rounds + 1));
            leftPoints.setContent(string(other.players[0].points));
            roundTimer.setValue(other.chaseTime / other.maximumChaseTime);
            
            chaseBarPointsPocketLeft.setColor(o_gameManager.players[0].instance.color);
            chaseBarPointsPocketRight.setColor(o_gameManager.players[1].instance.color);
            
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
        
        if (whoIsChasingStage >= 2)
        {
            with(ui)
    	    {
                toStartTimer.setScale(scale, scale);
                toStartTimer.setContent(string(content));
            }
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
                
                whoIsChasingTagPosition[0] = lerp(whoIsChasingTagPosition[0], instTo.x, 0.2);
                whoIsChasingTagPosition[1] = lerp(whoIsChasingTagPosition[1], instTo.y, 0.2);
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
                    breathTimer = 1;
                    
                    whoIsChasingTagScale = 0;
                    part_type_color1(imChasingType, instTo.color);
                    part_emitter_region(imChasingSystem, 0, instTo.x - 16, instTo.x + 16, instTo.y - 16, instTo.y + 16, ps_shape_rectangle, ps_distr_linear);
                    part_emitter_burst(imChasingSystem, 0, imChasingType, 32);
                }
                
                break;
            }
            
            case(2):
            {
                breathTimer = armez_timer(breathTimer, -0.02, 0);
                
                if (breathTimer == 0)
                {
                    whoIsChasingStage = 3;
                }
                
                break;
            }
        }
    }

    function updateFullBodyPortrait()
    {
        var hide = false;
        
        if (breathTimer < 0.2)
        {
            hide = true;
        }
        
        with(ui)
    	{
            leftFullBodyPortrait.posInGridX = lerp(leftFullBodyPortrait.posInGridX, 0 + lerp(-4, 2, other.whoIsChasing * !hide), 0.1);
            rightFullBodyPortrait.posInGridX = lerp(rightFullBodyPortrait.posInGridX, 10 + lerp(4, -2, !other.whoIsChasing * !hide), 0.1);
        }
    }
    
    function updateWinScreen()
    {
        var hide = false;
        
        with(ui)
    	{
            with(winingScreenBlack)
            {
                alpha = lerp(alpha, 1, 0.05);
            }
            
            with(winingScreenCover)
            {
                setPositionInGrid(lerp(posInGridX, 5, 0.2), 5);
            }
            
            with(winingScreenTriangles)
            {
                setPositionInGrid(lerp(posInGridX, 5, 0.2), 5);
            }
            
            if (other.whoIsWinner == 0)
            {
                leftFullBodyPortrait.posInGridX = lerp(leftFullBodyPortrait.posInGridX, 2, 0.1);
            }
            else 
            {
            	rightFullBodyPortrait.posInGridX = lerp(rightFullBodyPortrait.posInGridX, 8, 0.1);
            }
            
            winningScreenWinner.posInGridY = lerp(winningScreenWinner.posInGridY, 4, 0.2);
            winningScreenPlayer.posInGridY = lerp(winningScreenPlayer.posInGridY, 5.05, 0.15);
            winningScreenName.posInGridY = lerp(winningScreenName.posInGridY, 6, 0.1);
        }
    }
    
    function updateTransitionScreen()
    {
        var hide = true;
        
        with(ui)
    	{
            with(winingScreenBlack)
            {
                color = merge_color(color, global.c_darkBlue, 0.1);
            }
            
            with(winingScreenCover)
            {
                setPositionInGrid(lerp(posInGridX, 5 + 10 * lerp(-1, 1, o_gameManager.whoIsWinner), 0.2), 5);
            }
            
            with(winingScreenTriangles)
            {
                setPositionInGrid(lerp(posInGridX, 5 + 10 * lerp(1, -1, o_gameManager.whoIsWinner), 0.2), 5);
            }
            
            if (other.whoIsWinner == 0)
            {
                leftFullBodyPortrait.posInGridX = lerp(leftFullBodyPortrait.posInGridX, 0 + lerp(-4, 2, other.whoIsChasing * !hide), 0.1);
            }
            else 
            {
            	rightFullBodyPortrait.posInGridX = lerp(rightFullBodyPortrait.posInGridX, 10 + lerp(4, -2, !other.whoIsChasing * !hide), 0.1);
            }
            
            winningScreenWinner.posInGridY = lerp(winningScreenWinner.posInGridY, 15, 0.2);
            winningScreenPlayer.posInGridY = lerp(winningScreenPlayer.posInGridY, 15, 0.15);
            winningScreenName.posInGridY = lerp(winningScreenName.posInGridY, 15, 0.1);
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
    
    breathState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            uiState = changeState(true, uiState, UIbreathState);
            
            scr_vignetteReset();
            vignettePulse = true;
            shockScale = 4;
        }
        
        shockScale = lerp(shockScale, 0, 0.25);
        
        if (vignettePulse)
        {
            scr_vignettePlayerPulse(6, players[!whoIsChasing].instance.vignetteID);
        }
        else 
        {
        	scr_vignettePullBack();
        }
        
        o_cameraTarget.cameraMarginFactor = 1;
        
        if (whoIsChasingStage == 3)
        {
            o_cameraTarget.cameraMarginFactor = o_cameraTarget.gameCameraMarginFactor;
            reset();
            advanceToNextRound();
        }
    }
    
    pointState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            uiState = changeState(true, uiState, UIPointState);
            
            scr_vignetteReset();
            vignettePulse = true;
            
            breathTimer = 1;
            
            audio_play_sound(global.characters[players[!whoIsChasing].instance.characterID].winAudio[choose(0, 1, 2)], 0, false);
            audio_play_sound(choose(sn_evade1, sn_evade2, sn_evade3), 0, false);
        }
        
        Camera.Zoom = 1;
        
        if (vignettePulse)
        {
            scr_vignettePlayerPulse(12, players[!whoIsChasing].instance.vignetteID);
        }
        else 
        {
            if (breathTimer < 0.2)
            {
        	    scr_vignettePullBack();
            }
        }
        
        breathTimer = armez_timer(breathTimer, -0.007, 0);
        
        if (breathTimer == 0)
        {
            reset();
            advanceToNextRound();
        }
    }
    
    winState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            with(ui)
        	{
                with(winingScreenCover)
                {
                    setPositionInGrid(5 + 10 * lerp(-1, 1, o_gameManager.whoIsWinner), 5);
                    setScale(lerp(-0.42, 0.42, o_gameManager.whoIsWinner), 0.42);
                    setColor(o_gameManager.players[o_gameManager.whoIsWinner].instance.color);
                }
                
                with(winingScreenTriangles)
                {
                    setPositionInGrid(5 + 10 * lerp(1, -1, o_gameManager.whoIsWinner), 5);
                    setScale(lerp(-0.42, 0.42, o_gameManager.whoIsWinner), 0.42);
                    setColor(o_gameManager.players[o_gameManager.whoIsWinner].instance.color);
                }
                
                winningScreenWinner.setPositionInGrid(5 + lerp(1.5, -1.5, o_gameManager.whoIsWinner), -5);
                winningScreenPlayer.setPositionInGrid(5 + lerp(1.5, -1.5, o_gameManager.whoIsWinner), -5);
                winningScreenName.setPositionInGrid(5 + lerp(1.5, -1.5, o_gameManager.whoIsWinner), -5);
                
                winningScreenPlayer.setContent(string("gracz {0} jako", o_gameManager.whoIsWinner + 1));
                winningScreenName.setContent(global.characters[o_gameManager.players[o_gameManager.whoIsWinner].instance.characterID].name);
            }
            
            uiState = changeState(true, uiState, UIWinState);
        }
        
        if (input_check_long_pressed("jumpKey", 0) or input_check_long_pressed("jumpKey", 1))
        {
            logicOnce = true;
            logicState = changeState(true, logicState, transitionEndState);
        }
    }
    
    transitionEndState = function()
    {
        if (logicOnce)
        {
            logicOnce = false;
            
            uiState = changeState(true, uiState, UITransitionEndState);
            
            transitionTimer = 0;
        }
        
        transitionTimer = armez_timer(transitionTimer, 0.05)
        
        if (transitionTimer == 1)
        {
            application_surface_enable(true);
            application_surface_draw_enable(true);
            room_goto(r_characterSelection);
        }
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
        audio_play_sound(mus_mainTheme, 0, true, 1, audio_sound_get_track_position(mus_menuTheme));
        audio_stop_sound(mus_menuTheme);
        
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
        audio_stop_sound(mus_mainTheme);
        
        logicOnce = true;
        logicState = changeState(true, logicState, freeState);
    
        whoIsChasingTagPosition[0] = players[0].instance.x;
        whoIsChasingTagPosition[1] = players[0].instance.y;
        
        with(ui)
        {
            winingScreenBlack.setPositionInGrid(5, 5);
            winingScreenBlack.setAlpha(0);
            winingScreenBlack.setColor(c_black);
            winingScreenCover.setPositionInGrid(-6, 5);
            winingScreenTriangles.setPositionInGrid(-6, 5);
        
            leftFullBodyPortrait.setPositionInGrid(-2, 5);
		    rightFullBodyPortrait.setPositionInGrid(12, 5);
            
            winningScreenWinner.setPositionInGrid(-3.5, 4);
            winningScreenPlayer.setPositionInGrid(-3.5, 5);
            winningScreenName.setPositionInGrid(-3.5, 6);
        }
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
        if (whoIsChasingStage < 2)
        {
            return false;
        }
        
        if (countDownScale == 5 and countDownContent == 3)
        {
            audio_play_sound(sn_counter, 0, false);
        }
        
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
            
            var winnerColor = merge_color(players[whoIsChasing].instance.color, players[!whoIsChasing].instance.color, 0.5);
            
            if (players[!whoIsChasing].points > players[whoIsChasing].points)
            {
                winnerColor = players[!whoIsChasing].instance.color;
            }
            else if (players[!whoIsChasing].points < players[whoIsChasing].points)
            {
                winnerColor = players[whoIsChasing].instance.color;
            }
            
            with(o_ledPanel)
            {
                setColorTo(winnerColor);
            }
                    
            logicOnce = true;
            logicState = changeState(true, logicState, pointState);
        }
    }
    
    function advanceToNextRound()
    {
        rounds++;
        
        if (rounds > numberOfRounds)
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
                
                whoIsWinner = indexOfWinner;
                
                //stop();
                
                logicOnce = true;
                logicState = changeState(true, logicState, winState);
                
                return;
            }
        }
        else
        {		
            log(string("Round {0}/16", rounds));
        }
        
        logicOnce = true;
        logicState = changeState(true, logicState, countdownState);
    }
    
    function caught()
	{
        audio_play_sound(choose(sn_catch1, sn_catch2, sn_catch3), 0, false);
        
        with(players[!whoIsChasing].instance)
        {
            topDownAnimationState = changeAnimationState(true, topDownAnimationState, topDownTripState);
            platformAnimationState = changeAnimationState(true, platformAnimationState, platformTripState);
        }
        
        with(players[whoIsChasing].instance)
        {
            topDownAnimationState = changeAnimationState(true, topDownAnimationState, topDownJoyState);
            platformAnimationState = changeAnimationState(true, platformAnimationState, platformJoyState);
        }
        
        var instTo = players[!whoIsChasing].instance;
        part_type_color1(imChasingType, players[!whoIsChasing].instance.color);
        part_emitter_region(imChasingSystem, 0, instTo.x - 16, instTo.x + 16, instTo.y - 16, instTo.y + 16, ps_shape_rectangle, ps_distr_linear);
        part_emitter_burst(imChasingSystem, 0, imChasingType, 32);
        part_emitter_burst(imChasingSystem, 0, iChatchedType, 32);
        
		log(string("Player {0} CAUGHT!", whoIsChasing), players[whoIsChasing].instance.color);
		
		whoIsChasingTagPosition[0] = players[whoIsChasing].instance.x;
		whoIsChasingTagPosition[1] = players[whoIsChasing].instance.y;
        
		whoIsChasing = !whoIsChasing;
		playerWasCaught = true;
	
        logicOnce = true;
        logicState = changeState(true, logicState, breathState);
	}
}
