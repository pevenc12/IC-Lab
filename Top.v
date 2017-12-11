`include "play.v"
`include "setmine.v"
`include "findmine.v"
`include "countmine.v"

module Top
(
	clk,
	rst,
	mark,
	stab,
	up,
	down,
	left,	
	right,

	pointer,
	position,
	mine,
	result
);

input clk;
input rst;
input mark;
input stab;
input up;
input down;
input left;
input right;	

output [5:0] pointer;
output reg [5:0] position;
output reg [3:0] mine;
output [1:0] result;


reg mark_enable;
reg stab_enable;

reg [2:0] pos_row, next_row;
reg [2:0] pos_column, next_column;


wire [5:0] pos;


wire [5:0] position1, position2, position3, position4, position5, position6, position7, position8, position9;
wire [3:0] mine1, mine2, mine3, mine4, mine5, mine6, mine7, mine8, mine9;
reg [3:0]mine_r;
reg [5:0] position_r;
wire [1:0] select;
reg [3:0] number;
reg [3:0] count, next_count;
wire done;
wire [3:0] direction;

reg up_enable, down_enable, left_enable, right_enable;
reg move, move_save;

play play0
(	.rst(rst),
	.clk(clk),
	.position(pos),
	.mark_enable(mark_enable),
	.stab_enable(stab_enable),

	.position_open_1(position1),
	.position_open_2(position2),
	.position_open_3(position3),
	.position_open_4(position4),
	.position_open_5(position5),
	.position_open_6(position6),
	.position_open_7(position7),
	.position_open_8(position8),
	.position_open_9(position9),
	.mine_number_1(mine1),
	.mine_number_2(mine2),
	.mine_number_3(mine3),
	.mine_number_4(mine4),
	.mine_number_5(mine5),
	.mine_number_6(mine6),
	.mine_number_7(mine7),
	.mine_number_8(mine8),
	.mine_number_9(mine9),
	.select(select),
	.done(done),
	.result_o(result)
);



assign pointer = pos;

assign pos = pos_row * 6 + pos_column; 

assign direction = {up_enable, down_enable, left_enable, right_enable};




always @(*) begin
	next_row = pos_row; next_column = pos_column;
	case(direction)
	4'b1000:begin
			if(~|pos_row)
				next_row = 3'd0;
			else
				next_row = pos_row - 1'd1;
			end
	4'b0100:begin
			if(pos_row[2] && ~pos_row[1] && pos_row[0])
				next_row = 3'd5;
			else
				next_row = pos_row + 1'd1;
			end
	4'b0010:begin
			if(~|pos_column)
				next_column = 3'd0;
			else
				next_column = pos_column - 1'd1;
			end

	4'b0001:begin
			if(pos_column[2] && ~pos_column[1] && pos_column[0])
				next_column = 3'd5;
			else
				next_column = pos_column + 1'd1;
			end
	default: begin next_row = pos_row; next_column = pos_column; end
	endcase
end 


always @(*) begin
	case(select)
	2'b00: number = 4'd4;
	2'b01: number = 4'd6;
	2'b10: number = 4'd9;
	2'b11: number = 4'd1;
	endcase
end



always @(*)begin
	case(count)
	4'd1: position_r = position1;
	4'd2: position_r = position2;
	4'd3: position_r = position3;
	4'd4: position_r = position4;
	4'd5: position_r = position5;
	4'd6: position_r = position6;
	4'd7: position_r = position7;
	4'd8: position_r = position8;
	4'd9: position_r = position9;
	default: position_r = position1;
	endcase
end

always @(*)begin
	case(count)
	4'd1: mine_r = mine1;
	4'd2: mine_r = mine2;
	4'd3: mine_r = mine3;
	4'd4: mine_r = mine4;
	4'd5: mine_r = mine5;
	4'd6: mine_r = mine6;
	4'd7: mine_r = mine7;
	4'd8: mine_r = mine8;
	4'd9: mine_r = mine9;
	default: mine_r = mine;
	endcase
end

always @(*) begin
	if(~|count && done)
		next_count = 4'b1;
	else if(count == number)
		next_count = 4'b0;
	else 
		next_count = count + 4'b1;
end


always @(posedge done or posedge clk) begin
	if(done) 
	count <= 4'b0;
	else 
	count <= next_count;
end

always @(*) begin
if(up_enable || down_enable || left_enable || right_enable ||mark_enable)
	move = 1'b1;
else if(~up && ~down && ~left && ~right && ~mark )
	move = 1'b0;
else 
	move = move_save;
end
	
always @(posedge clk or posedge rst)begin
	if(rst) begin
	mark_enable <= 1'b0;
	stab_enable <= 1'b0;
	mine <= 4'b0;
	position <= 6'b0;
	pos_column <= 3'd0;
	pos_row <= 3'd0;
	up_enable <= 1'b0;
	down_enable <= 1'b0;
	left_enable <= 1'b0;
	right_enable <= 1'b0;
	move_save <= 1'b0;
	end
	else begin
	pos_column <= next_column;
	pos_row <= next_row;
	mine <= mine_r;
	position <= position_r;
	mark_enable <= mark;
	stab_enable <= stab;
	up_enable <= up;
	down_enable <= down;
	left_enable <= left;
	right_enable <= right;
	move_save <= move;
	if(move) begin
		up_enable <= 1'b0;
		down_enable <= 1'b0;
		left_enable <= 1'b0;
		right_enable <= 1'b0;
		mark_enable <= 1'b0;
	end
end
end

endmodule









