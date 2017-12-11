module play (
	clk,
	rst,
	position,
	mark_enable,
	stab_enable,

	position_open_1,
	position_open_2,
	position_open_3,
	position_open_4,
	position_open_5,
	position_open_6,
	position_open_7,
	position_open_8,
	position_open_9,
	mine_number_1,
	mine_number_2,
	mine_number_3,
	mine_number_4,
	mine_number_5,
	mine_number_6,
	mine_number_7,
	mine_number_8,
	mine_number_9,
	select,
	result_o,
	done
);

	//=======in/out declaration=======================
	input	clk,rst;
	input	[5:0]position;
	input	mark_enable, stab_enable;
	output reg [1:0]result_o;						// 01:die 10:win
	output reg [5:0]position_open_1,position_open_2,position_open_3,position_open_4,position_open_5,position_open_6,position_open_7,position_open_8,position_open_9;
	output reg [3:0]mine_number_1, mine_number_2, mine_number_3, mine_number_4, mine_number_5, mine_number_6, mine_number_7, mine_number_8, mine_number_9;
	output reg [1:0]select;
	output reg done;
	//=======reg/wire declaration=====================

	reg [3:0]time_9;
	wire [5:0] mine_position_1, mine_position_2, mine_position_3, mine_position_4, mine_position_5;
	
	reg [1:0]result;								//	00:continue	01:die 10:win
	reg [35:0]cell_number;
	wire play_enable;
	wire [1:0]mark_and_stab;
	reg [4:0]number;
	reg [35:0] cell_stab, cell_mark;
	reg [35:0] cell_stab_next, cell_mark_next;
	reg [5:0]position_1,position_2,position_3,position_4,position_6,position_7,position_8,position_9;
	wire [35:0] cell_mine;
	wire [2:0] cell_number_1, cell_number_2, cell_number_3, cell_number_4, cell_number_5, cell_number_6, cell_number_7, cell_number_8, cell_number_9, cell_number_ex;
	reg [5:0] position_take_1, position_take_2, position_take_3, position_take_4, position_take_5, position_take_6, position_take_7, position_take_8, position_take_9, position_take_ex;
	reg [5:0] position_take_next_1, position_take_next_2, position_take_next_3, position_take_next_4, position_take_next_5, position_take_next_6, position_take_next_7, position_take_next_8, position_take_next_9;
	reg [5:0] position_save_1, position_save_2, position_save_3, position_save_4, position_save_5, position_save_6, position_save_7, position_save_8, position_save_9;
	
	setmine setmine_1(clk, rst, cell_mine, play_enable);
	count_mine count_mine_1 (rst, clk, cell_mine, position_take_1, cell_number_1);
	count_mine count_mine_2 (rst, clk, cell_mine, position_take_2, cell_number_2);
	count_mine count_mine_3 (rst, clk, cell_mine, position_take_3, cell_number_3);
	count_mine count_mine_4 (rst, clk, cell_mine, position_take_4, cell_number_4);
	count_mine count_mine_5 (rst, clk, cell_mine, position_take_5, cell_number_5);
	count_mine count_mine_6 (rst, clk, cell_mine, position_take_6, cell_number_6);
	count_mine count_mine_7 (rst, clk, cell_mine, position_take_7, cell_number_7);
	count_mine count_mine_8 (rst, clk, cell_mine, position_take_8, cell_number_8);
	count_mine count_mine_9 (rst, clk, cell_mine, position_take_9, cell_number_9);
	count_mine count_mine_ex (rst, clk, cell_mine, position_take_ex, cell_number_ex);
	findmine  findmine_1(clk, rst, play_enable, cell_mine, mine_position_1, mine_position_2, mine_position_3, mine_position_4, mine_position_5);
	
	reg [2:0] control;				// 00:4個 	01:6個 	10:9個		11:1個
	wire play_now;

	assign mark_and_stab = { mark_enable , stab_enable };
	assign play_now = play_enable && ~result_o[1] && ~result_o[0];

