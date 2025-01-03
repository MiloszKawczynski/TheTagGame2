var randomAlpha = sin(current_time / 1000) * 0.05;
var randomWidth = sin(current_time / 950) * 0.1;
var randomRotation = sin(current_time / 2550);

var length = 1200 div 16;

var rot = -90;
var spriteRotX = image_angle;
var spriteRotY = 0;
var z = 0;

if (global.debugIsGravityOn)
{
	spriteRotX = 0;
	spriteRotY = image_angle;
	rot = 0;
	z = 32;
}

gpu_set_blendmode(bm_add);

shader_set(shd_godray);
shader_set_uniform_f(intensivityUniform, intensivity);

matrix_set(matrix_world, matrix_build(x, y, z, spriteRotX, rot, rot + spriteRotY, 1, 1, 1));

draw_sprite_ext(
	s_godRay, 
	0, 
	0, 
	0, 
	length,  
	1.5 + randomWidth, 
	0,
	c_white, 
	0.35 + randomAlpha);

matrix_reset();

matrix_set(matrix_world, matrix_build(x, y + 1, z + 1, spriteRotX, rot, rot + spriteRotY, 1, 1, 1));
	
draw_sprite_ext(
	s_godRay, 
	0, 
	5, 
	lengthdir_y(length * 16, randomRotation), 
	length * 1,  
	0.5 + randomWidth, 
	randomRotation, 
	c_white, 
	0.25 + randomAlpha);

matrix_reset();

matrix_set(matrix_world, matrix_build(x, y + 2, z + 2, spriteRotX, rot, rot + spriteRotY, 1, 1, 1));

draw_sprite_ext(
	s_godRay, 
	0, 
	-15, 
	lengthdir_y(length * 16, -randomRotation), 
	length * 1,  
	0.5 - randomWidth, 
	-randomRotation, 
	c_white, 
	0.25 - randomAlpha);
	
matrix_reset();
	
shader_reset();

gpu_set_blendmode(bm_normal);

if (!surface_exists(godRaysSurface))
{
	godRaysSurface = surface_create(1920, 1080);
}
	
surface_set_target(godRaysSurface);
	draw_clear_alpha(c_black, 0);
	part_system_drawit(godRaysSystem);
surface_reset_target();

matrix_set(matrix_world, matrix_build(x, y, z, spriteRotX, rot, rot + spriteRotY, 1, 1, 1));
	gpu_set_blendmode(bm_add);
		draw_surface(godRaysSurface, -(length + 3) * 16, -100);
	gpu_set_blendmode(bm_normal);
matrix_reset();