// 02/08/2024 Tyler Sheaves for UC Davis EEC180 W2024

// Adapted from:
// ----------------------------------------------------------------
// 10/28/2011 D. W. Hawkins (dwh@caltech.edu)
// ----------------------------------------------------------------

// Modelsim-ASE requires a timescale directive
`timescale 1 ns / 1 ns

// Path to the JTAG Virtual TAP model
//
// * this path was determined using Modelsim-ASE
//   - change to the qsys_system/simulation/mentor/ folder, source
//     the msim_setup.tcl file, call com to build the source,
//     then elab +nowarnTFMPC to load the top-level qsys_system
//     design (not a testbench). The path was
//
//   eg., qsys_system.jtag_master.jtag_phy_embedded_in_jtag_master.normal.jtag_dc_streaming.jtag_streaming.node
//
// * This testbench instantiates the dut, so the path is
//   one level higher, i.e.,
//
// Quartus Prime 19.1 Lite
// ---------------
`define VTAP dut.uHandler.u0.jtag_master.jtag_phy_embedded_in_jtag_master.genblk1.node

//-----------------------------------------------------------------
// The testbench
//-----------------------------------------------------------------
//
module tb_partII();

	// ------------------------------------------------------------
	// Local parameters
	// ------------------------------------------------------------
	//

	// Clock period
	localparam time CLK_PERIOD = 20ns;

	// Lab 6 Part II parameters
	localparam dim                  = 32'd8;
	localparam n_pixels             = dim*dim;
	localparam test_repetitions     = 2;
	localparam timeout_cycles       = 10000;

	localparam pixel_ram_addr       = 32'h00000000;
	localparam img_dim_addr         = 32'h00040800;
	localparam start_transfer_addr  = 32'h00040810;
	localparam ram_ready_addr       = 32'h00040820;
	localparam mode_addr            = 32'h00040830;
	localparam hist_bins_addr       = 32'h00040840;
	localparam hist_ram_addr        = 32'h00050000;

	// ------------------------------------------------------------
	// Local variables and signals
	// ------------------------------------------------------------
	//

	// Platform Designer
	logic        
		clk,
		reset_n;

	// Testbench variables
	logic [31:0] 
		rddata, 
		wrdata, 
		start;
	integer 
		ram_bytelen;
	int 
		error_flag,
		test_count,
		idx_test,
		rand_ready_delay,
		cycle_count [4],
		mode;
	logic [7:0]
		img_in      [n_pixels],
		img_out     [4][n_pixels],
		img_out_exp [4][n_pixels];

	string
		load_data_in,
		load_data_exp;

	// ------------------------------------------------------------
	// Clock generator
	// ------------------------------------------------------------
	//
	initial
		clk = 1'b0;
	always
		#(CLK_PERIOD/2) clk <= ~clk;

	// ------------------------------------------------------------
	// Device under test
	// ------------------------------------------------------------
	//
	taskII dut(
		.MAX10_CLK1_50(clk),
		.KEY({1'b1,reset_n})
	);

	// ------------------------------------------------------------
	// Test stimulus
	// ------------------------------------------------------------
	//
	initial
	begin
		test_count = 1;
		// --------------------------------------------------------
		// Start message
		// --------------------------------------------------------
		//
		$display("");
		$display("");
		$display("===============================================================");
		$display("       Lab 6 Part II Testbench w/ USB-Blaster emulation        ");
		$display("===============================================================");

		// Read input image generated from MATLAB
		load_data_in = 
			$sformatf("../../software/SimData/img_hex_data/task_2_dim_%0d_in.hex" ,dim);
		$readmemh(load_data_in, img_in);

		// --------------------------------------------------------
		// Signal defaults
		// --------------------------------------------------------
		//
		reset_n = 0;

		// --------------------------------------------------------
		// JTAG reset
		// --------------------------------------------------------
		//
		$display(" * Reset the JTAG controller");
		`VTAP.reset_jtag_state;

		// --------------------------------------------------------
		// Deassert reset
		// --------------------------------------------------------
		//
		$display(" * Deassert reset");
		#100ns reset_n = 1;

		// --------------------------------------------------------
		// Give the system reset synchronizers a few clocks
		// --------------------------------------------------------
		//
		#(10*CLK_PERIOD);

		$display(" * Setting dim to %0d...", dim);
		master_write_32(img_dim_addr, dim);

		for(mode = 0; mode < 4; mode=mode+1) begin

			load_data_exp = 
				$sformatf("../../software/SimData/img_hex_data/task_2_dim_%0d_mode_%0d_expected.hex", dim, mode);
			$readmemh(load_data_exp, img_out_exp[mode]);

			$display("");
			$display("===============================================================");
			$display("Starting Test on Mode %0d", mode);
			$display("===============================================================");

			// --------------------------------------------------------
			// The USB-blaster interface is 32-bits
			//	- Write the image in 32-bit words
			// --------------------------------------------------------
			//
			$display(" * Loading test image to RAM...");
			for(int i = 0; i < n_pixels; i = i + 4) begin
				master_write_32(
					pixel_ram_addr + i, 
					{img_in[i+3], img_in[i+2], 
					img_in[i+1], img_in[i]});
			end

			$display(" * Setting mode to %0d...", mode);
			master_write_32(mode_addr, mode);

			// --------------------------------------------------------
			// We don't know when the OS will assert ready 
			//		so wait a random amount of time
			// --------------------------------------------------------
			//
			rand_ready_delay = $urandom_range(1,100);
			repeat(rand_ready_delay)
				@(posedge clk);

			// --------------------------------------------------------
			// 2 parallel processes
			//		1 - Issue ready and wait on start over JTAG
			//		2 - Count the logic cycles
			//		* If we didn't do this we would factor the long
			//			JTAG transfer time into performance metrics
			// --------------------------------------------------------
			//
			start = 0;
			cycle_count[mode] = 1;
			fork
				begin
					$display(" * Setting ready high...");
					master_write_32(ram_ready_addr, 32'h1);
					$display(" * Waiting on start...");
					while(start !== 1'b1) begin
						master_read_32(start_transfer_addr, start);
					end
				end
				begin
					while(dut.ready !== 1'b1)begin
						@(posedge clk);
					end
					while(dut.start !== 1'b1 && cycle_count[mode] < timeout_cycles)begin
						@(posedge clk)
							cycle_count[mode] = cycle_count[mode] + 1;
					end
					if(cycle_count[mode] < timeout_cycles) begin
						$display(" * SUCCESS: start was set!");
					end else begin
						$display("");
						$display("===============================================================");
						$display("ERROR: start took >%0d cycles to be set! Stopping simulation.", timeout_cycles);
						$display("===============================================================");
					end
				end
			join_any
			disable fork;

			// --------------------------------------------------------
			// Stop if start was not asserted
			// --------------------------------------------------------
			//
			if(cycle_count[mode] >= timeout_cycles)
				$stop;

			// --------------------------------------------------------
			// Set ready back to 0 
			// --------------------------------------------------------
			//
			$display(" * Setting ready low...");
			master_write_32(ram_ready_addr, 32'h0);

			$display(" * Collecting result...");
			for(int i = 0; i < n_pixels; i = i + 4) begin
				master_read_32(
					pixel_ram_addr + i, 
					{img_out[mode][i+3], img_out[mode][i+2], 
					 img_out[mode][i+1], img_out[mode][i]});
			end

			// --------------------------------------------------------
			// Check results
			// --------------------------------------------------------
			//
			error_flag = 0;
			$display(" * Results: x - incorrect result; o - correct result");
			$write("\n\t");
			for(int i = 0; i < dim; i = i + 1) begin
				for(int j = 0; j < dim; j = j + 1) begin
					idx_test = i*dim + j;
					if(img_out[mode][idx_test] !== img_out_exp[mode][idx_test]) begin
						$write("x ");
						error_flag = 1;
					end else begin
						$write("o ");
					end
				end
				$write("\n\t");
			end
			$write("\n");

			if(error_flag == 1) begin
				$display(" * ERROR: Expected image and received does not match!");
			end else begin
				$display(" * SUCCESS: Expected image and received image match!");
			end

		end
		$display("");
		$display("===============================================================");
		$display("All tests complete! Your logic consumed:");
		$display(" * Mode 0 - %0d cycles.", cycle_count[0]);
		$display(" * Mode 1 - %0d cycles.", cycle_count[1]);
		$display(" * Mode 2 - %0d cycles.", cycle_count[2]);
		$display(" * Mode 3 - %0d cycles.", cycle_count[3]);
		$display("===============================================================");
		$display("");
		$stop;

	end

	// ============================================================
	// Tasks for JTAG transactions below - do not modify!!
	// ============================================================
	//
	// Avalon-MM read and write procedures.
	//
	// ------------------------------------------------------------
	task master_write_32 (
	// ------------------------------------------------------------
		input [31:0] addr,
		input [31:0] data
	);
		// Local variables
		logic [7:0] txbytes[12];
		logic [7:0] pkbytes[256];
		logic [7:0] wrbytes[256];
		logic [7:0] rdbytes[256];
		int pkindex;
		int wrindex;
		int rdindex;
		int byteindex;

	begin
		// Put the JTAG-to-Avalon-ST bridge in data mode
		@(posedge `VTAP.tck);
		`VTAP.enter_data_mode;

		// Virtual JTAG capture-DR state
		`VTAP.enter_cdr_state;

		// Avalon-MM transaction bytes format
		//
		//  Byte   Value  Description
		// ------  -----  -----------
		//    [0]  0x00   Transaction code = write, no increment
		//    [1]  0x00   Reserved
		//  [3:2]  0x0004 16-bit size (big-endian byte order)
		//  [7:4]  32-bit address (big-endian byte order)
		// [11:8]  32-bit data (little-endian byte order)
		//
		txbytes[0]  = 0;           // Write, no increment
		txbytes[1]  = 0;           // Reserved
		txbytes[2]  = 0;           // 16-bit size (big-endian)
		txbytes[3]  = 4;
		txbytes[4]  = addr[31:24]; // Address (big-endian)
		txbytes[5]  = addr[23:16];
		txbytes[6]  = addr[15: 8];
		txbytes[7]  = addr[ 7: 0];
		txbytes[8]  = data[ 7: 0]; // Data (little-endian)
		txbytes[9]  = data[15: 8];
		txbytes[10] = data[23:16];
		txbytes[11] = data[31:24];

		// Encode the transaction to packet bytes format
		//
		// Byte    Value  Description
		// -----   -----  ----------
		//  [0]    0x00   Channel number
		//  [1]    0x7A   Start-of-packet
		//  [X:2]         Transaction bytes with escape codes
		//         0x7B   End-of-packet
		//  [Y]           Last transaction byte (or escape code plus byte)
		//
		pkbytes[0]  = 'h7C;  // Channel
		pkbytes[1]  = 'h00;
		pkbytes[2]  = 'h7A;  // SOP

		// Insert the transaction bytes, escaping as needed
		pkindex = 3;
		for (int i = 0; i < 12; i++)
		begin
			// Insert the end-of-packet (before the last data/escaped data)
			if (i == 11)
			begin
				pkbytes[pkindex++] = 'h7B;
			end

			// Escape code required?
			if ((txbytes[i] >= 'h7A) && (txbytes[i] <= 'h7D))
			begin
				// Insert the escape code and modified byte
				pkbytes[pkindex++] = 'h7D;
				pkbytes[pkindex++] = txbytes[i] ^ 'h20;
			end
			else
			begin
				pkbytes[pkindex++] = txbytes[i];
			end
		end

		// Encode the packet bytes in JTAG-to-Avalon-ST format
		//
		// Byte    Value  Description
		// -----   -----  ----------
		//  [1:0]  0xFC00 JTAG-to-Avalon-ST packet header (256-bytes)
		// [X-1:2]        Transaction bytes with escape codes
		// [255:X]        JTAG-to-Avalon-ST IDLE codes
		//
		wrbytes[0]  = 'h00;  // FC00h header
		wrbytes[1]  = 'hFC;

		// Insert the transaction bytes, escaping as needed
		wrindex = 2;
		for (int i = 0; i < pkindex; i++)
		begin
			// Escape code required?
			if ((pkbytes[i] == 'h4A) || (pkbytes[i] == 'h4D))
			begin
				// Insert the escape code and modified byte
				wrbytes[wrindex++] = 'h4D;
				wrbytes[wrindex++] = pkbytes[i] ^ 'h20;
			end
			else
			begin
				wrbytes[wrindex++] = pkbytes[i];
			end
		end

		// Fill the remainder of the transaction with JTAG IDLE codes
		for (int i = wrindex; i < 256; i++)
			wrbytes[i] = 'h4A;

		// Send the bytes
		for (int i = 0; i < 256; i++)
		begin
			`VTAP.shift_one_byte(wrbytes[i],  rdbytes[i]);
		end

		// Parse and check the response data
		//
		// Bytes  Value  Description
		// -----  -----  -----------
		//  [0]    0x7C  Channel
		//  [1]    0x00  Channel number
		//  [2]    0x7A  Start-of-packet
		//  [3]    0x80  Transaction code with MSB set
		//  [4]    0x00  Reserved
		//  [5]    0x00  Size[15:8]
		//  [6]    0x7B  End-of-packet
		//  [7]    0x04  Size[7:0]
		//
		// Since the response data does not contain encoded
		// characters for this write command, they are not
		// checked (see the master_read_32 task for how its done).
		//
		// Find the channel code
		rdindex = 0;
		while ((rdindex < 256) && (rdbytes[rdindex++] != 'h7C));
		assert (rdindex < 256) else $error("Channel code not detected!");

		// Check all the response bytes
		assert (rdbytes[rdindex++] == 0)    else $error("Channel number error!");
		assert (rdbytes[rdindex++] == 'h7A) else $error("Start-of-packet code error!");
		assert (rdbytes[rdindex++] == 'h80) else $error("Transaction code error!");
		assert (rdbytes[rdindex++] == 'h00) else $error("Reserved code error!");
		assert (rdbytes[rdindex++] == 'h00) else $error("Size MSBs error!");
		assert (rdbytes[rdindex++] == 'h7B) else $error("End-of-packet code error!");
		assert (rdbytes[rdindex++] == 'h04) else $error("Size LSBs error!");

		// Virtual JTAG Exit1-DR and then Update-DR state
		`VTAP.enter_e1dr_state;
		`VTAP.enter_udr_state;
	end
	endtask

	// ------------------------------------------------------------
	task master_read_32 (
	// ------------------------------------------------------------
		input  [31:0] addr,
		output [31:0] data
	);
		// Local variables
		logic [7:0] txbytes[8];
		logic [7:0] pkbytes[256];
		logic [7:0] wrbytes[256];
		logic [7:0] rdbytes[256];
		int pkindex;
		int wrindex;
		int rdindex;
		int byteindex;

	begin

		// Put the JTAG-to-Avalon-ST bridge in data mode
		@(posedge `VTAP.tck);
		`VTAP.enter_data_mode;

		// Virtual JTAG capture-DR state
		`VTAP.enter_cdr_state;

		// Avalon-MM transaction bytes format
		//
		//  Byte   Value  Description
		// ------  -----  -----------
		//    [0]  0x10   Transaction code = read, no increment
		//    [1]  0x00   Reserved
		//  [3:2]  0x0004 16-bit size (big-endian byte order)
		//  [7:4]  32-bit address (big-endian byte order)
		//
		txbytes[0]  = 'h10;        // Read, no increment
		txbytes[1]  = 0;           // Reserved
		txbytes[2]  = 0;           // 16-bit size (big-endian)
		txbytes[3]  = 4;
		txbytes[4]  = addr[31:24]; // Address (big-endian)
		txbytes[5]  = addr[23:16];
		txbytes[6]  = addr[15: 8];
		txbytes[7]  = addr[ 7: 0];

		// Encode the transaction to packet bytes format
		//
		// Byte    Value  Description
		// -----   -----  ----------
		//  [0]    0x00   Channel number
		//  [1]    0x7A   Start-of-packet
		//  [X:2]         Transaction bytes with escape codes
		//         0x7B   End-of-packet
		//  [Y]           Last transaction byte (or escape code plus byte)
		//
		pkbytes[0]  = 'h7C;  // Channel
		pkbytes[1]  = 'h00;
		pkbytes[2]  = 'h7A;  // SOP

		// Insert the transaction bytes, escaping as needed
		pkindex = 3;
		for (int i = 0; i < 8; i++)
		begin
			// Insert the end-of-packet (before the last data/escaped data)
			if (i == 7)
			begin
				pkbytes[pkindex++] = 'h7B;
			end

			// Escape code required?
			if ((txbytes[i] >= 'h7A) && (txbytes[i] <= 'h7D))
			begin
				// Insert the escape code and modified byte
				pkbytes[pkindex++] = 'h7D;
				pkbytes[pkindex++] = txbytes[i] ^ 'h20;
			end
			else
			begin
				pkbytes[pkindex++] = txbytes[i];
			end
		end

		// Encode the packet bytes in JTAG-to-Avalon-ST format
		//
		// Byte    Value  Description
		// -----   -----  ----------
		//  [1:0]  0xFC00 JTAG-to-Avalon-ST packet header (256-bytes)
		// [X-1:2]        Transaction bytes with escape codes
		// [255:X]        JTAG-to-Avalon-ST IDLE codes
		//
		wrbytes[0]  = 'h00;  // FC00h header
		wrbytes[1]  = 'hFC;

		// Insert the transaction bytes, escaping as needed
		wrindex = 2;
		for (int i = 0; i < pkindex; i++)
		begin
			// Escape code required?
			if ((pkbytes[i] == 'h4A) || (pkbytes[i] == 'h4D))
			begin
				// Insert the escape code and modified byte
				wrbytes[wrindex++] = 'h4D;
				wrbytes[wrindex++] = pkbytes[i] ^ 'h20;
			end
			else
			begin
				wrbytes[wrindex++] = pkbytes[i];
			end
		end

		// Fill the remainder of the transaction with JTAG IDLE codes
		for (int i = wrindex; i < 256; i++)
			wrbytes[i] = 'h4A;

		// Send the byte stream
		for (int i = 0; i < 256; i++)
		begin
			`VTAP.shift_one_byte(wrbytes[i],  rdbytes[i]);
		end

		// Virtual JTAG Exit1-DR and then Update-DR state
		`VTAP.enter_e1dr_state;
		`VTAP.enter_udr_state;

		// Parse and extract the read data
		//
		// The read byte stream consists of;
		// * the 16-bit read data header (the LSB indicates
		//   whether read-data is available, which it will not
		//   be, so the first two bytes are zeros
		//
		// * JTAG-to-Avalon-ST IDLE codes (4Ah)

		// * the JTAG-to-Avalon-ST encoded bytes-to-packets
		//   response data, i.e., nominally
		//
		// Bytes  Value  Description
		// -----  -----  -----------
		//  [0]    0x7C  Channel
		//  [1]    0x00  Channel number
		//  [2]    0x7A  Start-of-packet
		//  [3]          Read-data[7:0]
		//  [4]          Read-data[15:8]
		//  [5]          Read-data[23:16]
		//  [6]    0x7B  End-of-packet
		//  [7]          Read-data[31:24]
		//
		// But if any of the data bytes use a special code used in either
		// the JTAG-to-Avalon-ST or by the bytes-to-packet protocol, then they
		// are escaped and the byte-stream contains the ESCAPE code followed
		// by the character XORed with the escape mask.
		//
		// Find the channel code
		rdindex = 0;
		while ((rdindex < 256) && (rdbytes[rdindex++] != 'h7C));
		assert (rdindex < 256) else $error("Channel code not detected!");

		// Check the first couple of bytes are correct
		assert (rdbytes[rdindex++] == 0)    else $error("Channel number error!");
		assert (rdbytes[rdindex++] == 'h7A) else $error("Start-of-packet code error!");

		// Parse the data bytes
		byteindex = 0;
		data = 0;
		while (byteindex < 4)
		begin

			// JTAG protocol escape code?
			if (rdbytes[rdindex] == 'h4D)
			begin
				rdindex++;
				data = data | ((rdbytes[rdindex++] ^ 'h20) << 8*byteindex);
			end

			// Packet protocol escape code?
			else if (rdbytes[rdindex] == 'h7D)
			begin
				rdindex++;
				data = data | ((rdbytes[rdindex++] ^ 'h20) << 8*byteindex);
			end

			// Just data
			else
			begin
				data = data | (rdbytes[rdindex++] << 8*byteindex);
			end
			byteindex++;

			// Check the end-of-packet
			if (byteindex == 3)
			begin
				assert (rdbytes[rdindex++] == 'h7B) else $error("End-of-packet code error!");
			end
		end
	end
	endtask

endmodule