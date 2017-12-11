
module setmine (clk,rst_n,cell_mine,play_enable);

input clk;
input rst_n;

output play_enable;
output  reg [35:0]cell_mine;

reg [35:0]cell_mine_next; 

reg play_enable_r,play_enable_w; 

wire [12:0] bit_x,bit_y;
reg [2:0] x_pos,y_pos;
reg [6:0] pos;
wire [2:0] mine_num;
reg [2:0] counter,count_next;
integer i;

assign  mine_num=3'b101 ; //
assign play_enable=play_enable_r;

	xlfsr XLFSR(.clk(clk),.rst_n(rst_n),.out(bit_x));
	ylfsr YLFSR(.clk(clk),.rst_n(rst_n),.out(bit_y));



//combinational code need to be modified and add countmine to here
always@(*)begin

	x_pos=bit_x[2:0];
	y_pos=bit_y[2:0];
	pos=x_pos*3'b110 + y_pos; //

	if(counter!=mine_num)begin

	cell_mine_next=cell_mine;

	if ((x_pos<3'b110)&(y_pos<3'b110)&(cell_mine_next[pos]!=1)) begin
	play_enable_w=0;
	cell_mine_next[pos]=1 ; //

	count_next=counter+1;
	
	end

	else begin
		play_enable_w=0;
		count_next=counter;
		cell_mine_next=cell_mine;
	end
     
	end

	else begin
		play_enable_w=1;
		count_next=counter;
		cell_mine_next=cell_mine;
		
		end

	end



	always@(posedge clk or posedge rst_n) begin
	if(rst_n)begin
	for(i=0;i<36;i=i+1)
	cell_mine[i]<=0;
	play_enable_r<=0;
    counter<=0;
    end
    else begin
    play_enable_r<=play_enable_w;
    counter<=count_next;
    cell_mine<=cell_mine_next;
	end
	end

	endmodule


  module xlfsr (
    input clk,
    input rst_n,
    output [12:0] out
    );
 
reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts
wire feedback;

assign feedback = random[11] ^ random[10] ^ random[7] ^ random[3] ; 
 
always @ (posedge clk or posedge rst_n)
begin
 if (rst_n)
 begin
  random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end
 
always @ (*)
begin
 random_next = random; //default state stays the same
   
  random_next = {random[11:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;
 
 if (count_next == 13)
 begin
  count_next = 0;
  random_done = random; //assign the random number to output after 13 shifts
 end

 else begin
 	count_next=count;
 	random_done=random;
 end


  
end
 
 
	assign out = random_done;
endmodule



 module ylfsr (
    input clk,
    input rst_n,
    output [12:0] out
    );
 
reg [12:0] random, random_next, random_done;
reg [3:0] count, count_next; //to keep track of the shifts
wire feedback;

assign feedback = random[12] ^ random[10] ^ random[9] ^ random[7]; 
 
always @ (posedge clk or posedge rst_n)
begin
 if (rst_n)
 begin
  random <= 13'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
  
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end
 
always @ (*)
begin
 random_next = random; //default state stays the same
   
  random_next = {random[11:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;
 
 if (count_next == 13)
 begin
  count_next = 0;
  random_done = random; //assign the random number to output after 13 shifts
 end

 else begin
 	count_next=0;
 	random_done=random;
 end

  
end
 
 
	assign out = random_done;
endmodule



	

