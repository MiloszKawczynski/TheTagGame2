function character(_name, _codeName, _art, _miniArt, _color, _active, _pasive, _stats) constructor 
{
    name = _name;
    codeName = _codeName;
    art = _art;
    miniArt = _miniArt;
    color = _color;
    active = _active;
    pasive = _pasive;
    vignetteID = array_find_index(global.c_teamColors, function(c) { return c == color; });
    
    
    idleAnimation = asset_get_index(string("s_{0}Idle", codeName));
    
    walkAnimation = asset_get_index(string("s_{0}Walk", codeName));
    runAnimation = asset_get_index(string("s_{0}Run", codeName));
    sprintAnimation = asset_get_index(string("s_{0}Sprint", codeName));
    
    jumpAnimation = asset_get_index(string("s_{0}Jump", codeName));
    
    fallAnimation = asset_get_index(string("s_{0}Fall", codeName));
    
    leapAnimation = asset_get_index(string("s_{0}Leap", codeName));
    
    parkourAnimation = asset_get_index(string("s_{0}Parkour", codeName));
    
    vaultAnimation = asset_get_index(string("s_{0}Vault", codeName));
    
    tripAnimation = asset_get_index(string("s_{0}Trip", codeName));
    
    stats = _stats;
}

function scr_setupStatsModificators(characterReference)
{
    maximumDefaultSpeedModificator = characterReference.stats.maximumDefaultSpeedModificator;
    accelerationModificator = characterReference.stats.accelerationModificator;
    decelerationModificator = characterReference.stats.decelerationModificator;
    maximumSpeedDecelerationFactorModificator = characterReference.stats.maximumSpeedDecelerationFactorModificator;
    jumpForceModificator = characterReference.stats.jumpForceModificator;
    maxJumpNumberModificator = characterReference.stats.maxJumpNumberModificator;
    momentumJumpForceModificator = characterReference.stats.momentumJumpForceModificator;
    gravitationModificator = characterReference.stats.gravitationModificator;
    slopeAccelerationModificator = characterReference.stats.slopeAccelerationModificator;
    slopeDecelerationModificator = characterReference.stats.slopeDecelerationModificator;
    slopeMinSpeedModificator = characterReference.stats.slopeMinSpeedModificator;
    rampAccelerationModificator = characterReference.stats.rampAccelerationModificator;
    rampDecelerationModificator = characterReference.stats.rampDecelerationModificator;
    rampMinSpeedModificator = characterReference.stats.rampMinSpeedModificator;
    slopeSpeedTransitionFactorModificator = characterReference.stats.slopeSpeedTransitionFactorModificator;
    maximumCoyoteTimeModificator = characterReference.stats.maximumCoyoteTimeModificator;
    obstacleRangeModificator = characterReference.stats.obstacleRangeModificator;
    catchRangeModificator = characterReference.stats.catchRangeModificator;
    maximumObstacleJumpForceModificator = characterReference.stats.maximumObstacleJumpForceModificator;
    minimumObstacleJumpForceModificator = characterReference.stats.minimumObstacleJumpForceModificator;
    maximumJumpBufforModificator = characterReference.stats.maximumJumpBufforModificator;
    skillUsageModificator = characterReference.stats.skillUsageModificator;
	skillReplenishModificator = characterReference.stats.skillReplenishModificator;
	skillValueModificator = characterReference.stats.skillValueModificator;
}


