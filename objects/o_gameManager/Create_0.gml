event_inherited();

setActiveSkills();
setPasiveSkills();

setGameRulesValues();
setGameRulesFunctions();

setPlayersDefaultMovementRules();

createUI();

cullx1 = 0;
cullx2 = 0;
cully1 = 0;
cully2 = 0;

alarm[0] = 3;

buffersMap = ds_map_create();

scr_gravitationChange();