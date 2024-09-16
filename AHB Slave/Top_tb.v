`timescale 1ns/100ps
module Top_tb #(parameter AddresseWidth = 4 , parameter DataWidth = 32 , parameter InWidth = 32  , parameter ControlWidth = 16 ) ();

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
	
	Top #(.AddresseWidth (4) , .DataWidth (8) , .InWidth (4)  , .ControlWidth(16)) topMod (
		
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
		.HRDATA(HRDATA)

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
	
	task TC1 ;
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
		#10;
	#10;
	end
	endtask
	
	initial 
	begin
		initialize ();
		HREADY = ReadyToWork ;
		reset ();
		TC1 ();
	$stop;
	end
endmodule