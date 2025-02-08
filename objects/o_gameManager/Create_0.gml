event_inherited();

createUI();

setActiveSkills();

setGameRulesValues();
setGameRulesFunctions();

setPlayersDefaultMovementRules();

//---

vignetteTime = 0;
vignettePulse = false;
pulseCounter = 0;

//---

x1 = 0;
x2 = 0;
y1 = 0;
y2 = 0;

alarm[0] = 3;

buffersMap = ds_map_create();

whoIsChasing = 0;
playerWasCaught = false;
isChasingTagTimer = 0;
whoIsChasingTagPosition = [0, 0, 0];
whoIsChasingTagScale = 1;
whoIsChasingStage = 0;

imChasingSystem = part_system_copy(ps_imChasing, 0);
imChasingType = part_type_copy(ps_imChasing, 0);
part_emitter_type(imChasingSystem, 0, imChasingType);