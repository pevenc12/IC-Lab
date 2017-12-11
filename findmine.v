module findmine (clk,rst_n,play_enable,cell_mine,mine_1,mine_2,mine_3,mine_4,mine_5);

input clk;
input rst_n;
input play_enable;
input [35:0]cell_mine;

output reg [5:0]mine_1,mine_2,mine_3,mine_4,mine_5;
reg [5:0]position,position_next;
reg [2:0]counter,count_next;
reg enable;

 always @(posedge enable) begin
     if(play_enable) begin
       case(counter)
         3'd0: mine_1 <= position;
         3'd1: mine_2 <= position;
         3'd2: mine_3 <= position;
         3'd3: mine_4 <= position;
         3'd4: mine_5 <= position;
 //maybe something need to add
       endcase
     end
 end

  always @(*) begin
  count_next =counter;
   if(enable && play_enable)
   count_next = counter + 1'b1;
   if(counter == 3'd5)
   count_next = 3'd0;
  end

always @(*) begin
    enable = 1'b0;
    position_next = position + 1'b1; 

    if(position == 6'd35)
      position_next = 6'd0;

    if(cell_mine[position]) begin
      enable = 1'b1;
    end
    else 
      enable = 1'b0;
end

  always @(posedge clk or posedge rst_n)begin
  if(rst_n)begin
  counter<= 3'b0;
  position <= 3'b0;
  end
  else begin
  counter<=count_next;
  position<=position_next;
  end
  end

endmodule



/*
always(*)begin
for(i=0;i<35;i++)
  if(cell_mine[i])begin
  count_next=counter+1;
  case(count_next)
  3'b001:mine_1=i;
  3'b010:mine_2=i;
  3'b011:mine_3=i;
  3'b100:mine_4=i;
  3'b101:mine_5=i;
  default:mine_1=mine_1;
  			mine_2=mine_2;
  			mine_3=mine_3;
  			mine_4=mine_4;
  			mine_5=mine_5;
  endcase

  else begin
  count_next=counter;
  end

  

  always(posedge clk or posedge rst_n)begin
  if(rst_n)begin
  counter<=0;
  end
  else begin
  counter<=count_next;
  end
  end
*/