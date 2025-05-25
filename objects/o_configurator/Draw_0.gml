if (!isTeamColorsSpriteCreated)
{
    var surf = surface_create(16, 16);
    
    for (var i = 0; i < array_length(global.c_teamColors); i++)
    {
        surface_set_target(surf);
        
        draw_clear_alpha(c_white, 0);
        draw_sprite_ext(s_triangle, 0, 0, 0, 1, 1, 0, global.c_teamColors[i], 1);
        
        array_push(global.s_teamColors, sprite_create_from_surface(surf, 0, 0, 16, 16, false, false, 8, 8));
        
        surface_reset_target();
    }
    
    surface_free(surf);
    
    isTeamColorsSpriteCreated = true;
}