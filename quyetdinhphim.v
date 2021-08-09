
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

