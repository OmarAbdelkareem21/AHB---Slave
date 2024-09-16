`timescale 1ns/100ps
module AHBSlave_tb #(parameter AddresseWidth = 32 , parameter DataWidth = 32 , parameter InWidth = 32  , parameter ControlWidth = 16) ();

// Global Interface
	 reg HCLK;
	 reg HRESETn;
	
	// Data 
	 reg [DataWidth - 1 : 0] HWDATA;
	
	// Address & ControlWidth
	 reg [AddresseWidth - 1 : 0] HADDR;
	 reg HWRITE;
	 reg [2 : 0] HSIZE;
	 reg [2 : 0] HBURST;
	// reg [3 : 0] HPORT;
	 reg [1 : 0] HTRANS;
	// reg HMASTLOCK;	
	 reg HREADY;
	
	// Select
	 reg HSELx;
	
	// Transfer Response 
	 wire HREADYOUT;
	 wire HRESP;
	
	 wire [DataWidth - 1 : 0] HRDATA;
	
	// External Interface 
	 wire Write;
	 wire Read;
	 wire [AddresseWidth - 1 : 0] AddressOUT;
	 wire [DataWidth - 1 : 0] OutputData;

	 reg [DataWidth - 1 : 0] InData;
	 reg ValidRead;
	 reg StopOp;
	 reg ReadyToWork;
	
	AHBSlave SlaveMod (
		
		.HCLK(HCLK),
		.HRESETn(HRESETn),
		.HWDATA(HWDATA),
		.HADDR(HADDR),
		.HWRITE(HWRITE),
		.HSIZE(HSIZE),
		.HBURST(HBURST),
		.HTRANS(HTRANS),
		.HREADY(HREADY),
		.HSELx(HSELx),
		.HREADYOUT(HREADYOUT),
		.HRESP(HRESP),
		.HRDATA(HRDATA),
		
		.Write(Write),
		.Read(Read),
		.AddressOUT(AddressOUT),
		.OutputData(OutputData),
		.InData(InData),
		.ValidRead(ValidRead),
		.StopOp(StopOp),
		.ReadyToWork (ReadyToWork)
	);
	
	localparam [1 : 0] IDLE = 2'b00,
				   BUSY = 2'b01,
				   NONSEQ = 2'b10,
				   SEQ = 2'b11;
	
	integer clock = 5 ;
	
	always #clock HCLK = !HCLK ;
	
	task initialize ;
	begin
		HCLK= 1'D0;
		HWDATA = 'D0;
		HADDR = 'D0;
		HWRITE = 'D0;
		HSIZE = 3'b010;
		HBURST = 3'b000;
		HTRANS = 3'b000;
		HREADY = 'D1;
		HSELx = 'D0;
		InData = 'D0;
		ValidRead = 'D0;
		StopOp = 'D0;
		ReadyToWork = 'D1;
	end
	endtask
	
	
	task reset ;
	begin
		HRESETn = 1'D1 ;
		#2 
		HRESETn = 1'D0;
		#2
		HRESETn = 1'D1;
		#1
		#1;
	end
	endtask
	
	task TestCase1 ;
	begin
		HSELx = 1'D0;
		HTRANS = IDLE;
		#10 
		if (AddressOUT == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
		if (HRDATA == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
		if (OutputData == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
		#10 
		if (AddressOUT == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
		if (HRDATA == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
		if (OutputData == 'D0)
			$display ("TC1 Valid");
		else
			$display ("TC1 Failed");
	end
	endtask
	
	task TestCase2;
	begin
	// Write NONSEQ
		HSELx = 1'D1;
		HTRANS = NONSEQ;
		HWRITE = 1'D1 ;
		HADDR = 'habcd ;
		#10
		HTRANS = IDLE;
		HWRITE = 1'D0 ;
		if (Write == 1)
			$display ("TC2 Valid");
		else
			$display ("TC2 Failed");
		if (Read == 0)
			$display ("TC2 Valid");
		else
			$display ("TC2 Failed");
		if (AddressOUT == 'habcd)
			$display ("TC2 Valid");
		else
			$display ("TC2 Failed");
		HWDATA = 'H1234;
		#10
		if (OutputData == 'h1234)
			$display ("TC2 Valid");
		else
			$display ("TC2 Failed");
	#10;
	end
	endtask
	
	task TestCase3;
	begin
	// Write Write
		HSELx = 1'D1;
		HTRANS = NONSEQ;
		HWRITE = 1'D1 ;
		HADDR = 'hab44 ;
		#10
		HTRANS = SEQ;
		HWRITE = 1'D1 ;
		if (Write == 1)
			$display ("TC3 Valid");
		else
			$display ("TC3 Failed");
		if (Read == 0)
			$display ("TC3 Valid");
		else
			$display ("TC3 Failed");
		if (AddressOUT == 'hab44)
			$display ("TC3 Valid");
		else
			$display ("TC3 Failed");
		
		HWDATA = 'H12c4;
		HADDR = 'h77DD ;
		#10
		HTRANS = IDLE;
		HWRITE = 1'D0 ;
		if (OutputData == 'h12c4)
			$display ("TC3 Valid");
		else
			$display ("TC3 Failed");
		if (AddressOUT == 'h77DD)
			$display ("TC2 Valid");
		else
			$display ("TC3 Failed");
		HWDATA = 'Haa22;
		#10;
		if (OutputData == 'haa22)
			$display ("TC3 Valid");
		else
			$display ("TC3 Failed");
	#10;
	end
	endtask
	
	task TestCase4 ;
	begin
	// Hready Become Low
		HSELx = 1'D1;
		HTRANS = NONSEQ;
		HWRITE = 1'D1 ;
		HADDR = 'hab44 ;
		#10
		HTRANS = SEQ;
		HWRITE = 1'D1 ;
		HREADY = 1'd0;
		if (Write == 1)
			$display ("TC4 Valid");
		else
			$display ("TC4 Failed");
		if (Read == 0)
			$display ("TC4 Valid");
		else
			$display ("TC4 Failed");
		if (AddressOUT == 'hab44)
			$display ("TC4 Valid");
		else
			$display ("TC4 Failed");
		HWDATA = 'H12c4;
		HADDR = 'h77DD ;
		#10
		HTRANS = SEQ;
		HWRITE = 1'D1 ;
		HREADY = 1'd1;
		if (AddressOUT != 'h77DD)
			$display ("TC4 Valid");
		else
			$display ("TC4 Failed");
		#10;
		HWDATA = 'Haa22;
		#1
		if (OutputData == 'haa22)
			$display ("TC4 Valid");
		else
			$display ("TC4 Failed");
		#10;
		
	
	end
	endtask
	
	task TestCase5;
	begin
		// Read 
		HSELx = 1'D1;
		HTRANS = NONSEQ;
		HWRITE = 1'D0 ;
		HADDR = 'habcd ;
		#10
		HTRANS = IDLE;
		HWRITE = 1'D0 ;
		if (Write == 0)
			$display ("TC5 Valid");
		else
			$display ("TC5 Failed");
		if (Read == 1)
			$display ("TC5 Valid");
		else
			$display ("TC5 Failed");
		if (AddressOUT == 'habcd)
			$display ("TC5 Valid");
		else
			$display ("TC5 Failed");
		InData = 'H1234;
		ValidRead = 1'd1;
		#4
		if (HRDATA == 'h1234)
			$display ("TC5 Valid");
		else
			$display ("TC5 Failed");
	#10;
	end
	endtask
	
	
	initial 
	begin
 	   initialize ();
		reset ();
		
		// TestCase1 ();
		// TestCase2 ();
		// TestCase3 ();
		// TestCase4 ();
		TestCase5 ();
		$stop;
	end


endmodule 