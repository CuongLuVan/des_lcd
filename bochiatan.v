
module bochiatan(input iCLK_50,output xung);
reg [31:0] giatriluutru=32'h00000000;

always @(posedge iCLK_50)
             begin
             
             giatriluutru=giatriluutru+1;
              
             end
             
             
assign xung=giatriluutru[20];
endmodule
