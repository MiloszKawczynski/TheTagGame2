randomize();

function UI() constructor
{	
	//Fields
	
	ui = self;
	
	width = camera_get_view_width(view_camera[0]);
	height = camera_get_view_height(view_camera[0]);
	
	layers = ds_stack_create();

	//Public Methods +
	
	static pushLayer = function(_layer)
	{
		var topLayer = ds_stack_top(layers);
		
		if (topLayer != undefined)
		{
			topLayer.setActiveStatus(false);
			_layer.layerUnder = topLayer;
		}
			
		ds_stack_push(layers, _layer);
	}
	
	static popLayer = function()
	{
		var topLayer = ds_stack_top(layers);
		
		delete topLayer;
		ds_stack_pop(layers);
		
		if (ds_stack_size(layers) != 0)
		{
			ds_stack_top(layers).setActiveStatus(true);
		}
	}
	
	static step = function()
	{
		if (ds_stack_size(layers) != 0)
		{
			ds_stack_top(layers).step();
		}
	}
	
	static draw = function()
	{
		if (ds_stack_size(layers) != 0)
		{
			ds_stack_top(layers).draw();
		}
	}
	
	//Private Methods -
	
	static getMainGroup = function()
	{
		if (ds_stack_size(layers) != 0)
		{
			return ds_stack_top(layers).group;
		}
		return undefined;
	}

	display_set_gui_size(width, height);
	
	//Organization
	
	function Layer() constructor
	{
		//Fields
		
		isActive = true;
		layerUnder = undefined;
		
		width = other.width;
		height = other.height;
	
		group = new other.Group();
		
		//Public Methods +
		
		static setGrid = function(_horizontalGrid, _verticalGrid, _showGrid = false)
		{
			group.setGrid(_horizontalGrid, _verticalGrid, _showGrid)
		}
	
		static addComponent = function(_x, _y, _component)
		{
			group.addComponent(_x, _y, _component)
		}
		
		//Private Methods -
		
		static step = function()
		{
			if (layerUnder != undefined)
			{
				layerUnder.step();
			}
		
			group.step();
		}
	
		static draw = function()
		{
			if (layerUnder != undefined)
			{
				layerUnder.draw();
			}
		
			group.draw();
		}
		
		static setActiveStatus = function(_isActive)
		{
			isActive = _isActive;
		
			group.setActiveStatus(_isActive);
		}
			
		with(group)
		{
			grid = new Grid(posX, posY, width, height, 1, 1);
		}
	}
	
	function Group(_x = 0, _y = 0) constructor
	{
		//Fields
		
		name = "Group";
		containerImIn = undefined;
		
		posInGridX = 0;
		posInGridY = 0;
		
		shiftX = _x;
		shiftY = _y;
		
		scrollX = 0;
		scrollY = 0;
		
		grabX = 0;
		grabY = 0;
		
		posX = _x;
		posY = _y;
		
		isActive = true;
		
		width = other.width;
		height = other.height;
		
		components = ds_list_create();
	
		grid = undefined;
		showGrid = false;
		
		//Public Methods +
		
		static setPositionInGrid = function(_x = posInGridX, _y = posInGridY)
		{
			posInGridX = _x;
			posInGridY = _y;
			
			updatePosition();
			
			grid.setPosition(posX, posY);
		}
		
		static setShift = function(_x = shiftX, _y = shiftY)
		{
			shiftX = _x;
			shiftY = _y;
			
			updatePosition();
			
			grid.setPosition(posX, posY);
		}
		
		static setGrid = function(_horizontalGrid, _verticalGrid, _showGrid = false)
		{
			if (grid == undefined)
			{
				grid = new Grid(posX, posY, width, height, _horizontalGrid, _verticalGrid);
			}
			else
			{
				grid.setGridSize(_horizontalGrid, _verticalGrid);
			}
		
			showGrid = _showGrid;
		}
		
		static addComponent = function(_x, _y, _component)
		{
			_component.containerImIn = self;
			
			ds_list_add(components, _component);
			
			_component.posInGridX = _x;
			_component.posInGridY = _y;
			
			_component.posX = _component.shiftX + _component.posInGridX * grid.horizontalGridSize;
			_component.posY = _component.shiftY + _component.posInGridY * grid.verticalGridSize;
			_component.isActive = isActive;
			
			if (is_instanceof(_component, other.ui.Group))
			{
				_component.grid.setPosition(_component.posX, _component.posY);
				_component.grid.setUISize(grid.horizontalGridSize, grid.verticalGridSize);
			}
			
			_component.update();
		}
		
		static setProperties = function(_scaleX = undefined, _scaleY = undefined, _rotation = undefined, _color = undefined, _alpha = undefined)
		{
			var numberOfComponents = ds_list_size(components);
			for(var i = 0; i < numberOfComponents; i++)
			{
				var component = ds_list_find_value(components, i);
				
				if (is_instanceof(component, other.ui.Group))
				{	
					component.updateProperties(_scaleX, _scaleY, _rotation, _color, _alpha);
				}
				else
				{
					component.setScale(_scaleX, _scaleY);
					component.setRotation(_rotation);
					component.setColor(_color);
					component.setAlpha(_alpha);
				}
			}
		}
		
		//Private Methods -
		
		static setScroll = function(_x = scrollX, _y = scrollY)
		{
			scrollX = _x;
			scrollY = _y;
			
			updatePosition();
			
			grid.setPosition(posX, posY);
		}
		
		static setGrab = function(_x = grabX, _y = grabY)
		{
			grabX = _x;
			grabY = _y;
			
			updatePosition();
			
			grid.setPosition(posX, posY);
		}
		
		static updatePosition = function()
		{
			if (containerImIn != undefined)
			{
				posX = containerImIn.posX + shiftX + scrollX + grabX + posInGridX * containerImIn.grid.horizontalGridSize;
				posY = containerImIn.posY + shiftY + scrollY + grabY + posInGridY * containerImIn.grid.verticalGridSize;
			}
			else
			{
				posX = shiftX + scrollX + grabX + posInGridX;
				posY = shiftY + scrollY + grabY + posInGridY;
			}
		}
	
		static step = function()
		{
			var numberOfComponents = ds_list_size(components);
			for(var i = 0; i < ds_list_size(components); i++)
			{
				if (!is_instanceof(ds_list_find_value(components, i), other.ui.Group))
				{
					ds_list_find_value(components, i).superStep();
				}
				ds_list_find_value(components, i).step();
			}
		}
		
		static draw = function()
		{
			var numberOfComponents = ds_list_size(components);
			for(var i = 0; i < numberOfComponents; i++)
			{
				ds_list_find_value(components, i).draw();
			}
		
			if (showGrid)
			{
				grid.draw();
			}
		}
		
		static setActiveStatus = function(_isActive)
		{
			var numberOfComponents = ds_list_size(components);
			for(var i = 0; i < numberOfComponents; i++)
			{
				ds_list_find_value(components, i).setActiveStatus(_isActive);
			}
		}
		
		static update = function()
		{			
			if (containerImIn != undefined)
			{
				updatePosition();
				isActive = containerImIn.isActive;
			}
			
			var numberOfComponents = ds_list_size(components);
			for(var i = 0; i < numberOfComponents; i++)
			{
				ds_list_find_value(components, i).update();
			}
		}
		
		function Grid(_x, _y, _width, _height, _horizontalGrid, _verticalGrid) constructor
		{
			//Fields
			
			posX = _x;
			posY = _y;
			
			width = _width;
			height = _height;
	
			horizontalGrid = _horizontalGrid;
			verticalGrid = _verticalGrid;
		
			horizontalGridSize = width / _horizontalGrid;
			verticalGridSize = height / _verticalGrid;
			
			//Private Methods -
			
			static setPosition = function(_x, _y)
			{
				posX = _x;
				posY = _y;
			}
	
			static setGridSize = function(_horizontalGrid, _verticalGrid)
			{
				horizontalGrid = _horizontalGrid;
				verticalGrid = _verticalGrid;
		
				horizontalGridSize = width / _horizontalGrid;
				verticalGridSize = height / _verticalGrid;
			}
			
			static setUISize = function(_width, _height)
			{
				width = _width;
				height = _height;
		
				horizontalGridSize = width / horizontalGrid;
				verticalGridSize = height / verticalGrid;
			}
	
			static draw = function()
			{
				draw_set_color(c_black);
				for(var h = 0; h < horizontalGrid; h++)
				{
					var lineX = h * horizontalGridSize;
					draw_line(posX + lineX, posY, posX + lineX, posY + height);
				}
		
				for(var v = 0; v < verticalGrid; v++)
				{
					var lineY = v * verticalGridSize;
					draw_line(posX, posY + lineY, posX + width, posY + lineY);
				}
			}
		}
	}
	
	//Basic
	
	function Component(_x = 0, _y = 0) constructor
	{
		//Fields
		
		ui = other.ui;
			
		name = "Component";
		containerImIn = undefined;
		
		posInGridX = 0;
		posInGridY = 0;
		
		shiftX = _x;
		shiftY = _y;
		
		posX = _x;
		posY = _y;
		
		scaleX = 1;
		scaleY = 1;
		
		rotation = 0;
		
		color = c_white;
		
		alpha = 1;
		
		isActive = true;
		
		width = 0;
		height = 0;
		
		//Public Methods +
		
		static setPositionInGrid = function(_x = posInGridX, _y = posInGridY)
		{
			posInGridX = _x;
			posInGridY = _y;
			
			if (containerImIn != undefined)
			{
				containerImIn.update();
			}
		}
		
		static setShift = function(_x = shiftX, _y = shiftY)
		{
			shiftX = _x;
			shiftY = _y;
			
			if (containerImIn != undefined)
			{
				containerImIn.update();
			}
		}
		
		static setScale = function(_scaleX = scaleX, _scaleY = scaleY)
		{
			if (_scaleX != undefined)
			{
				scaleX = _scaleX;
			}
			
			if (_scaleY != undefined)
			{
				scaleY = _scaleY;
			}
		}
		
		static setRotation = function(_rotation)
		{
			if (_rotation != undefined)
			{
				rotation = _rotation;
			}
		}
		
		static setColor = function(_color)
		{
			if (_color != undefined)
			{
				color = _color;
			}
		}
		
		static setAlpha = function(_alpha)
		{
			if (_alpha != undefined)
			{
				alpha = _alpha;
			}
		}
		
		static setSize = function(_width = width, _height = height)
		{
			width = _width;
			height = _height;
		}
		
		//Private Methods -
		
		static superStep = function() 
		{

		}
		
		static step = function()
		{
			
		}
	
		static superDraw = function() 
		{
			
		}
		
		static draw = function()
		{
			superDraw();
		}

		static update = function()
		{					
			posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
			posY = containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize;
			isActive = containerImIn.isActive;
		}	
	}
	
	function Input(_x = 0, _y = 0) : Component(_x, _y) constructor
	{
		//Fields
		
		hover = false;
		press = false;
		click = false;
		focus = false;
		
		normalState = new ui.State(self);
		hoverState = new ui.State(self);
		pressState = new ui.State(self);
		focusState = new ui.State(self);
		
		//Public Methods +
		
		static setSpriteSheet = function(_sprite)
		{
			normalState.setSpriteSheet(_sprite, 0);
			hoverState.setSpriteSheet(_sprite, 1);
			pressState.setSpriteSheet(_sprite, 2);
			focusState.setSpriteSheet(_sprite, 3);
			
			width = sprite_get_width(_sprite);
			height = sprite_get_height(_sprite);
		}
		
		static setSprites = function(_spriteNormal, _spriteHover = _spriteNormal, _spritePress = _spriteNormal, _spriteFocus = _spriteNormal)
		{
			normalState.setSprite(_spriteNormal);
			hoverState.setSprite(_spriteHover);
			pressState.setSprite(_spritePress);
			focusState.setSprite(_spriteFocus);
			
			width = sprite_get_width(_spriteNormal);
			height = sprite_get_height(_spriteNormal);
		}
		
		static setDrawFunctions = function(_normal, _hover = _normal, _press = _normal, _focus = _normal, _width = width, _height = height)
		{			
			normalState.draw = _normal;
			hoverState.draw = _hover;
			pressState.draw = _press;
			focusState.draw  = _focus;
			
			width = _width;
			height = _height;
			
			draw = function () {superDraw();};
		}
		
		//Private Methods -
		
		static isHover = function()
		{
			return (device_mouse_x_to_gui(0) > posX - width / 2
			and device_mouse_x_to_gui(0) < posX + width / 2
			and device_mouse_y_to_gui(0) > posY - height / 2
			and device_mouse_y_to_gui(0) < posY + height / 2);
		}
		
		static isClick = function()
		{
			return mouse_check_button(mb_left)
		}
		
		static isPressed = function()
		{
			return mouse_check_button_pressed(mb_left)
		}
		
		static isReleased = function()
		{
			return mouse_check_button_released(mb_left)
		}
		
		static superStep = function() 
		{
			if (isActive)
			{
				hover = isHover();
				if (click) {click = false;}
			
				if (hover)
				{
					if (isPressed())
					{
						press = true;
					}
					
					if (isReleased())
					{
						focus = true;
					}
				}
				else
				{
					press = false;
					
					if (isPressed())
					{
						focus = false;
					}
				}
				
				if (isReleased())
				{
					if (press)
					{
						click = true;
						press = false;
					}					
				}
			}
			else
			{
				hover = false;
				press = false;
				click = false;
				focus = false;
			}
		}
	
		static superDraw = function() 
		{
			if (hover)
			{
				if (press)
				{
					pressState.draw();
				}
				else
				{
					hoverState.draw();
				}
			}
			else
			{
				if (focus)
				{
					focusState.draw();
				}
				else
				{
					normalState.draw();
				}
			}
		}
	}
	
	function Output(_x = 0, _y = 0) : Component(_x, _y) constructor
	{
		//Fields
		
		state = new ui.State(self);
	
		//Public Methods +
		
		static setSprite = function(_sprite)
		{
			state.setSprite(_sprite);
			
			width = sprite_get_width(_sprite);
			height = sprite_get_height(_sprite);
		}
		
		static setDrawFunction = function(_state, _width = width, _height= height)
		{			
			state.draw = _state;
			
			width = _width;
			height = _height;
		}
		
		//Private Methods -
	
		static superDraw = function() 
		{
			state.draw();
		}
	}
	
	function State(_component) constructor
	{
		//Fields
		
		component = _component;
		
		sprite = undefined;
		subimg = 0;
		
		draw = function() {};
		
		time = 0;
		
		//Private Methods -
		
		static updateTimer = function(_sprite = sprite)
		{
			time = timer(time, sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps), sprite_get_number(_sprite));
			return time;
		}
		
		static setSpriteSheet = function(_sprite, _subimg)
		{
			sprite = _sprite;
			subimg = _subimg;

			draw = function()
			{
				draw_sprite_ext(sprite, subimg, component.posX, component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
			}
		}
			
		static setSprite = function(_sprite)
		{
			sprite = _sprite;
			
			draw = function()
			{
				draw_sprite_ext(sprite, time, component.posX, component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				updateTimer(sprite);
			}
		}
	}
	
	function MultipleState(_component) : State(_component) constructor
	{
		//Fields
		
		sprite = ds_list_create();
		
		time = ds_list_create();
		
		isTimerForSpriteUpdated = ds_list_create();
		
		//Private Methods -
		
		static resetTimerFlags = function()
		{
			for(var i = 0; i < ds_list_size(isTimerForSpriteUpdated); i++)
			{
				ds_list_set(isTimerForSpriteUpdated, i, false);
			}
		}
		
		static updateTimer = function(_number, _sprite = sprite)
		{
			if (!ds_list_find_value(isTimerForSpriteUpdated, _number))
			{
				ds_list_set(isTimerForSpriteUpdated, _number, true);
				var spriteTmp = ds_list_find_value(_sprite, _number);
				var timeTmp = ds_list_find_value(time, _number);
				timeTmp = timer(timeTmp, sprite_get_speed(spriteTmp) / game_get_speed(gamespeed_fps), sprite_get_number(spriteTmp));
				ds_list_set(time, _number, timeTmp);
				return timeTmp;
			}
			else
			{
				var timeTmp = ds_list_find_value(time, _number);
				return timeTmp;
			}
		}
		
		static setSpriteSheet = function(_subimg)
		{
			subimg = _subimg;
			
			draw = function(_number)
			{
				draw_sprite_ext(ds_list_find_value(sprite, _number), subimg, component.posX, component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
			}
		}
		
		static setSprite = function()
		{
			draw = function(_number)
			{
				draw_sprite_ext(ds_list_find_value(sprite, _number), ds_list_find_value(time, _number), component.posX, component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				updateTimer(_number);
			}
		}
		
		static addSprite = function(_sprite)
		{
			ds_list_add(sprite, _sprite);
			ds_list_add(time, 0);
			ds_list_add(isTimerForSpriteUpdated, false);
		}
	}
	
	//Input
		
	function Button(_onClick, _x = 0, _y = 0) : Input(_x, _y) constructor
	{		
		//Fields
		
		name = "Button";
		
		onClick = _onClick;
		
		//Private Methods -
		
		static step = function()
		{
			if (click)
			{
				onClick(); 
			}
		}
	}
	
	function Checkbox(_onClick, _isCheckOnStart = false, _x = 0, _y = 0) : Input(_x, _y) constructor
	{	
		//Fields
		
		name = "Checkbox";
		
		onClick = _onClick;
		isChecked = _isCheckOnStart;
		
		normalState = new ui.MultipleState(self);
		hoverState = new ui.MultipleState(self);
		pressState = new ui.MultipleState(self);
		focusState = new ui.MultipleState(self);
		
		//Public Methods +
		
		static setSpriteSheet = function(_spriteUncheck, _spriteCheck)
		{
			normalState.setSpriteSheet(0);
			hoverState.setSpriteSheet(1);
			pressState.setSpriteSheet(2);
			focusState.setSpriteSheet(3);
			
			normalState.addSprite(_spriteUncheck);
			normalState.addSprite(_spriteCheck);
			
			hoverState.addSprite(_spriteUncheck);
			hoverState.addSprite(_spriteCheck);
			
			pressState.addSprite(_spriteUncheck);
			pressState.addSprite(_spriteCheck);
			
			focusState.addSprite(_spriteUncheck);
			focusState.addSprite(_spriteCheck);
			
			width = sprite_get_width(_spriteUncheck);
			height = sprite_get_height(_spriteUncheck);
		}
		
		static setSprites = function(_spriteNormal, _spriteCheckNormal, _spriteHover = _spriteNormal, _spriteCheckHover = _spriteCheckNormal, _spritePress = _spriteNormal, _spriteCheckPress = _spriteCheckNormal, _spriteFocus = _spriteNormal, _spriteCheckFocus = _spriteCheckNormal)
		{
			normalState.setSprite();
			hoverState.setSprite();
			pressState.setSprite();
			focusState.setSprite();
			
			normalState.addSprite(_spriteNormal);
			normalState.addSprite(_spriteCheckNormal);
			
			hoverState.addSprite(_spriteHover);
			hoverState.addSprite(_spriteCheckHover);
			
			pressState.addSprite(_spritePress);
			pressState.addSprite(_spriteCheckPress);
			
			focusState.addSprite(_spriteFocus);
			focusState.addSprite(_spriteCheckFocus);
			
			width = sprite_get_width(_spriteNormal);
			height = sprite_get_height(_spriteNormal);
		}
		
		//Private Methods -
		
		static step = function()
		{
			if (click)
			{
				isChecked = !isChecked;
						
				onClick(isChecked);
			}
		}
		
		static superDraw = function() 
		{
			if (hover)
			{
				if (press)
				{
					pressState.draw(isChecked);
				}
				else
				{
					hoverState.draw(isChecked);
				}
			}
			else
			{
				if (focus)
				{
					focusState.draw(isChecked);
				}
				else
				{
					normalState.draw(isChecked);
				}
			}
			
			normalState.resetTimerFlags();
			hoverState.resetTimerFlags();
			focusState.resetTimerFlags();
			pressState.resetTimerFlags();
		}
	}
	
	function Slider(_onSlide, _startValue = 0, _x = 0, _y = 0) : Input(_x, _y) constructor
	{
		//Fields
		
		name = "Slider";
		
		onSlide = _onSlide;
		value = _startValue;
		
		slider = new ui.Output();
		
		left = 0;
		right = 0;
		
		//Public Methods +
		
		static setSpriteSheet = function(_spriteSlider, _spriteDot)
		{	
			normalState.setSpriteSheet(_spriteDot, 0);
			hoverState.setSpriteSheet(_spriteDot, 1);
			pressState.setSpriteSheet(_spriteDot, 2);
			focusState.setSpriteSheet(_spriteDot, 3);
			slider.setSprite(_spriteSlider);
			
			with(normalState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);;
				}
			}
			
			with(hoverState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(pressState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(focusState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			width = sprite_get_width(_spriteSlider);
			height = sprite_get_height(_spriteSlider);
		}
		
		static setSprites = function(_spriteSlider, _spriteNormal, _spriteHover = _spriteNormal, _spritePress = _spritePress, _spriteFocus = _spriteFocus)
		{			
			normalState.setSprite(_spriteNormal);
			hoverState.setSprite(_spriteHover);
			pressState.setSprite(_spritePress);
			focusState.setSprite(_spriteFocus);
			slider.setSprite(_spriteSlider);
			
			with(normalState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
					updateTimer(sprite);
				}
			}
			
			with(hoverState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
					updateTimer(sprite);
				}
			}
			
			with(pressState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
					updateTimer(sprite);
				}
			}
			
			with(focusState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX - component.width / 2 + component.left + ((component.width - (component.left + component.right)) * component.value), component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
					updateTimer(sprite);
				}
			}
			
			width = sprite_get_width(_spriteSlider);
			height = sprite_get_height(_spriteSlider);
		}
		
		static setDrawFunctions = function(_slider, _normal, _hover = _normal, _press = _normal, _focus = _normal, _width = width, _height = height)
		{			
			slider.state.draw = _slider;
			
			normalState.draw = _normal;
			hoverState.draw = _hover;
			pressState.draw = _press;
			focusState.draw  = _focus;
			
			width = _width;
			height = _height;
		}
		
		static setMargin = function(_left = left, _right = right)
		{
			left = _left;
			right = _right;
		}
		
		//Private Methods -
		
		static superStep = function() 
		{
			if (isActive)
			{
				hover = isHover();
				if (click) {click = false;}
			
				if (hover)
				{
					if (isPressed())
					{
						press = true;
					}
					
					if (isReleased())
					{
						focus = true;
					}
				}
				else
				{
					if (isPressed())
					{
						focus = false;
					}
				}
				
				if (isReleased())
				{
					if (press)
					{
						click = true;
						press = false;
					}					
				}
			}
			else
			{
				hover = false;
				press = false;
				click = false;
				focus = false;
			}
		}
		
		static step = function()
		{
			if (press)
			{
				value = clamp((device_mouse_x_to_gui(0) - (posX - ((width / 2) - left))) / (width - (left + right)), 0, 1);
					
				onSlide(value);
			}
		}
		
		static draw = function() 
		{
			slider.superDraw();
			superDraw();
		}
		
		static update = function()
		{					
			posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
			posY = containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize;
			isActive = containerImIn.isActive;
			
			with(slider)
			{
				posX = other.posX + shiftX;
				posY = other.posY + shiftY;
				isActive = other.isActive;
			}
		}	
	}
	
	function Radio(_onClick, _options, _horizontalDisplacement, _verticalDisplacement, _wichIsCheckOnStart = 0, _x = 0, _y = 0) : Input(_x, _y) constructor
	{
		//Fields
		
		name = "Radio";
		
		onClick = _onClick;
		
		wichIsHover = -1;
		wichIsClick = -1;
		wichIsPress = -1;
		wichIsFocus = -1;
		
		wichIsChecked = _wichIsCheckOnStart;
		
		options = _options;
		
		horizontalDisplacement = _horizontalDisplacement;
		verticalDisplacement = _verticalDisplacement;
		
		isDrawTextEnable = false;
		isReturnTextEnable = false;
		
		normalState = new ui.MultipleState(self);
		hoverState = new ui.MultipleState(self);
		pressState = new ui.MultipleState(self);
		focusState = new ui.MultipleState(self);
		
		texts = ds_list_create();
		
		//Public Methods +
		
		static setSpriteSheet = function(_spriteUncheck, _spriteCheck)
		{
			normalState.setSpriteSheet(0);
			hoverState.setSpriteSheet(1);
			pressState.setSpriteSheet(2);
			focusState.setSpriteSheet(3);
			
			normalState.addSprite(_spriteUncheck);
			normalState.addSprite(_spriteCheck);
			
			hoverState.addSprite(_spriteUncheck);
			hoverState.addSprite(_spriteCheck);
			
			pressState.addSprite(_spriteUncheck);
			pressState.addSprite(_spriteCheck);
			
			focusState.addSprite(_spriteUncheck);
			focusState.addSprite(_spriteCheck);
			
			width = sprite_get_width(_spriteUncheck);
			height = sprite_get_height(_spriteUncheck);
		}
		
		static setSprites = function(_spriteNormal, _spriteCheckNormal, _spriteHover = _spriteNormal, _spriteCheckHover = _spriteCheckNormal, _spritePress = _spriteNormal, _spriteCheckPress = _spriteCheckNormal, _spriteFocus = _spriteNormal, _spriteCheckFocus = _spriteCheckNormal)
		{
			normalState.setSprite();
			hoverState.setSprite();
			pressState.setSprite();
			focusState.setSprite();
			
			normalState.addSprite(_spriteNormal);
			normalState.addSprite(_spriteCheckNormal);
			
			hoverState.addSprite(_spriteHover);
			hoverState.addSprite(_spriteCheckHover);
			
			pressState.addSprite(_spritePress);
			pressState.addSprite(_spriteCheckPress);
			
			focusState.addSprite(_spriteFocus);
			focusState.addSprite(_spriteCheckFocus);
			
			width = sprite_get_width(_spriteNormal);
			height = sprite_get_height(_spriteNormal);
		}
		
		static setDrawText = function(_font, _horizontalAlign = fa_center, _verticalAlign = fa_middle, _x = 0, _y = 0)
		{
			var _posX = posX;
			var _posY = posY;
			
			for(var i = 0; i < array_length(options); i++)
			{
				posX = (i * horizontalDisplacement);
				posY = (i * verticalDisplacement);
			
				ds_list_add(texts, new ui.Text(options[i], _font, _horizontalAlign, _verticalAlign, posX + _x, posY + _y));
				
			}
			
			posX = _posX;
			posY = _posY;
			
			isDrawTextEnable = true;
		}
		
		static setReturnText = function()
		{
			isReturnTextEnable = true;
		}
		
		//Private Methods -
		
		static superStep = function() 
		{
			if (isActive)
			{
				var _posX = posX;
				var _posY = posY;
				
				var isAnyHover = false;
				var isAnyPress = false;
				var isAnyFocus = false;
				
				if (wichIsClick != -1) 
				{
					wichIsClick = -1;
				}
				
				for(var i = 0; i < array_length(options); i++)
				{
					posX = _posX + (i * horizontalDisplacement);
					posY = _posY + (i * verticalDisplacement);
					
					if (isHover())
					{
						isAnyHover = true;
						wichIsHover = i;
					}
					else
					{
						if (!isAnyHover)
						{
							wichIsHover = -1;
						}
					}
					
					if (wichIsHover == i)
					{
						if (isPressed())
						{
							isAnyPress = true;
							wichIsPress = i;
						}
					
						if (isReleased())
						{
							isAnyFocus = true;
							wichIsFocus = i;
						}
					}
					else
					{					
						if (isPressed())
						{
							if (!isAnyFocus)
							{
								wichIsFocus = -1;
							}
						}
					}
				
					if (isReleased())
					{
						if (wichIsPress != -1)
						{
							wichIsClick = wichIsPress;
							
							if (!isAnyPress)
							{
								wichIsPress = -1;
							}
						}					
					}
				}
				
				posX = _posX;
				posY = _posY;
			}
			else
			{
				wichIsHover = -1;
				wichIsClick = -1;
				wichIsPress = -1;
				wichIsFocus = -1;
			}
		}
		
		static step = function()
		{
			if (wichIsClick != -1)
			{
				wichIsChecked = wichIsClick;
				if (isReturnTextEnable)
				{
					onClick(options[wichIsClick]);
				}
				else
				{
					onClick(wichIsClick);
				}
			}
		}
		
		static superDraw = function()
		{
			var _posX = posX;
			var _posY = posY;
			
			for(var i = 0; i < array_length(options); i++)
			{
				posX = _posX + (i * horizontalDisplacement);
				posY = _posY + (i * verticalDisplacement);
				
				if (wichIsHover == i)
				{
					if (wichIsPress == i)
					{
						pressState.draw(wichIsChecked == i);
					}
					else
					{
						hoverState.draw(wichIsChecked == i);
					}
				}
				else
				{
					if (wichIsFocus == i)
					{
						focusState.draw(wichIsChecked == i);
					}
					else
					{
						normalState.draw(wichIsChecked == i);
					}
				}
				
				if (isDrawTextEnable)
				{
					ds_list_find_value(texts, i).superDraw();
				}
			}
			
			posX = _posX;
			posY = _posY;
			
			normalState.resetTimerFlags();
			hoverState.resetTimerFlags();
			focusState.resetTimerFlags();
			pressState.resetTimerFlags();
		}
		
		static update = function()
		{					
			posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
			posY = containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize;
			isActive = containerImIn.isActive;
			
			for(var i = 0; i < ds_list_size(texts); i++)
			{
				with(ds_list_find_value(texts, i))
				{
					posX = other.posX + shiftX;
					posY = other.posY + shiftY;
					isActive = other.isActive;
				}
			}
		}	
	}
	
	function InputText(_onType, _maxCharacters, _defaulContent = "", _x = 0, _y = 0) : Input(_x, _y) constructor
	{
		//Fields
		
		name = "InputText";
		
		onType = _onType;
		
		text = new ui.Text(_defaulContent, atf_font);
		text.setColor(c_black);
		
		content = _defaulContent;
		
		maxCharacters = _maxCharacters;
		ignoreCharacters = undefined;
		acceptableCharacters = undefined;
		
		//Public Methods +
				
		static setIgnoreCharacters = function(_char)
		{
			ignoreCharacters = _char;
			acceptableCharacters = undefined;
		}
		
		static setAcceptableCharacters = function(_char)
		{
			acceptableCharacters = _char;
			ignoreCharacters = undefined;
		}
		
		//Private Methods -
		
		static step = function()
		{
			if (isPressed())
			{
				keyboard_lastchar = "";
				keyboard_lastkey = vk_nokey;
			}
			
			if (focus)
			{
				if (keyboard_lastkey == vk_backspace)
				{
					content = string_copy(content, 0, string_length(content) - 1);
				}
				else
				{
					if (keyboard_lastkey != vk_enter and string_length(content) < maxCharacters)
					{
						var isCharGood = true;
							
						if (acceptableCharacters != undefined)
						{
							isCharGood = false;
							for(var i = 0; i < array_length(acceptableCharacters); i++)
							{
								if (acceptableCharacters[i] == keyboard_lastchar)
								{
									isCharGood = true;
									break;
								}
							}
						}
							
						if (ignoreCharacters != undefined)
						{
							for(var i = 0; i < array_length(ignoreCharacters); i++)
							{
								if (ignoreCharacters[i] == keyboard_lastchar)
								{
									isCharGood = false;
									break;
								}
							}
						}
							
						if (isCharGood)
						{
							content += keyboard_lastchar;
						}
					}
				}
					
				if (keyboard_lastkey!= vk_nokey)
				{
					onType(content);
				}
				keyboard_lastchar = "";
				keyboard_lastkey = vk_nokey;
				text.setContent(content);
			}
		}
		
		static draw = function()
		{
			superDraw();
			text.superDraw();
		}
		
		static update = function()
		{					
			posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
			posY = containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize;
			isActive = containerImIn.isActive;
			
			with(text)
			{
				posX = other.posX + shiftX;
				posY = other.posY + shiftY;
				isActive = other.isActive;
			}
		}	
	}
	
	function DragAndDrop(_onClick, _onDrop = _onClick, _x = 0, _y = 0) : Input(_x, _y) constructor
	{		
		//Fields
		
		name = "DragAndDrop";
		
		onClick = _onClick;
		onDrop = _onDrop;
		
		lastPosX = posX - shiftX;
		lastPosY = posY - shiftY;
		
		//Private Functions -
		
		static superStep = function() 
		{
			if (isActive)
			{
				hover = isHover();
				if (click) {click = false;}
			
				if (hover)
				{
					if (isPressed())
					{
						press = true;
					}
					
					if (isReleased())
					{
						focus = true;
					}
				}
				else
				{
					if (isPressed())
					{
						focus = false;
					}
				}
				
				if (isReleased())
				{
					if (press)
					{
						click = true;
						press = false;
					}					
				}
			}
			else
			{
				hover = false;
				press = false;
				click = false;
				focus = false;
			}
		}

		static step = function()
		{
			if (hover)
			{
				if (isPressed())
				{
					lastPosX = posX - shiftX;
					lastPosY = posY - shiftY;
					
					onClick(posX, posY);
				}
			}
			
			if (press)
			{
				shiftX = device_mouse_x_to_gui(0) - lastPosX;
				shiftY = device_mouse_y_to_gui(0) - lastPosY;
				
				ui.getMainGroup().update();
			}	
			
			if (isReleased())
			{
				if (click)
				{
					onDrop(posX, posY);
				}
			}
		}
	}
	
	function Scroll(_maxValue, _scrollStep, _group = undefined, _x = 0, _y = 0) : Input(_x, _y) constructor
	{
		//Fields
		
		name = "Scroll";
		
		value = 0;
		maxValue = _maxValue;
		scrollStep = _scrollStep;
		group = _group;
		isPinned = true;
		isSmooth = false;
		
		top = 0;
		bottom = 0;
		
		lastScroll = value;
		nextScroll = value;
		scrollTime = 0;
		
		curve = undefined;
		
		scroll = new ui.Output();
		
		//Public Methods +
		
		static setSpriteSheet = function(_spriteScroll, _dotSprite)
		{
			normalState.setSpriteSheet(_dotSprite, 0, draw);
			hoverState.setSpriteSheet(_dotSprite, 1, draw);
			pressState.setSpriteSheet(_dotSprite, 2, draw);
			focusState.setSpriteSheet(_dotSprite, 3, draw);
			scroll.setSprite(_spriteScroll);

			with(normalState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(hoverState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(pressState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(focusState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, subimg, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
		
			width = sprite_get_width(_spriteScroll);
			height = sprite_get_height(_spriteScroll);
		}
		
		static setSprites = function(_spriteScroll, _spriteNormal, _spriteHover = _spriteNormal, _spritePress = _spriteNormal, _spriteFocus = _spriteNormal)
		{
			normalState.setSprite(_spriteNormal);
			hoverState.setSprite(_spriteHover);
			pressState.setSprite(_spritePress);
			focusState.setSprite(_spriteFocus);
			scroll.setSprite(_spriteScroll);
			
			with(normalState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			with(hoverState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
						
			with(pressState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
						
			with(focusState)
			{
				draw = function()
				{
					draw_sprite_ext(sprite, time, component.posX, component.posY - component.height / 2 + component.top + ((component.height - (component.top + component.bottom)) * component.value / component.maxValue), component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
						
			width = sprite_get_width(_spriteScroll);
			height = sprite_get_height(_spriteScroll);
		}
		
		static setDrawFunctions = function(_scroll, _normal, _hover = _normal, _press = _normal, _focus = _normal, _width = width, _height = height)
		{			
			scroll.state.draw = _scroll;
			
			normalState.draw = _normal;
			hoverState.draw = _hover;
			pressState.draw = _press;
			focusState.draw  = _focus;
			
			width = _width;
			height = _height;
		}
		
		static setMargin = function(_top = top, _bottom = bottom)
		{
			top = _top;
			bottom = _bottom;
		}
		
		static unpin = function()
		{
			isPinned = false;
		}
		
		static setSmooth = function(_curve)
		{
			isSmooth = true;
			curve = _curve;
		}
		
		//Private Methods -
		
		static superStep = function() 
		{
			if (isActive)
			{
				hover = isHover();
				if (click) {click = false;}
			
				if (hover)
				{
					if (isPressed())
					{
						press = true;
					}
					
					if (isReleased())
					{
						focus = true;
					}
				}
				else
				{
					if (isPressed())
					{
						focus = false;
					}
				}
				
				if (isReleased())
				{
					if (press)
					{
						click = true;
						press = false;
					}					
				}
			}
			else
			{
				hover = false;
				press = false;
				click = false;
				focus = false;
			}
		}
		
		static step = function()
		{
			if (isActive)
			{
				if (mouse_wheel_down() or mouse_wheel_up())
				{
					if (isSmooth)
					{
						lastScroll = value;
						scrollTime=0;
						
						nextScroll += (mouse_wheel_down() - mouse_wheel_up()) * scrollStep;
						nextScroll = clamp(nextScroll, 0, maxValue);
					}
					else
					{
						value += (mouse_wheel_down() - mouse_wheel_up()) * scrollStep;
						value = clamp(value, 0, maxValue);
						
						updateScroll();
					}
				}
				else
				{
					if (isSmooth)
					{
						if (value != nextScroll)
						{
							value = lerp(lastScroll, nextScroll, animcurve_get_point(curve, 0, scrollTime))
						
							updateScroll();
						
							if scrollTime >= 1
							{
								lastScroll = value;
								nextScroll = value;
							
								scrollTime = 0;
							}
							else
							{
								scrollTime += 0.01;
							}
						}
					}
				}
			}
			
			if (press)
			{				
				value = clamp(maxValue * (device_mouse_y_to_gui(0) - (posY - height / 2) - top) / (height - (top + bottom)), 0, maxValue);
				lastScroll = value;
				nextScroll = value;
				
				updateScroll();
			}
		}
		
		static draw = function() 
		{
			scroll.superDraw();
			superDraw()
		}
		
		static update = function()
		{	
			isActive = containerImIn.isActive;
			
			if (isPinned)
			{
				posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
				posY = (containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize) + value;
			}
			else
			{
				posX = containerImIn.posX + shiftX + posInGridX * containerImIn.grid.horizontalGridSize;
				posY = containerImIn.posY + shiftY + posInGridY * containerImIn.grid.verticalGridSize;
			}
								
			with(scroll)
			{
				posX = other.posX + shiftX;
				posY = other.posY + shiftY;
				isActive = other.isActive;
			}
		}
		
		static updateScroll = function()
		{
			var groupTemp = group;
			
			if (groupTemp == undefined)
			{
				groupTemp = ui.getMainGroup();
			}
			
			with(groupTemp)
			{
				setScroll(, -other.value);
				update();
			}
		}
	}
	
	function Grab(_isGrabbed = undefined, _group = undefined) : Input() constructor
	{
		//Fields
		
		name = "Grab";
		
		if (_isGrabbed == undefined)
		{
			isGrabbed = function() {return mouse_check_button(mb_right);}
		}
		else
		{
			isGrabbed = _isGrabbed;
		}
		
		group = _group;
		
		movedX = 0;
		movedY = 0;
		
		lastPosX = 0;
		lastPosY = 0;
		
		//Private Methods -
		
		static superStep = function() 
		{
			if (isActive)
			{
				if (isGrabbed())
				{
					if (press)
					{
						hover = false;
					}
					else
					{
						hover = true;
						press = true;
					}
				}
				else
				{
					hover = false;
					
					if (press)
					{
						press = false;
					}
				}
			}
			else
			{
				hover = false;
				press = false;
				click = false;
				focus = false;
			}
		}

		static step = function()
		{
			if (hover)
			{
				lastPosX = device_mouse_x_to_gui(0) - movedX;
				lastPosY = device_mouse_y_to_gui(0) - movedY;
			}
			
			if (press)
			{
				movedX = device_mouse_x_to_gui(0) - lastPosX;
				movedY = device_mouse_y_to_gui(0) - lastPosY;
				
				updateGrab();
			}	
		}
		
		static updateGrab = function()
		{
			var groupTemp = group;
			
			if (groupTemp == undefined)
			{
				groupTemp = ui.getMainGroup();
			}
			
			with(groupTemp)
			{
				setGrab(other.movedX, other.movedY);
				update();
			}
		}
	}
	
	//Output
	
	function Text(_content, _font, _horizontalAlign = fa_center, _verticalAlign = fa_middle, _x = 0, _y = 0) : Output(_x, _y) constructor
	{
		//Fields
		
		content = _content;
		contentList = ds_list_create();
		
		font = _font;
		horizontalAlign = _horizontalAlign;
		verticalAlign = _verticalAlign;
		
		isSpacingEnable = false;
		spaceX = 0;
		spaceY = 0;
		
		draw = function() 
		{
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_set_font(font);
			draw_set_halign(horizontalAlign);
			draw_set_valign(verticalAlign);
			
			if (!isSpacingEnable)
			{
				draw_text_transformed(posX, posY, content, scaleX, scaleY, rotation);
			}
			else
			{
				for(var i = 0; i < ds_list_size(contentList); i++)
				{
					draw_text_transformed(posX + (spaceX * i), posY + (spaceY * i), ds_list_find_value(contentList, i), scaleX, scaleY, rotation);
				}
			}
			
			draw_set_alpha(1);
		};
		
		state.draw = draw;
		
		//Public Methods +
		
		static setSpacing = function(_spaceX = spaceX, _spaceY = spaceY)
		{
			spaceX = _spaceX;
			spaceY = _spaceY;
			
			isSpacingEnable = true;
			
			for(var i = 1; i <= string_length(content); i++)
			{
				ds_list_add(contentList, string_char_at(content, i));
			}
		}
		
		static setAlign = function(_horizontalAlign = horizontalAlign, _verticalAlign = verticalAlign)
		{
			horizontalAlign = _horizontalAlign;
			verticalAlign = _verticalAlign;
		}
		
		static setContent = function(_content)
		{
			content = _content;
			
			if (isSpacingEnable)
			{
				ds_list_clear(contentList);
				for(var i = 1; i <= string_length(content); i++)
				{
					ds_list_add(contentList, string_char_at(content, i));
				}
			}
		}
	}
	
	function GradientBar(_startValue, _x = 0, _y = 0) : Output(_x, _y) constructor
	{		
		//Fields
		
		name = "GradientBar";
		
		value = _startValue;
		
		surface = undefined;
		
		//Public Methods +
		
		static setSprites = function(_spriteBackground, _spriteValue, _spriteFront)
		{
			spriteBackground = _spriteBackground;
			spriteValue = _spriteValue;
			spriteFront = _spriteFront;
			
			widthBackground = sprite_get_width(spriteBackground);
			heightBackground = sprite_get_height(spriteBackground);
			
			widthValue = sprite_get_width(spriteValue);
			heightValue = sprite_get_height(spriteValue);
			
			surface = surface_create(widthBackground, heightBackground);
			
			with(state)
			{
				draw = function()
				{
					var strech = component.scaleX * (component.widthBackground / component.widthValue) * component.value;
				
					surface_set_target(component.surface);
				
					draw_sprite_ext(component.spriteBackground, time, component.widthBackground / 2, component.heightBackground / 2, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
					gpu_set_colorwriteenable(1, 1, 1, 0);
					draw_sprite_ext(component.spriteValue, time, component.widthBackground / 2 - (component.widthBackground / 2) + (strech * component.widthValue / 2), component.heightBackground / 2, strech, component.scaleY, component.rotation, component.color, component.alpha);
					gpu_set_colorwriteenable(1, 1, 1, 1);
					draw_sprite_ext(component.spriteFront, time, component.widthBackground / 2, component.heightBackground / 2, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				
					surface_reset_target();
				
					draw_surface(component.surface, component.posX - component.widthBackground / 2, component.posY - component.heightBackground / 2);
				
					updateTimer(component.spriteValue);
				}
			}
			
			width = sprite_get_width(spriteBackground);
			height = sprite_get_height(spriteBackground);
		}
		
		static setValue = function(_value)
		{
			value = _value;
		}
	}
	
	function PointBar(_startValue, _maxValue, _horizontalDisplacement = 0, _verticalDisplacement = 0, _x = 0, _y = 0) : Output(_x, _y) constructor
	{		
		//Fields
		
		name = "PointBar";
		
		state = new ui.MultipleState(self);
		
		value = _startValue;
		maxValue = _maxValue;
		
		horizontalDisplacement = _horizontalDisplacement;
		verticalDisplacement = _verticalDisplacement;
		
		//Public Methods +
		
		static setSpriteSheet = function(_sprite)
		{		
			state.addSprite(_sprite);
			
			with(state)
			{
				draw = function(_number)
				{
					draw_sprite_ext(ds_list_find_value(sprite, 0), !_number, component.posX, component.posY, component.scaleX, component.scaleY, component.rotation, component.color, component.alpha);
				}
			}
			
			width = sprite_get_width(_sprite) * maxValue  + (maxValue - 1) * horizontalDisplacement;
			height = sprite_get_height(_sprite) * maxValue  + (maxValue - 1) * verticalDisplacement;
		}
		
		static setSprites = function(_spriteOff, _spriteOn)
		{
			state.setSprite();
			
			state.addSprite(_spriteOff);
			state.addSprite(_spriteOn);
			
			width = sprite_get_width(_spriteOn) * maxValue  + (maxValue - 1) * horizontalDisplacement;
			height = sprite_get_height(_spriteOn) * maxValue  + (maxValue - 1) * verticalDisplacement;
		}
		
		static setDrawFunctions = function(_normal, _width = width, _height = height)
		{			
			superDraw = _normal;
			
			width = _width;
			height = _height;
		}
		
		static setValue = function(_value)
		{
			value = _value;
		}
		
		//Private Methods -
		
		static superDraw = function()
		{
			var _posX = posX;
			var _posY = posY;
				
			for(var i = 0; i < maxValue; i++)
			{
				posX = _posX + (i * horizontalDisplacement);
				posY = _posY + (i * verticalDisplacement);
					
				state.draw(i < value)
			}
				
			posX = _posX;
			posY = _posY;
			
			state.resetTimerFlags();
		}
	}
	
	function LedBar(_value, _maxValue, _horizontalDisplacement = 0, _verticalDisplacement = 0, _x = 0, _y = 0) : Output(_x, _y) constructor
	{		
		name = "LedBar";
		
		onState = new ui.State(self);
		offState = new ui.State(self);
		
		value = _value;
		maxValue = _maxValue;
		
		horizontalDisplacement = _horizontalDisplacement;
		verticalDisplacement = _verticalDisplacement;
		
		static setSprites = function(_spriteOn, _spriteOff)
		{
			onState.setSprite(_spriteOn);
			offState.setSprite(_spriteOff);
			
			width = sprite_get_width(_spriteOn) * maxValue  + (maxValue - 1) * horizontalDisplacement;
			height = sprite_get_height(_spriteOn) * maxValue  + (maxValue - 1) * verticalDisplacement;
			
			drawNormal = function()
			{
				var _posX = posX;
				var _posY = posY;
				
				for(var i = 0; i < maxValue; i++)
				{
					posX = _posX + (i * horizontalDisplacement);
					posY = _posY + (i * verticalDisplacement);
					
					if (value[i] == true)
					{
						onState.draw();
					}
					else
					{
						offState.draw();
					}
				}
				
				posX = _posX;
				posY = _posY;
			}
		}
		
		static setSpriteSheet = function(_sprite)
		{
			onState.setSpriteSheet(_sprite, 0);
			offState.setSpriteSheet(_sprite, 1);
			
			width = sprite_get_width(_sprite) * maxValue  + (maxValue - 1) * horizontalDisplacement;
			height = sprite_get_height(_sprite) * maxValue  + (maxValue - 1) * verticalDisplacement;
			
			drawNormal = function()
			{
				var _posX = posX;
				var _posY = posY;
				
				for(var i = 0; i < maxValue; i++)
				{
					posX = _posX + (i * horizontalDisplacement);
					posY = _posY + (i * verticalDisplacement);
					
					if (value[i] == true)
					{
						onState.draw();
					}
					else
					{
						offState.draw();
					}
				}
				
				posX = _posX;
				posY = _posY;
			}
		}
		
		static setDrawFunctions = function(_normal)
		{			
			drawNormal = _normal;
		}
		
		static setValue = function(_value)
		{
			value = _value;
		}
		
		static draw = function()
		{
			drawNormal();
		}
	}
}