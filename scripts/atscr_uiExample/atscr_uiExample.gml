function scr_p5Button(points, seed = 0)
{
	for(var i = 0; i < array_length(points); i++)
	{
		if (i mod 2 == 0)
		{
			points[i] += posX - width / 2;
			points[i] += sin(time + (i * 3 / array_length(points)) + seed) * 0.5;
		}
		else
		{
			points[i] += posY - height / 2;
			points[i] += sin(time + (i * 5 / array_length(points)) + seed) * -0.5;
		}
	}
			
	draw_primitive_begin(pr_trianglestrip);
			
	for(var i = 0; i < array_length(points); i+=2)
	{	
		draw_vertex(points[i], points[i + 1]);
	}
	
	draw_primitive_end();
}

function scr_sonic06Radio(points, seed = 0)
{			
	draw_primitive_begin(pr_trianglestrip);
			
	for(var i = 0; i < array_length(points); i+=2)
	{	
		points[i] += posX - width / 2;
		points[i + 1] += posY - height / 2;
		
		var _alpha = 1;
		
		if (i = array_length(points) - 2)
		{
			_alpha = 0;
		}
		
		if (i = array_length(points) - 4)
		{
			_alpha = 0;
		}
		
		if (i = array_length(points) - 6)
		{
			_alpha = 0.75;
		}
		
		if (i = array_length(points) - 8)
		{
			_alpha = 0.75;
		}
		
		draw_vertex_color(points[i], points[i + 1], c_navy, _alpha);
	}
	
	draw_primitive_end();
}

function scr_sonic06Arrow(points, _x = 0, seed = 0, color = c_black)
{			
	draw_primitive_begin(pr_trianglestrip);
			
	for(var i = 0; i < array_length(points); i+=2)
	{	
		points[i] += posX - width / 2 + _x;
		points[i + 1] += posY - height / 2;
		
		draw_vertex_color(points[i], points[i + 1], color, 1);
	}
	
	draw_primitive_end();
}