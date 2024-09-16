module AHBSlave #(parameter AddresseWidth = 32 , parameter DataWidth = 32 , parameter InWidth = 32  , parameter ControlWidth = 16) ( 

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
	output reg HREADYOUT,
	output reg HRESP,
	
	output reg [DataWidth - 1 : 0] HRDATA,
	
	// External Interface 
	output reg Write,
	output reg Read,
	output reg [AddresseWidth - 1 : 0] AddressOUT,
	output reg [DataWidth - 1 : 0] OutputData,

	input wire [DataWidth - 1 : 0] InData,
	input wire ValidRead,
	input wire StopOp,
	input wire ReadyToWork

);

localparam [1 : 0] IDLE = 2'b00,
				   BUSY = 2'b01,
				   NONSEQ = 2'b10,
				   SEQ = 2'b11;
				   
reg [3 : 0] CurrentState , NextState;

// HWRITE = 1 -> Write while HWRITE = 0 -> Read
				 
always @(posedge HCLK or negedge HRESETn)
begin
	if (!HRESETn)
		begin
			Write <= 'd0 ;
			Read <= 'd0 ;
			AddressOUT <= 'd0 ;
		end
	else
		begin
			if (HSELx & HREADY)
				begin
					case (HTRANS)
						
						NONSEQ :
							begin
								Write <= HWRITE ;
								Read <= !HWRITE ;
								AddressOUT <= HADDR ;
							end
								
					
						SEQ :
							begin
								Write <= HWRITE ;
								Read <= !HWRITE ;
								AddressOUT <= HADDR ;
							end
						default :
							begin
								Write <= HWRITE ;
								Read <= !HWRITE ;
							end
				
					endcase
				end
		end
end

// always @(posedge HCLK or negedge HRESETn)
// begin
	// if (!HRESETn)
		// begin
			// HREADYOUT <= 'd0 ;
			// HRESP <= 'd0 ;
		// end
	// else
		// begin
			// HREADYOUT <= ReadyToWork ;
			// if (!HREADY)
				// HRESP <= StopOp ;
		// end
// end

always @(*)
begin

	
			HREADYOUT = ReadyToWork ;
			if (!HREADY)
				HRESP = StopOp ;
			else
				HRESP = 1'D0;

end


always@(*)
begin
	if (HSELx & ValidRead)
		begin
			HRDATA = InData ;
		end
	else
		begin
			HRDATA = 'D0;
		end
end

always @(*)
begin
	OutputData  = HWDATA ;
end



endmodule