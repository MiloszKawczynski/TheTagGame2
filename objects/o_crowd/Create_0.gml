z = 33;
degree = 45;

crowdTexelW = texture_get_texel_width(sprite_get_texture(sprite_index, 0));
crowdTexelH = texture_get_texel_height(sprite_get_texture(sprite_index, 0));

crowdSideTexelW = texture_get_texel_width(sprite_get_texture(s_crowdSide, 0));
crowdSideTexelH = texture_get_texel_height(sprite_get_texture(s_crowdSide, 0));

sizeUniform = shader_get_uniform(shd_crowd, "size");
dotPositionXUniform = shader_get_uniform(shd_crowd, "dotPositionX");
dotPositionYUniform = shader_get_uniform(shd_crowd, "dotPositionY");
dotRadiusUniform = shader_get_uniform(shd_crowd, "dotSize");
dotLightUniform = shader_get_uniform(shd_crowd, "dotLight");

dotPositionX = [];
dotPositionY = [];
dotSize = [];
dotLight = [];

for(var i = 0; i < 100; i++)
{
    array_set(dotPositionX, i, random(1));
    array_set(dotPositionY, i, random(1) + 0.75);
    
    array_set(dotSize, i, random_range(0.01, 0.01));
    array_set(dotLight, i, 1);
}