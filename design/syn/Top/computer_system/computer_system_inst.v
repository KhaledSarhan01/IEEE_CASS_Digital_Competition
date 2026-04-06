	computer_system u0 (
		.clk_clk                        (<connected-to-clk_clk>),                        //                     clk.clk
		.memory_mem_a                   (<connected-to-memory_mem_a>),                   //                  memory.mem_a
		.memory_mem_ba                  (<connected-to-memory_mem_ba>),                  //                        .mem_ba
		.memory_mem_ck                  (<connected-to-memory_mem_ck>),                  //                        .mem_ck
		.memory_mem_ck_n                (<connected-to-memory_mem_ck_n>),                //                        .mem_ck_n
		.memory_mem_cke                 (<connected-to-memory_mem_cke>),                 //                        .mem_cke
		.memory_mem_cs_n                (<connected-to-memory_mem_cs_n>),                //                        .mem_cs_n
		.memory_mem_ras_n               (<connected-to-memory_mem_ras_n>),               //                        .mem_ras_n
		.memory_mem_cas_n               (<connected-to-memory_mem_cas_n>),               //                        .mem_cas_n
		.memory_mem_we_n                (<connected-to-memory_mem_we_n>),                //                        .mem_we_n
		.memory_mem_reset_n             (<connected-to-memory_mem_reset_n>),             //                        .mem_reset_n
		.memory_mem_dq                  (<connected-to-memory_mem_dq>),                  //                        .mem_dq
		.memory_mem_dqs                 (<connected-to-memory_mem_dqs>),                 //                        .mem_dqs
		.memory_mem_dqs_n               (<connected-to-memory_mem_dqs_n>),               //                        .mem_dqs_n
		.memory_mem_odt                 (<connected-to-memory_mem_odt>),                 //                        .mem_odt
		.memory_mem_dm                  (<connected-to-memory_mem_dm>),                  //                        .mem_dm
		.memory_oct_rzqin               (<connected-to-memory_oct_rzqin>),               //                        .oct_rzqin
		.reset_reset_n                  (<connected-to-reset_reset_n>),                  //                   reset.reset_n
		.lenet_addr_export              (<connected-to-lenet_addr_export>),              //              lenet_addr.export
		.lenet_data_export              (<connected-to-lenet_data_export>),              //              lenet_data.export
		.lenet_write_enable_export      (<connected-to-lenet_write_enable_export>),      //      lenet_write_enable.export
		.lenet_start_export             (<connected-to-lenet_start_export>),             //             lenet_start.export
		.lenet_predication_out_export   (<connected-to-lenet_predication_out_export>),   //   lenet_predication_out.export
		.lenet_predication_valid_export (<connected-to-lenet_predication_valid_export>)  // lenet_predication_valid.export
	);

