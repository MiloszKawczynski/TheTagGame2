if (!instance_exists(o_characterSelection))
{
    draw_clear(global.c_neon);

    draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, -room_height + tileY, 1, 1, 0, global.characters[global.leftCharacter].color, 1);
    draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, tileY, 1, 1, 0, global.characters[global.leftCharacter].color, 1);
    
    draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, -room_height + tileY, 1, 1, 0, global.characters[global.rightCharacter].color, 1);
    draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, tileY, 1, 1, 0, global.characters[global.rightCharacter].color, 1);
    
    draw_sprite_ext(s_characterSelection, 0, -room_width * 0.2 + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, c_white, 1);
    draw_sprite_ext(s_characterSelection, 0, -room_width * 0.2 + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, c_white, 1);
    
    draw_sprite_ext(s_characterSelection, 0, room_width * 0.2 + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, c_white, 1);
    draw_sprite_ext(s_characterSelection, 0, room_width * 0.2 + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, c_white, 1);
}

ui.draw();