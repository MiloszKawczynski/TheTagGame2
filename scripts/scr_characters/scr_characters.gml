function character(_name, _codeName, _art, _miniArt, _color, _active, _pasive) constructor 
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
   
    var adamPasive = new pasiveSkills();
    adam = new character("Adam", "adam", sVN_adam, 1, global.c_runnersUp, sprint, adamPasive);
    
    var rileyPasive = new pasiveSkills();
    riley = new character("Riley", "adam", sVN_riley, 1, global.c_runnersUp, drift, rileyPasive);
    
    var miriamPasive = new pasiveSkills();
    miriam = new character("Miriam", "adam", sVN_miriam, 1, global.c_gravitieri, sprint, miriamPasive);
    
    var tricksterPasive = new pasiveSkills();
    tricksterPasive.wallJump = true;
    trickster = new character("Trickster", "adam", sVN_trickster, 3, global.c_chaosCrew, drift, tricksterPasive);
    
    var davidPasive = new pasiveSkills();
    david = new character("David", "clea", sVN_david, 2, global.c_runnersUp, sprint, davidPasive);
    
    var featherPasive = new pasiveSkills();
    feather = new character("Feather", "clea", sVN_feather, 2, global.c_gravitieri, float, featherPasive);
    
    var snowWhitePasive = new pasiveSkills();
    snowWhite = new character("Snow White", "clea", sVN_snowWhite, 2, global.c_gravitieri, dash, snowWhitePasive);
    
    var karenPasive = new pasiveSkills();
    karen = new character("Karen", "clea", sVN_karen, 2, global.c_theRunners, dash, karenPasive);
    
    var cleaPasive = new pasiveSkills();
    clea = new character("Clea", "clea", sVN_clea, 2, global.c_gravitieri, sprint, cleaPasive);
    
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