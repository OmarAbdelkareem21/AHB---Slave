module RegFile #(parameter width = 8 , parameter depth = 4) (
	input wire CLK,
	input wire RST,
	input wire Wren,
	input wire Rden,
	input wire [width -1 : 0] WrData,
	input wire [depth -1 : 0] Adresse,
	
	output reg RdData_Valid,
	output reg [width -1 : 0] RdData,
	output reg StopOp,
	output reg ReadyToWork

	
);


reg [width-1 : 0] RegFileMem [0 : (1<<depth) - 1] ;
reg  Empty [0 : (1<<depth) - 1] ;
integer i ;

always @(posedge CLK or negedge RST)
begin
	if (!RST)
		begin
			for (i = 0 ; i < (1<<depth) ; i = i + 1 )
				begin
					begin
						RegFileMem [i] <= 'd0;
						Empty [i] <= 'D0;
					end
				end
			RdData <= 'd0;
			RdData_Valid <= 'd0;
			RdData_Valid <= 'd0;
			
			StopOp <= 'd0;
			ReadyToWork <= 'D1;
		end
	else
		begin
			if (Wren && !Rden)
				begin
					if (!Empty [i])
						begin
							RegFileMem [Adresse] <= WrData ;
							Empty [i] <= 1'd1 ;
							ReadyToWork <= 'D1;
						end
					else 
						begin
							ReadyToWork = 1'd0;
						end
				end
			else if (!Wren && Rden)
				begin
					if (Empty [i])
						begin
							RdData <= RegFileMem [Adresse];
							RdData_Valid <= 'd1;
							Empty [i] <= 1'd0 ;
						end
					else 
						begin
							RdData_Valid = 1'd0;
							ReadyToWork <= 'D0;
						end
					
				end
			else
				begin
				RdData_Valid <= 'd0;
				ReadyToWork <= 'D1;
				end
		end
end


endmodule