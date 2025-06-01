function character(_name, _art, _miniArt, _color, _active, _pasive) constructor 
{
    name = _name;
    art = _art;
    miniArt = _miniArt;
    color = _color;
    active = _active;
    pasive = _pasive;
    vignetteID = array_find_index(global.c_teamColors, function(c) { return c == color; });
}

function scr_createCharacters()
{
    setActiveSkills();
    
    enum characterTypes
	{
		adam,
		riley,
		trickster,
        clea,
	}
   
    var adamPasive = new pasiveSkills();
    adam = new character("Adam", sVN_adam, 1, global.c_runnersUp, sprint, adamPasive);
    
    var rileyPasive = new pasiveSkills();
    riley = new character("Riley", sVN_adam, 1, global.c_runnersUp, drift, rileyPasive);
    
    var tricksterPasive = new pasiveSkills();
    tricksterPasive.wallJump = true;
    trickster = new character("Trickster", sVN_trickster, 3, global.c_chaosCrew, drift, tricksterPasive);
    
    var cleaPasive = new pasiveSkills();
    clea = new character("Clea", sVN_clea, 2, global.c_gravitieri, sprint, cleaPasive);
    
    global.characters = array_create();
    array_push(global.characters, adam, riley, trickster, clea);
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