function scr_createCharacters()
{
    setActiveSkills();
    
    enum characterTypes
	{
		adam,
		riley,
        miriam,
		trickster,
        david,
        feather,
        snowWhite,
        karen,
        clea,
	}
    
    var emptyPasive = new pasiveSkills();
    var emptyStats = new statsModificators();
   
    //--- ADAM ---
    
    var adamPasive = new pasiveSkills();
    var adamStats = new statsModificators();
    adamStats.accelerationModificator = 1;
    adam = new character("Adam", "adam", sVN_adam, 1, global.c_runnersUp, sprint, adamPasive, adamStats);
    
    //--- RILEY ---
    
    var rileyPasive = new pasiveSkills();
    riley = new character("Riley", "adam", sVN_riley, 1, global.c_runnersUp, drift, rileyPasive, emptyStats);
    
    //--- MIRIAM ---
    
    var miriamPasive = new pasiveSkills();
    miriam = new character("Miriam", "adam", sVN_miriam, 1, global.c_gravitieri, sprint, miriamPasive, emptyStats);
    
    //--- TRICKSTER ---
    
    var tricksterPasive = new pasiveSkills();
    tricksterPasive.wallJump = true;
    trickster = new character("Trickster", "adam", sVN_trickster, 3, global.c_chaosCrew, drift, tricksterPasive, emptyStats);
    
    //--- DAVID ---
    
    var davidPasive = new pasiveSkills();
    david = new character("David", "clea", sVN_david, 2, global.c_runnersUp, sprint, davidPasive, emptyStats);
    
    //--- FEATHER ---
    
    var featherPasive = new pasiveSkills();
    feather = new character("Feather", "clea", sVN_feather, 2, global.c_gravitieri, float, featherPasive, emptyStats);
    
    //--- SNOW WHITE ---
    
    var snowWhitePasive = new pasiveSkills();
    snowWhite = new character("Snow White", "clea", sVN_snowWhite, 2, global.c_gravitieri, dash, snowWhitePasive, emptyStats);
    
    //--- KARENN ---
    
    var karenPasive = new pasiveSkills();
    karen = new character("Karen", "clea", sVN_karen, 2, global.c_theRunners, dash, karenPasive, emptyStats);
    
    //--- CLEA ---
    
    var cleaPasive = new pasiveSkills();
    clea = new character("Clea", "clea", sVN_clea, 2, global.c_gravitieri, sprint, cleaPasive, emptyStats);
    
    //-----------
    
    global.characters = array_create();
    array_push(global.characters, adam, riley, miriam, trickster, david, snowWhite, karen, clea);
}

function setActiveSkills()
{
	enum skillTypes
	{
		sprint,
		dash,
		//gravityManipulation,
        //teleport,
        float,
        drift
	}
	
	global.skills = [];
	
	sprint = new activeSkill("sprint", skillTypes.sprint, 0.01, 0.01, 0.33, 0);
	dash = new activeSkill("dash", skillTypes.dash, 1, 0.005, 2, 1);
	//gravityManipulation = new activeSkill("gravity manipulation", skillTypes.float, 0.01, 0.01, 1, 1);
    //teleport = new activeSkill("teleport", skillTypes.dash, 1, 0.005, 20, 1);
    float = new activeSkill("float", skillTypes.float, 0.02, 0.005, 5, 0.33);
    drift = new activeSkill("drift", skillTypes.drift, 0.03, 0.1, 10, 0.33);
	
	array_push(global.skills, sprint, dash, float, drift);
}

	
function activeSkill(_name, _type, _usage, _replenish, _value, _rechargePercentage) constructor
{
    name = _name;
    type = _type;
    usage = _usage;
    replenish = _replenish;
    value = _value;
    rechargePercentage = _rechargePercentage;
}

function pasiveSkills() constructor
{
    wallJump = false;
    alwaysPerfectVault = false;
    noUpHillPenalty = false;
    airDash = false;
    autoCatch = false;
}

function statsModificators() constructor
{
    maximumDefaultSpeedModificator = 1;
    accelerationModificator = 1;
    decelerationModificator = 1;
    maximumSpeedDecelerationFactorModificator = 1;
    jumpForceModificator = 1;
    maxJumpNumberModificator = 1;
    momentumJumpForceModificator = 1;
    gravitationModificator = 1;
    slopeAccelerationModificator = 1;
    slopeDecelerationModificator = 1;
    slopeMinSpeedModificator = 1;
    rampAccelerationModificator = 1;
    rampDecelerationModificator = 1;
    rampMinSpeedModificator = 1;
    slopeSpeedTransitionFactorModificator = 1;
    maximumCoyoteTimeModificator = 1;
    obstacleRangeModificator = 1;
    catchRangeModificator = 1;
    maximumObstacleJumpForceModificator = 1;
    minimumObstacleJumpForceModificator = 1;
    maximumJumpBufforModificator = 1;
    
    skillUsageModificator = 1;
	skillReplenishModificator = 1;
	skillValueModificator = 1;
}