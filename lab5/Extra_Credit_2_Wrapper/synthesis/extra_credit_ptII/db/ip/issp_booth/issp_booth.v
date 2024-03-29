// issp_booth.v

// Generated using ACDS version 19.1 670

`timescale 1 ps / 1 ps
module issp_booth (
		input  wire        source_clk, // source_clk.clk
		output wire [16:0] source      //    sources.source
	);

	altsource_probe_top #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("ISSP"),
		.probe_width             (0),
		.source_width            (17),
		.source_initial_value    ("0"),
		.enable_metastability    ("YES")
	) in_system_sources_probes_0 (
		.source     (source),     //    sources.source
		.source_clk (source_clk), // source_clk.clk
		.source_ena (1'b1)        // (terminated)
	);

endmodule
