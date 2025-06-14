draw_clear(merge_color(global.c_darkBlue, global.c_neon, dividerX / (-room_width * 0.2)));

var p1Color = c_black;
var p2Color = c_black;

if (p1Selected != 0)
{
    p1Color = global.characters[p1Selected - 1].color;
}

if (p2Selected != 0)
{
    p2Color = global.characters[p2Selected - 1].color;
}

draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, -room_height + tileY, 1, 1, 0, p1Color, introAlpha);
draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, tileY, 1, 1, 0, p1Color, introAlpha);

draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, -room_height + tileY, 1, 1, 0, p2Color, introAlpha);
draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, tileY, 1, 1, 0, p2Color, introAlpha);

draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, c_white, introAlpha);
draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, c_white, introAlpha);

draw_sprite_ext(s_characterSelection, 0, -dividerX + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, c_white, introAlpha);
draw_sprite_ext(s_characterSelection, 0, -dividerX + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, c_white, introAlpha);

ui.draw();