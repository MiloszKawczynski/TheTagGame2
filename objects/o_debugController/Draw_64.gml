ui.draw();

if (!dialogOverImGui)
{
	if (dialog != undefined and dialog.isSpeaking)
	{
		dialog.draw(
		dialogPosition[0],
		dialogPosition[1],
		dialogSize[0],
		dialogSize[1],
		dialogTextPosition[0],
		dialogTextPosition[1],
		dialogPortraitPosition[0],
		dialogPortraitPosition[1],
		dialogPortraitSpacing,
		dialogPortraitScale)
	
		dialog.drawDebug(dialogPosition[0], dialogPosition[1], dialogTextPosition[0], dialogTextPosition[1]);
	}	
}

ImGui.__Render();
ImGui.__Draw();

if (dialogOverImGui)
{
	if (dialog != undefined and dialog.isSpeaking)
	{
		dialog.draw(
		dialogPosition[0],
		dialogPosition[1],
		dialogSize[0],
		dialogSize[1],
		dialogTextPosition[0],
		dialogTextPosition[1],
		dialogPortraitPosition[0],
		dialogPortraitPosition[1],
		dialogPortraitSpacing,
		dialogPortraitScale)
	
		dialog.drawDebug(dialogPosition[0], dialogPosition[1], dialogTextPosition[0], dialogTextPosition[1]);
	}	
}