function scr_preload()
{
	if (room == r_levelEditor or room == r_levelEditorBig)
	{
		//scr_levelLoad("metroChasev1.1");
		scr_levelLoad("basic");
	}
	scr_rulesPresetLoad("default");
	scr_statsPresetLoad("default");
	
	scr_addPlayer(0);
	scr_addPlayer(1);
	
	isBindingFinilize = true;
	firstFreePlayer = 2;
	
	//Create and Save
	switch(staticBuffersOptionType.disable)
	{
		case(staticBuffersOptionType.create):
		{
			global.createStaticBuffers = true;
			break;
		}
		
		case(staticBuffersOptionType.createAndSave):
		{
			global.createStaticBuffers = true;
			global.saveStaticBuffers = true;
			break;
		}
		
		case(staticBuffersOptionType.load):
		{
			global.loadStaticBuffers = true;
			break;
		}
		
		case(staticBuffersOptionType.disable):
		{
			break;
		}
	}
		
	o_gameManager.reset();
}