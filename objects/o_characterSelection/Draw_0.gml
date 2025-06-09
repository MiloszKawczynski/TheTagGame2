draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, -room_height + tileY, 1, 1, 0, global.characters[max(p1Selected - 1, 0)].color, 1);
draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, tileY, 1, 1, 0, global.characters[max(p1Selected - 1, 0)].color, 1);

draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, -room_height + tileY, 1, 1, 0, global.characters[max(p2Selected - 1, 0)].color, 1);
draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, tileY, 1, 1, 0, global.characters[max(p2Selected - 1, 0)].color, 1);

draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, c_white, 1);
draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, c_white, 1);

ui.draw();