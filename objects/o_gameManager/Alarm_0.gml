scr_bake();

if (global.createStaticBuffers)
{
	with(o_collision)
	{	
		if (model != undefined)
		{
			fauxton_model_destroy(model);
		}
	}
	
	if (global.saveStaticBuffers) 
	{
		var arr = scr_getFiles("buffers/" + global.gameLevelName, ".sav");
		
		for(var i = 0; i < array_length(arr); i++)
		{
			scr_fileDelete(get_project_path() + "content/buffers/" + arr[i]);
		}
	}
	
	log("DONE!");
}

whoIsChasingTagPosition[0] = players[whoIsChasing].instance.x;
whoIsChasingTagPosition[1] = players[whoIsChasing].instance.y;