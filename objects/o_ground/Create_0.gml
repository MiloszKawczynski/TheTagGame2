groundModel = fauxton_model_create_ext(s_16x16, room_width / 2, room_height / 2, 0, 0, 0, 0, room_width / 16 / 10, room_height / 16 / 7.5, 0.1, c_white, 1);
color = c_gray;

editor = function()
{
	color = ImGui.ColorEdit3("Color", color);
}

fauxton_model_draw_enable(groundModel, false);

colorUniform = shader_get_uniform(shd_defaultReplaceWhite, "color");

sizeUniform = shader_get_uniform(shd_shadows, "size");
thickUniform = shader_get_uniform(shd_shadows, "thick");
uvsUniform = shader_get_uniform(shd_shadows, "uvs");

texelW = texture_get_texel_width(sprite_get_texture(sprite_index, 0));
texelH = texture_get_texel_height(sprite_get_texture(sprite_index, 0));

uvs = sprite_get_uvs(sprite_index, 0);