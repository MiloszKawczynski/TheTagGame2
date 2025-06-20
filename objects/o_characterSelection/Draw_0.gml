draw_clear(merge_color(global.c_discordBlack, global.c_neon, dividerX / (-room_width * 0.2)));

var p1Color = c_black;
var p2Color = c_black;

if (p1Selected != randomCharacter)
{
    p1Color = global.characters[p1Selected].color;
}

if (p2Selected != randomCharacter)
{
    p2Color = global.characters[p2Selected].color;
}

draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, -room_height + tileY, 1, 1, 0, p1Color, introAlpha);
draw_sprite_ext(s_characterSelectionVignetteLeft, 0, 0, tileY, 1, 1, 0, p1Color, introAlpha);

draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, -room_height + tileY, 1, 1, 0, p2Color, introAlpha);
draw_sprite_ext(s_characterSelectionVignetteRight, 0, 0, tileY, 1, 1, 0, p2Color, introAlpha);

draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, dividerColor, introAlpha);
draw_sprite_ext(s_characterSelection, 0, dividerX + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, dividerColor, introAlpha);

draw_sprite_ext(s_characterSelection, 0, -dividerX + lerp(54, 0, tileY / room_height), -room_height + tileY, 1, 1, 0, dividerColor, introAlpha);
draw_sprite_ext(s_characterSelection, 0, -dividerX + lerp(0, -54, tileY / room_height), tileY, 1, 1, 0, dividerColor, introAlpha);

ui.draw();