//=======combinational part=======================
	always@(*)		//mark and stab
	begin
	
		cell_stab_next = cell_stab;
		cell_mark_next = cell_mark;
		control = select;
		result = result_o;
		position_take_next_1 = position_take_1;
		position_take_next_2 = position_take_2;
		position_take_next_3 = position_take_3;
		position_take_next_4 = position_take_4;
		position_take_next_5 = position_take_5;
		position_take_next_6 = position_take_6;
		position_take_next_7 = position_take_7;
		position_take_next_8 = position_take_8;
		position_take_next_9 = position_take_9;
		position_take_ex = position;
		if (play_now)
		begin

		
		case (mark_and_stab)
			2'b01:begin					// mark=0 stab=1
				if (~cell_stab[position] && ~cell_mark[position])
				begin
			
					
					if (cell_mine[position])
					begin
						cell_stab_next[position] = 1;
						cell_mark_next = cell_mark;
						result = 2'b01;
						control = 2'b11;
						position_take_next_1 = position_take_1;
						position_take_next_2 = position_take_2;
						position_take_next_3 = position_take_3;
						position_take_next_4 = position_take_4;
						position_take_next_5 = position_take_5;
						position_take_next_6 = position_take_6;
						position_take_next_7 = position_take_7;
						position_take_next_8 = position_take_8;
						position_take_next_9 = position_take_9;
					end

					else if( ~cell_mine[position]  && (cell_number_ex[2] || cell_number_ex[1] || cell_number_ex[0] )  )
					begin
						control = 2'b11;
						
						cell_stab_next[position] = 1;
						cell_mark_next = cell_mark;
						result = 2'b00;
						position_take_next_1 = position;
						position_take_next_2 = position_take_2;
						position_take_next_3 = position_take_3;
						position_take_next_4 = position_take_4;
						position_take_next_5 = position_take_5;
						position_take_next_6 = position_take_6;
						position_take_next_7 = position_take_7;
						position_take_next_8 = position_take_8;
						position_take_next_9 = position_take_9;

					end

					else
					begin
						cell_stab_next[position] = 1;
						cell_mark_next = cell_mark;
						result = 2'b00;

						case (position)
							6'd0:
							begin
								control = 2'b00;
								position_take_next_1 = 6'd0;
								position_take_next_2 = 6'd1;
								position_take_next_3 = 6'd6;
								position_take_next_4 = 6'd7;
								position_take_next_5 = 6'd0;
								position_take_next_6 = 6'd0;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							
							6'd1:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd0;
								position_take_next_2 = 6'd1;
								position_take_next_3 = 6'd2;
								position_take_next_4 = 6'd6;
								position_take_next_5 = 6'd7;
								position_take_next_6 = 6'd8;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							6'd2:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd1;
								position_take_next_2 = 6'd2;
								position_take_next_3 = 6'd3;
								position_take_next_4 = 6'd7;
								position_take_next_5 = 6'd8;
								position_take_next_6 = 6'd9;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							6'd3:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd2;
								position_take_next_2 = 6'd3;
								position_take_next_3 = 6'd4;
								position_take_next_4 = 6'd8;
								position_take_next_5 = 6'd9;
								position_take_next_6 = 6'd10;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							6'd4:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd3;
								position_take_next_2 = 6'd4;
								position_take_next_3 = 6'd5;
								position_take_next_4 = 6'd9;
								position_take_next_5 = 6'd10;
								position_take_next_6 = 6'd11;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
								
							end
							6'd5:
							begin
								control = 2'b00;
								position_take_next_1 = 6'd4;
								position_take_next_2 = 6'd5;
								position_take_next_3 = 6'd10;
								position_take_next_4 = 6'd11;
								position_take_next_5 = 6'd10;
								position_take_next_6 = 6'd11;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							6'd6:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd0;
								position_take_next_2 = 6'd1;
								position_take_next_3 = 6'd6;
								position_take_next_4 = 6'd7;
								position_take_next_5 = 6'd12;
								position_take_next_6 = 6'd13;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							6'd7:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd0;
								position_take_next_2 = 6'd1;
								position_take_next_3 = 6'd2;
								position_take_next_4 = 6'd6;
								position_take_next_5 = 6'd7;
								position_take_next_6 = 6'd8;
								position_take_next_7 = 6'd12;
								position_take_next_8 = 6'd13;
								position_take_next_9 = 6'd14;
							end
							6'd8:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd1;
								position_take_next_2 = 6'd2;
								position_take_next_3 = 6'd3;
								position_take_next_4 = 6'd7;
								position_take_next_5 = 6'd8;
								position_take_next_6 = 6'd9;
								position_take_next_7 = 6'd13;
								position_take_next_8 = 6'd14;
								position_take_next_9 = 6'd15;
							end
							6'd9:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd2;
								position_take_next_2 = 6'd3;
								position_take_next_3 = 6'd4;
								position_take_next_4 = 6'd8;
								position_take_next_5 = 6'd9;
								position_take_next_6 = 6'd10;
								position_take_next_7 = 6'd14;
								position_take_next_8 = 6'd15;
								position_take_next_9 = 6'd16;
							end
							6'd10:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd3;
								position_take_next_2 = 6'd4;
								position_take_next_3 = 6'd5;
								position_take_next_4 = 6'd9;
								position_take_next_5 = 6'd10;
								position_take_next_6 = 6'd11;
								position_take_next_7 = 6'd15;
								position_take_next_8 = 6'd16;
								position_take_next_9 = 6'd17;
							end
							6'd11:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd4;
								position_take_next_2 = 6'd5;
								position_take_next_3 = 6'd10;
								position_take_next_4 = 6'd11;
								position_take_next_5 = 6'd16;
								position_take_next_6 = 6'd17;
								position_take_next_7 = 6'd15;
								position_take_next_8 = 6'd16;
								position_take_next_9 = 6'd17;
							end
							6'd12:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd6;
								position_take_next_2 = 6'd7;
								position_take_next_3 = 6'd12;
								position_take_next_4 = 6'd13;
								position_take_next_5 = 6'd18;
								position_take_next_6 = 6'd19;
								position_take_next_7 = 6'd15;
								position_take_next_8 = 6'd16;
								position_take_next_9 = 6'd17;
							end
							6'd13:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd6;
								position_take_next_2 = 6'd7;
								position_take_next_3 = 6'd8;
								position_take_next_4 = 6'd12;
								position_take_next_5 = 6'd13;
								position_take_next_6 = 6'd14;
								position_take_next_7 = 6'd18;
								position_take_next_8 = 6'd19;
								position_take_next_9 = 6'd20;
							end
							6'd14:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd7;
								position_take_next_2 = 6'd8;
								position_take_next_3 = 6'd9;
								position_take_next_4 = 6'd13;
								position_take_next_5 = 6'd14;
								position_take_next_6 = 6'd15;
								position_take_next_7 = 6'd19;
								position_take_next_8 = 6'd20;
								position_take_next_9 = 6'd21;
							end
							6'd15:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd8;
								position_take_next_2 = 6'd9;
								position_take_next_3 = 6'd10;
								position_take_next_4 = 6'd14;
								position_take_next_5 = 6'd15;
								position_take_next_6 = 6'd16;
								position_take_next_7 = 6'd20;
								position_take_next_8 = 6'd21;
								position_take_next_9 = 6'd22;
							end
							6'd16:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd9;
								position_take_next_2 = 6'd10;
								position_take_next_3 = 6'd11;
								position_take_next_4 = 6'd15;
								position_take_next_5 = 6'd16;
								position_take_next_6 = 6'd17;
								position_take_next_7 = 6'd21;
								position_take_next_8 = 6'd22;
								position_take_next_9 = 6'd23;
							end
							6'd17:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd10;
								position_take_next_2 = 6'd11;
								position_take_next_3 = 6'd16;
								position_take_next_4 = 6'd17;
								position_take_next_5 = 6'd22;
								position_take_next_6 = 6'd23;
								position_take_next_7 = 6'd21;
								position_take_next_8 = 6'd22;
								position_take_next_9 = 6'd23;
							end
							6'd18:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd12;
								position_take_next_2 = 6'd13;
								position_take_next_3 = 6'd18;
								position_take_next_4 = 6'd19;
								position_take_next_5 = 6'd24;
								position_take_next_6 = 6'd25;
								position_take_next_7 = 6'd21;
								position_take_next_8 = 6'd22;
								position_take_next_9 = 6'd23;
							end
							6'd19:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd12;
								position_take_next_2 = 6'd13;
								position_take_next_3 = 6'd14;
								position_take_next_4 = 6'd18;
								position_take_next_5 = 6'd19;
								position_take_next_6 = 6'd20;
								position_take_next_7 = 6'd24;
								position_take_next_8 = 6'd25;
								position_take_next_9 = 6'd26;
							end
							6'd20:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd13;
								position_take_next_2 = 6'd14;
								position_take_next_3 = 6'd15;
								position_take_next_4 = 6'd19;
								position_take_next_5 = 6'd20;
								position_take_next_6 = 6'd21;
								position_take_next_7 = 6'd25;
								position_take_next_8 = 6'd26;
								position_take_next_9 = 6'd27;
							end
							6'd21:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd14;
								position_take_next_2 = 6'd15;
								position_take_next_3 = 6'd16;
								position_take_next_4 = 6'd20;
								position_take_next_5 = 6'd21;
								position_take_next_6 = 6'd22;
								position_take_next_7 = 6'd26;
								position_take_next_8 = 6'd27;
								position_take_next_9 = 6'd28;
							end
							6'd22:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd15;
								position_take_next_2 = 6'd16;
								position_take_next_3 = 6'd17;
								position_take_next_4 = 6'd21;
								position_take_next_5 = 6'd22;
								position_take_next_6 = 6'd23;
								position_take_next_7 = 6'd27;
								position_take_next_8 = 6'd28;
								position_take_next_9 = 6'd29;
							end
							6'd23:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd16;
								position_take_next_2 = 6'd17;
								position_take_next_3 = 6'd22;
								position_take_next_4 = 6'd23;
								position_take_next_5 = 6'd28;
								position_take_next_6 = 6'd29;
								position_take_next_7 = 6'd27;
								position_take_next_8 = 6'd28;
								position_take_next_9 = 6'd29;
							end
							6'd24:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd18;
								position_take_next_2 = 6'd19;
								position_take_next_3 = 6'd24;
								position_take_next_4 = 6'd25;
								position_take_next_5 = 6'd30;
								position_take_next_6 = 6'd31;
								position_take_next_7 = 6'd27;
								position_take_next_8 = 6'd28;
								position_take_next_9 = 6'd29;
							end
							6'd25:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd18;
								position_take_next_2 = 6'd19;
								position_take_next_3 = 6'd20;
								position_take_next_4 = 6'd24;
								position_take_next_5 = 6'd25;
								position_take_next_6 = 6'd26;
								position_take_next_7 = 6'd30;
								position_take_next_8 = 6'd31;
								position_take_next_9 = 6'd32;
							end
							6'd26:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd19;
								position_take_next_2 = 6'd20;
								position_take_next_3 = 6'd21;
								position_take_next_4 = 6'd25;
								position_take_next_5 = 6'd26;
								position_take_next_6 = 6'd27;
								position_take_next_7 = 6'd31;
								position_take_next_8 = 6'd32;
								position_take_next_9 = 6'd33;
							end
							6'd27:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd20;
								position_take_next_2 = 6'd21;
								position_take_next_3 = 6'd22;
								position_take_next_4 = 6'd26;
								position_take_next_5 = 6'd27;
								position_take_next_6 = 6'd28;
								position_take_next_7 = 6'd32;
								position_take_next_8 = 6'd33;
								position_take_next_9 = 6'd34;
							end
							6'd28:
							begin
								control = 2'b10;
								position_take_next_1 = 6'd21;
								position_take_next_2 = 6'd22;
								position_take_next_3 = 6'd23;
								position_take_next_4 = 6'd27;
								position_take_next_5 = 6'd28;
								position_take_next_6 = 6'd29;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd29:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd22;
								position_take_next_2 = 6'd23;
								position_take_next_3 = 6'd28;
								position_take_next_4 = 6'd29;
								position_take_next_5 = 6'd34;
								position_take_next_6 = 6'd35;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd30:
							begin
								control = 2'b00;
								position_take_next_1 = 6'd24;
								position_take_next_2 = 6'd25;
								position_take_next_3 = 6'd30;
								position_take_next_4 = 6'd31;
								position_take_next_5 = 6'd34;
								position_take_next_6 = 6'd35;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd31:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd24;
								position_take_next_2 = 6'd25;
								position_take_next_3 = 6'd26;
								position_take_next_4 = 6'd30;
								position_take_next_5 = 6'd31;
								position_take_next_6 = 6'd32;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd32:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd25;
								position_take_next_2 = 6'd26;
								position_take_next_3 = 6'd27;
								position_take_next_4 = 6'd31;
								position_take_next_5 = 6'd32;
								position_take_next_6 = 6'd33;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd33:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd26;
								position_take_next_2 = 6'd27;
								position_take_next_3 = 6'd28;
								position_take_next_4 = 6'd32;
								position_take_next_5 = 6'd33;
								position_take_next_6 = 6'd34;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd34:
							begin
								control = 2'b01;
								position_take_next_1 = 6'd27;
								position_take_next_2 = 6'd28;
								position_take_next_3 = 6'd29;
								position_take_next_4 = 6'd33;
								position_take_next_5 = 6'd34;
								position_take_next_6 = 6'd35;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							6'd35:
							begin
								control = 2'b00;
								position_take_next_1 = 6'd28;
								position_take_next_2 = 6'd29;
								position_take_next_3 = 6'd34;
								position_take_next_4 = 6'd35;
								position_take_next_5 = 6'd34;
								position_take_next_6 = 6'd35;
								position_take_next_7 = 6'd33;
								position_take_next_8 = 6'd34;
								position_take_next_9 = 6'd35;
							end
							default:
							begin
								control = 2'b00;
								position_take_next_1 = 6'd0;
								position_take_next_2 = 6'd0;
								position_take_next_3 = 6'd0;
								position_take_next_4 = 6'd0;
								position_take_next_5 = 6'd0;
								position_take_next_6 = 6'd0;
								position_take_next_7 = 6'd0;
								position_take_next_8 = 6'd0;
								position_take_next_9 = 6'd0;
							end
							endcase
						
					end
				end
				else
				begin
				
					cell_stab_next = cell_stab;
					cell_mark_next = cell_mark;
					control = select;
					result = result_o;
					position_take_next_1 = position_take_1;
					position_take_next_2 = position_take_2;
					position_take_next_3 = position_take_3;
					position_take_next_4 = position_take_4;
					position_take_next_5 = position_take_5;
					position_take_next_6 = position_take_6;
					position_take_next_7 = position_take_7;
					position_take_next_8 = position_take_8;
					position_take_next_9 = position_take_9;
				
				end
				end
					
			2'b10:begin					// mark=1 stab=0
			
					cell_stab_next = cell_stab;
					cell_mark_next = cell_mark;
					control = select;
					result = result_o;
					position_take_next_1 = position_take_1;
					position_take_next_2 = position_take_2;
					position_take_next_3 = position_take_3;
					position_take_next_4 = position_take_4;
					position_take_next_5 = position_take_5;
					position_take_next_6 = position_take_6;
					position_take_next_7 = position_take_7;
					position_take_next_8 = position_take_8;
					position_take_next_9 = position_take_9;
			
			
				if (~cell_stab[position])
				begin
					if(~cell_mark[position])
					begin
					control = 2'b11;
					position_take_next_1 = position;
					position_take_next_2 = 6'd0;
					position_take_next_3 = 6'd0;
					position_take_next_4 = 6'd0;
					position_take_next_5 = 6'd0;
					position_take_next_6 = 6'd0;
					position_take_next_7 = 6'd0;
					position_take_next_8 = 6'd0;
					position_take_next_9 = 6'd0;
					cell_stab_next[position] = 0;
					cell_mark_next[position] = 1;
					result = 2'b00;
					end
					
					else
					begin
					control = 2'b11;
					position_take_next_1 = position;
					position_take_next_2 = 6'd0;
					position_take_next_3 = 6'd0;
					position_take_next_4 = 6'd0;
					position_take_next_5 = 6'd0;
					position_take_next_6 = 6'd0;
					position_take_next_7 = 6'd0;
					position_take_next_8 = 6'd0;
					position_take_next_9 = 6'd0;
					cell_stab_next[position] = 0;
					cell_mark_next[position] = 0;
					result = 2'b00;
					
					
					end
					
					
				end
				
				else
				begin
				
					cell_stab_next = cell_stab;
					cell_mark_next = cell_mark;
					control = select;
					result = result_o;
					position_take_next_1 = position_take_1;
					position_take_next_2 = position_take_2;
					position_take_next_3 = position_take_3;
					position_take_next_4 = position_take_4;
					position_take_next_5 = position_take_5;
					position_take_next_6 = position_take_6;
					position_take_next_7 = position_take_7;
					position_take_next_8 = position_take_8;
					position_take_next_9 = position_take_9;
				
				
				end
				
				end
			
			default:begin

					cell_stab_next = cell_stab;
					cell_mark_next = cell_mark;
					control = select;
					result = result_o;
					position_take_next_1 = position_take_1;
					position_take_next_2 = position_take_2;
					position_take_next_3 = position_take_3;
					position_take_next_4 = position_take_4;
					position_take_next_5 = position_take_5;
					position_take_next_6 = position_take_6;
					position_take_next_7 = position_take_7;
					position_take_next_8 = position_take_8;
					position_take_next_9 = position_take_9;
					
					
					
				end
			endcase
			

			if (cell_mark[mine_position_1] && cell_mark[mine_position_2] && cell_mark[mine_position_3] && cell_mark[mine_position_4] && cell_mark[mine_position_5])
			result = 2'b10;
			
			end
			
	end
		

	
