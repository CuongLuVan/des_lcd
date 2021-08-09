
module keyboard(input iCLK_50,
                input [0:0] iKEY,
					 input [0:0] iSW,
					 input PS2_KBCLK,PS2_KBDAT,
					 
					 output reg [0:0] oLEDR,
					 output  [7:0] oLEDG);
					 
	
localparam [1:0] idle = 2'b00,
                 dps  = 2'b01,
					  load = 2'b10;
					  
reg [1:0] state_reg,state_next;
reg  filter_reg;
wire filter_next;
reg  f_ps2c_reg;
wire f_ps2c_next;
reg [3:0] n_reg,n_next;
reg [10:0] b_reg,b_next;
wire fall_edge;

always @(posedge iCLK_50 or negedge iKEY[0])
 if (~iKEY[0]) begin
                 filter_reg <= 0;
				 f_ps2c_reg <= 0;
					end
 else begin
        filter_reg <= filter_next;
		  f_ps2c_reg <= f_ps2c_next;
		end
		
assign filter_next = PS2_KBCLK;
assign f_ps2c_next = (filter_reg == 1'b1)?1'b1:(filter_reg == 1'b0)?1'b0:f_ps2c_reg;

assign fall_edge = f_ps2c_reg & ~f_ps2c_next;

always @(posedge iCLK_50 or negedge iKEY[0])
  if (~iKEY[0]) begin
                  state_reg <= idle;
					   n_reg     <= 0;
					   b_reg     <= 0;
					 end
  else begin
         state_reg <= state_next;
		   n_reg     <= n_next;
		   b_reg     <= b_next;
	    end
		
always @*
 begin
    state_next = state_reg;
	 b_next     = b_reg;
	 n_next     = n_reg;
	 oLEDR      = 1'b0;
	 case(state_reg)
	    idle : if (fall_edge & iSW[0]) begin
		                                  b_next = {PS2_KBDAT,b_reg[10:1]};
													 n_next = 4'b1001;
													 state_next = dps;
												  end
	    dps : if (fall_edge) begin
		                         b_next = {PS2_KBDAT,b_reg[10:1]};
										 if (n_reg == 0) state_next = load;
										 else n_next = n_reg -1 ;
								    end
	   load : if (fall_edge) begin
		                        b_next = {PS2_KBDAT,b_reg[10:1]};
		                        oLEDR = 1'b1;
					               state_next = idle;
				                end
		       
	 endcase
 end 
 
assign oLEDG = b_reg[8:1];

endmodule
				  
