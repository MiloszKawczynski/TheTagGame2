function character(_name, _desc, _codeName, _art, _miniArt, _color, _active, _pasive, _stats) constructor 
{
    name = _name;
    desc = _desc;
    dificulty = 0;
    codeName = _codeName;
    art = _art;
    miniArt = _miniArt;
    color = _color;
    active = _active;
    pasive = _pasive;
    vignetteID = array_find_index(global.c_teamColors, function(c) { return c == color; });
    
    selectAudio = asset_get_index(string("sn_{0}Select", codeName));
    winAudio = [];
    for (var i = 1; i <= 3; i++)
    {
        array_push(winAudio, asset_get_index(string("sn_{0}Win{1}", codeName, i)));
    }
    
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
    joyAnimation = asset_get_index(string("s_{0}Joy", codeName));
    
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
    
    var adamDesc = "Umiejętność: Sprint\n\nPrzeciętny\nw każdej materii";
    
    adam = new character("Adam", adamDesc, "adam", sVN_adam, 1, global.c_adam, sprint, adamPasive, adamStats);
    adam.dificulty = [1, 0, 0];
    
    //--- RILEY ---
    
    var rileyPasive = new pasiveSkills();
    rileyPasive.airDash = true;
    
    var rileyStats = new statsModificators();
    rileyStats.slopeSpeedTransitionFactorModificator = 1.2;
    rileyStats.slopeAccelerationModificator = 1.1;
    rileyStats.rampAccelerationModificator = 1.1;
    
    var rileyDesc = "Umiejętność: Drift\n\nZbiega z górki\nszybciej niż inni\n\nW powietrzu potrafi\nwykonać air dash";
    
    riley = new character("Riley", rileyDesc, "riley", sVN_riley, 2, global.c_riley, drift, rileyPasive, rileyStats);
    riley.dificulty = [1, 1, 0];
    
    //--- MIRIAM ---
    
    var miriamPasive = new pasiveSkills();
    miriamPasive.autoCatch = true;
    miriamPasive.alwaysPerfectVault = true;
    
    var miriamStats = new statsModificators();
    miriamStats.minimumObstacleJumpForceModificator = 0.7;
    miriamStats.maximumObstacleJumpForceModificator = 0.7;
    miriamStats.obstacleRangeModificator = 0.75;
    miriamStats.catchRangeModificator = 0.2;
    
    var miriamDesc = "Umiejętność: Dash\n\nMniejszy zasięg\nłapania i wybicia\n\nŁapanie jest\nautomatyczne\n\nWybicie jest zawsze\nidealne";
    
    miriam = new character("Miriam", miriamDesc, "miriam", sVN_miriam, 3, global.c_miriam, dash, miriamPasive, miriamStats);
    miriam.dificulty = [1, 1, 0];
    
    //--- TRICKSTER ---
    
    var tricksterPasive = new pasiveSkills();
    tricksterPasive.wallJump = true;
    
    var tricksterStats = new statsModificators();
    tricksterStats.jumpForceModificator = 1.15;
    
    var tricksterDesc = "Umiejętność: Drift\n\nWyżej skacze\n\nPotrafi skakać po\nścianach";
    
    trickster = new character("Trickster", tricksterDesc, "trickster", sVN_trickster, 4, global.c_trickster, drift, tricksterPasive, tricksterStats);
    trickster.dificulty = [1, 1, 0];
    
    //--- DAVID ---
    
    var davidPasive = new pasiveSkills();
    
    var davidStats = new statsModificators();
    davidStats.maxJumpNumberModificator = 3;
    davidStats.maximumDefaultSpeedModificator = 0.5;
    
    var davidDesc = "Umiejętność: Float\n\nPotrafi trzy razy\nskoczyć\n\nWolniej biega"
    
    david = new character("David", davidDesc, "david", sVN_david, 5, global.c_david, float, davidPasive, davidStats);
    david.dificulty = [1, 1, 1];
    
    //--- FEATHER ---
    
    var featherPasive = new pasiveSkills();
    featherPasive.noUpHillPenalty = true;
    
    var featherStats = new statsModificators();
    
    var featherDesc = "Umiejętność: Float\n\nNie zwalnia biegnąc\npod górę";
    
    feather = new character("Feather", featherDesc, "feather", sVN_feather, 6, global.c_feather, float, featherPasive, featherStats);
    feather.dificulty = [1, 1, 1];
    
    //--- SNOW WHITE ---
    
    var snowWhitePasive = new pasiveSkills();
    
    var snowWhiteStats = new statsModificators();
    snowWhiteStats.obstacleRangeModificator = 1.2;
    snowWhiteStats.minimumObstacleJumpForceModificator = 0.7;
    snowWhiteStats.maximumObstacleJumpForceModificator = 1.2;
    
    var snowWhiteDesc = "Umiejętność: Dash\n\nŁapie przeszkody z\nwiększej odległości\n\nSłabe wybicia\nsą gorsze\n\nDobre wybicia\nsą lepsze"
    
    snowWhite = new character("Snow White", snowWhiteDesc, "snowWhite", sVN_snowWhite, 7, global.c_snowWhite, dash, snowWhitePasive, snowWhiteStats);
    snowWhite.dificulty = [1, 1, 0];
    
    //--- KARENN ---
    
    var karenPasive = new pasiveSkills();
    
    var karenStats = new statsModificators();
    karenStats.maximumDefaultSpeedModificator = 1.25;
    karenStats.accelerationModificator = 0.9;
    karenStats.decelerationModificator = 0.5;
    karenStats.rampAccelerationModificator = 1.2;
    karenStats.slopeAccelerationModificator = 1.2;
    karenStats.rampDecelerationModificator = 2;
    karenStats.slopeDecelerationModificator = 2;
    
    var karenDesc = "Umiejętność: Sprint\n\nDłużej się\nrozpędza i hamuje\n\nSzybciej biega\n\nGorzej wbiega\npod górę\n\nZbiega z górki\nszybciej niż inni"
    
    karen = new character("Karen", karenDesc, "karen", sVN_karen, 8, global.c_karen, sprint, karenPasive, karenStats);
    karen.dificulty = [1, 1, 0];
    
    //--- CLEA ---
    
    var cleaPasive = new pasiveSkills();
    
    var cleaStats = new statsModificators();
    cleaStats.maximumDefaultSpeedModificator = 0.5;
    cleaStats.skillUsageModificator = 0.9;
    cleaStats.skillValueModificator = 1.2;
    
    var cleaDesc = "Umiejętność: Sprint\n\nSprintuje dłużej\ni szybciej\n\nWolniej biega"
    
    clea = new character("Clea", cleaDesc, "clea", sVN_clea, 9, global.c_clea, sprint, cleaPasive, cleaStats);
    clea.dificulty = [1, 0, 0];
    
    //-----------
    
    global.characters = array_create();
    array_push(global.characters, adam, riley, miriam, trickster, david, feather, snowWhite, karen, clea);
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
	dash = new activeSkill("dash", skillTypes.dash, 1, 0.01, 2, 1);
	//gravityManipulation = new activeSkill("gravity manipulation", skillTypes.float, 0.01, 0.01, 1, 1);
    //teleport = new activeSkill("teleport", skillTypes.dash, 1, 0.005, 20, 1);
    float = new activeSkill("float", skillTypes.float, 0.015, 0.005, 5, 0.33);
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