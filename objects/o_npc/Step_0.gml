if (distance_to_object(o_char) < range and keyboard_check_pressed(vk_enter) and !o_debugController.dialog.isSpeaking)
{
	with(o_debugController)
	{
		scr_dialogLoad(other.myDialog);
	
		var text = ds_list_find_value(allDialogNodes, startNodeIndex).getAllText(gameLanguage);
		var people = ds_list_find_value(allDialogNodes, startNodeIndex).getAllTalkers();
	
		dialog.init(text, people);
	}
}

if (o_debugController.dialog != undefined)
{
	o_debugController.dialog.logic();
}