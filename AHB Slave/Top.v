module Top  #(parameter AddresseWidth = 4 , parameter DataWidth = 8 , parameter InWidth = 8  , parameter ControlWidth = 16) (


	// Global Interface
	input wire HCLK, 
	input wire HRESETn,
	
	// Data 
	input wire [DataWidth - 1 : 0] HWDATA,
	
	// Address & ControlWidth
	input wire [AddresseWidth - 1 : 0] HADDR,
	input wire HWRITE,
	input wire [2 : 0] HSIZE,
	input wire [2 : 0] HBURST,
	//output reg [3 : 0] HPORT,
	input wire [1 : 0] HTRANS,
	//output reg HMASTLOCK,	
	input wire HREADY,
	
	// Select
	input wire HSELx,
	
	// Transfer Response 
	output wire HREADYOUT,
	output wire HRESP,
	
	output wire [DataWidth - 1 : 0] HRDATA


);

wire Write , Read ;
wire [AddresseWidth - 1 : 0] AddressOUT ;
wire [DataWidth - 1 : 0] OutputData, InData ;
wire ValidRead , StopOp , ReadyToWork ;

AHBSlave #(.AddresseWidth (4) , .DataWidth (8) , .InWidth (4)  , .ControlWidth(16)) SlaveModULE  (
		
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
	
RegFile RegModule (
	.CLK(HCLK),
	.RST(HRESETn),
	.Rden(Read),
	.Wren(Wren),
	.WrData(OutputData),
	.Adresse(AddressOUT),
	.ReadyToWork(ReadyToWork),
	.RdData_Valid(ValidRead),
	.RdData(InData),
	.StopOp(StopOp)
);

endmodule 