//=======sequential part==========================

	always@(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			position_open_1 <= 6'd0;
			position_open_2 <= 6'd0;
			position_open_3 <= 6'd0;
			position_open_4 <= 6'd0;
			position_open_5 <= 6'd0;
			position_open_6 <= 6'd0;
			position_open_7 <= 6'd0;
			position_open_8 <= 6'd0;
			position_open_9 <= 6'd0;
			
			mine_number_1 <= 4'b0000;
			mine_number_2 <= 4'b0000;
			mine_number_3 <= 4'b0000;
			mine_number_4 <= 4'b0000;
			mine_number_5 <= 4'b0000;
			mine_number_6 <= 4'b0000;
			mine_number_7 <= 4'b0000;
			mine_number_8 <= 4'b0000;
			mine_number_9 <= 4'b0000;
			
			time_9 <= 4'd0;
			select <= 2'b00;
			done <= 1'b0;
			
			cell_mark <= 36'd0;
			cell_stab <= 36'd0;
			
			result_o <= 2'b00;

			
		end
		
		else if (time_9 == 4'd0)
		begin
		
			cell_stab <= cell_stab_next;
			cell_mark <= cell_mark_next;
			
			position_open_1 <= position_take_next_1;
			position_open_2 <= position_take_next_2;
			position_open_3 <= position_take_next_3;
			position_open_4 <= position_take_next_4;
			position_open_5 <= position_take_next_5;
			position_open_6 <= position_take_next_6;
			position_open_7 <= position_take_next_7;
			position_open_8 <= position_take_next_8;
			position_open_9 <= position_take_next_9;
			
			
			
			position_take_1 <= position_take_next_1;
			position_take_2 <= position_take_next_2;
			position_take_3 <= position_take_next_3;
			position_take_4 <= position_take_next_4;
			position_take_5 <= position_take_next_5;
			position_take_6 <= position_take_next_6;
			position_take_7 <= position_take_next_7;
			position_take_8 <= position_take_next_8;
			position_take_9 <= position_take_next_9;
			
			
			
			mine_number_1 <= (cell_mark[position_take_1])? 4'b0001 : (cell_mine[position_take_1]) ? 4'b0000 : {1'b1, cell_number_1};
			mine_number_2 <= (cell_mark[position_take_2])? 4'b0001 : (cell_mine[position_take_2]) ? 4'b0000 : {1'b1, cell_number_2};
			mine_number_3 <= (cell_mark[position_take_3])? 4'b0001 : (cell_mine[position_take_3]) ? 4'b0000 : {1'b1, cell_number_3};
			mine_number_4 <= (cell_mark[position_take_4])? 4'b0001 : (cell_mine[position_take_4]) ? 4'b0000 : {1'b1, cell_number_4};
			mine_number_5 <= (cell_mark[position_take_5])? 4'b0001 : (cell_mine[position_take_5]) ? 4'b0000 : {1'b1, cell_number_5};
			mine_number_6 <= (cell_mark[position_take_6])? 4'b0001 : (cell_mine[position_take_6]) ? 4'b0000 : {1'b1, cell_number_6};
			mine_number_7 <= (cell_mark[position_take_7])? 4'b0001 : (cell_mine[position_take_7]) ? 4'b0000 : {1'b1, cell_number_7};
			mine_number_8 <= (cell_mark[position_take_8])? 4'b0001 : (cell_mine[position_take_8]) ? 4'b0000 : {1'b1, cell_number_8};
			mine_number_9 <= (cell_mark[position_take_9])? 4'b0001 : (cell_mine[position_take_9]) ? 4'b0000 : {1'b1, cell_number_9};
			
			time_9 <= time_9 +4'd1;
			select <= control;
			done <= 1'b1;
			result_o <= result;
		
		end
		
		else
		begin
			position_open_1 <= position_take_next_1;
			position_open_2 <= position_take_next_2;
			position_open_3 <= position_take_next_3;
			position_open_4 <= position_take_next_4;
			position_open_5 <= position_take_next_5;
			position_open_6 <= position_take_next_6;
			position_open_7 <= position_take_next_7;
			position_open_8 <= position_take_next_8;
			position_open_9 <= position_take_next_9;
			
			
			
			position_take_1 <= position_take_next_1;
			position_take_2 <= position_take_next_2;
			position_take_3 <= position_take_next_3;
			position_take_4 <= position_take_next_4;
			position_take_5 <= position_take_next_5;
			position_take_6 <= position_take_next_6;
			position_take_7 <= position_take_next_7;
			position_take_8 <= position_take_next_8;
			position_take_9 <= position_take_next_9;
			
			
			
			mine_number_1 <= (cell_mark[position_take_1])? 4'b0001 : (cell_mine[position_take_1]) ? 4'b0000 : {1'b1, cell_number_1};
			mine_number_2 <= (cell_mark[position_take_2])? 4'b0001 : (cell_mine[position_take_2]) ? 4'b0000 : {1'b1, cell_number_2};
			mine_number_3 <= (cell_mark[position_take_3])? 4'b0001 : (cell_mine[position_take_3]) ? 4'b0000 : {1'b1, cell_number_3};
			mine_number_4 <= (cell_mark[position_take_4])? 4'b0001 : (cell_mine[position_take_4]) ? 4'b0000 : {1'b1, cell_number_4};
			mine_number_5 <= (cell_mark[position_take_5])? 4'b0001 : (cell_mine[position_take_5]) ? 4'b0000 : {1'b1, cell_number_5};
			mine_number_6 <= (cell_mark[position_take_6])? 4'b0001 : (cell_mine[position_take_6]) ? 4'b0000 : {1'b1, cell_number_6};
			mine_number_7 <= (cell_mark[position_take_7])? 4'b0001 : (cell_mine[position_take_7]) ? 4'b0000 : {1'b1, cell_number_7};
			mine_number_8 <= (cell_mark[position_take_8])? 4'b0001 : (cell_mine[position_take_8]) ? 4'b0000 : {1'b1, cell_number_8};
			mine_number_9 <= (cell_mark[position_take_9])? 4'b0001 : (cell_mine[position_take_9]) ? 4'b0000 : {1'b1, cell_number_9};
		
			cell_stab <= cell_stab_next;
			cell_mark <= cell_mark_next;
			select <= control;
			result_o <= result;
			
			done <= 1'b0;
			if (time_9 == 4'd10)
				time_9 <= 4'd0;
				
			else
				begin
				time_9 <= time_9 + 1'b1;
				end
		
		end
	
	end
	
endmodule