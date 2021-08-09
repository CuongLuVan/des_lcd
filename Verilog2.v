




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
				  

module quyetdinhphim(input clk_50,input [7:0] phim,output [7:0] phimchuan,output xoaphim1);
reg [7:0] lenh=8'h00;
reg [7:0] phimluu;
reg [7:0] phimra1=8'hff;
reg [7:0] phimra2=8'hff;
reg [15:0] phimra3=16'hffff;
reg [27:0] thanhdem=28'h0000000;
reg xoaphim;

always @(posedge clk_50)
begin

                     thanhdem=thanhdem+1;
 
                 
 case (phim)
8'h45:begin phimra1<=8'h00;lenh<=8'h00; end //0
8'h16:begin phimra1<=8'h01; lenh<=8'h00; end //0
8'h1e:begin phimra1<=8'h02;lenh<=8'h00;  end //0
8'h26:begin  phimra1<=8'h03; lenh<=8'h00; end
8'h25:begin phimra1<=8'h04; lenh<=8'h00; end
8'h2e:begin phimra1<=8'h05; lenh<=8'h00; end
8'h36:begin  phimra1<=8'h06; lenh<=8'h00; end
8'h3d:begin phimra1<=8'h07; lenh<=8'h00; end
8'h3e:begin phimra1<=8'h08; lenh<=8'h00; end
8'h46:begin phimra1<=8'h09; lenh<=8'h00; end   //9
8'h29:begin phimra2<=8'hff; lenh<=8'h00; end   //xoaphim* shifl la12 
8'h12:begin phimra2<=8'h0a; lenh<=8'h00; end   //phim* shifl la12 
default:
lenh<=8'h00;
endcase

///end
if(thanhdem==28'd10000000) begin
      xoaphim<=1'b0;
           if(phimra2==8'h0a) begin 
                   if(phimra1==8'h03) begin
                                        phimluu=8'h0a; //#

                                        end
                  if(phimra1==8'h08) begin
                                        phimluu=8'h0b;  //*
                                        end
                  if((phimra1!=8'h03)&&(phimra1!=8'h08)) begin
                                        phimluu=8'hff;
                                        end                                        
                                        
                          end
                   else
                   begin
                    if(phimra1<8'h0a) begin
                                        phimluu<=phimra1; 
                                        end  
                                        else
                                       begin
                                        phimluu<=8'hff; 
                                        end
                   
                   end

      
      
      end

   if(thanhdem==28'd13200000) begin
       xoaphim<=1'b1;
       phimra1<=8'hff;
       phimra2<=8'hff;
       phimluu<=8'hff; 
           end
                     
if(thanhdem==28'd22000000) begin
       xoaphim<=1'b1;
       phimra1<=8'hff;
       phimra2<=8'hff;
       phimluu<=8'hff; 
    
           end
                                
if(thanhdem==28'd34000000) begin
 
       thanhdem=28'h0000000;
           end
           
end



assign phimchuan=phimluu;
assign xoaphim1=xoaphim;
endmodule 





module bodem_8(input iCLK,input lap,output [7:0] giatri);
reg [7:0] giatriluutru=8'h00;

always @(posedge iCLK )
if(lap==1'b0) begin
              giatriluutru=8'h00;
              end
else
             begin
            giatriluutru=giatriluutru+1;
             end
             
             

assign giatri=giatriluutru;

endmodule


module bodem(input iCLK_50,output xung);
reg [31:0] giatriluutru=32'h00000000;

always @(posedge iCLK_50)
             begin
             
             giatriluutru=giatriluutru+1;
              
             end
             
             
assign xung=giatriluutru[20];
endmodule

module bodem_3s(input iCLK_50,input lap,output [31:0] giatri,output xung);
reg [31:0] giatriluutru=32'h00000000;
reg ed=1'b0;
always @(posedge iCLK_50)
        begin
              if(lap==1'b0) begin 
                     giatriluutru=32'h00000000;  
                     ed<=1'b0;      
                            end
                            else
                             begin
                giatriluutru=giatriluutru+1;
             if(giatriluutru==32'd150000000)    ed<=1'b1;
          
              
                             end
                             
        end     
             
assign xung=ed;
assign giatri=giatriluutru;

endmodule


//module truyendulieu(input [7:])

