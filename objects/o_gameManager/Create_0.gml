event_inherited();

setGameRulesValues();

setPlayersDefaultMovementRules();

createUI();

setupUIStates();
setupLogicStates();

uiState = UIfreeState;

if (global.lockOnStart)
{
    logicState = readyState;
}
else 
{
    logicState = freeState;
}


cullx1 = 0;
cullx2 = 0;
cully1 = 0;
cully2 = 0;

alarm[0] = 3;

buffersMap = ds_map_create();

scr_gravitationChange();
