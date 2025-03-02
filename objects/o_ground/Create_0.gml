groundModel = fauxton_model_create_ext(s_tartanTexture, 0, 0, 0, 0, 0, 0, 1, 1, 0.1, c_white, 1);
color = make_color_hsv(random(255), 218, 160);

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