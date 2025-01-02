var length = 1200;

part_emitter_region(godRaysSystem, 0, 0, length, 100, 100, ps_shape_line, ps_distr_linear)
part_emitter_stream(godRaysSystem, 0, godRaysType, 1);