ledPatternsAmount = 0;

// This map takes a form of Map<Map<Array<instanceId>, offset>, pattern>
// It groups led panels firstly based on the pattern and then based on the offset.
ledPanelsMap = ds_map_create();

offsetsArray = []