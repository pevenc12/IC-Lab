module count_mine(rst_n, clk,cell_mine,position,cell_number);

	input rst_n;
	input clk;
	input [35:0]cell_mine;
	input [5:0]position;
	output [2:0]cell_number;

	reg [2:0]cell_number_r;
	reg [2:0]cell_number_w;
	reg [5:0]next_position;

	assign cell_number = cell_number_r;


	always @(*) begin
	
	case(position)
	6'b000000:cell_number_w=cell_mine[1]+cell_mine[6]+cell_mine[7];

	6'b000001:cell_number_w=cell_mine[0]+cell_mine[2]+cell_mine[6]+cell_mine[7]+cell_mine[8];
	6'b000010:cell_number_w=cell_mine[1]+cell_mine[3]+cell_mine[7]+cell_mine[8]+cell_mine[9];
	6'b000011:cell_number_w=cell_mine[2]+cell_mine[4]+cell_mine[8]+cell_mine[9]+cell_mine[10];
	6'b000100:cell_number_w=cell_mine[3]+cell_mine[5]+cell_mine[9]+cell_mine[10]+cell_mine[11];

	6'b000101:cell_number_w=cell_mine[4]+cell_mine[10]+cell_mine[11];

	6'b000110:cell_number_w=cell_mine[0]+cell_mine[1]+cell_mine[7]+cell_mine[12]+cell_mine[13];
	6'b001100:cell_number_w=cell_mine[6]+cell_mine[7]+cell_mine[13]+cell_mine[18]+cell_mine[19];
	6'b010010:cell_number_w=cell_mine[12]+cell_mine[13]+cell_mine[19]+cell_mine[24]+cell_mine[25];
	6'b011000:cell_number_w=cell_mine[18]+cell_mine[19]+cell_mine[25]+cell_mine[30]+cell_mine[31];

	6'b000111:cell_number_w=cell_mine[0]+cell_mine[1]+cell_mine[2]+cell_mine[6]+cell_mine[8]+cell_mine[12]+cell_mine[13]+cell_mine[14];
	6'b001000:cell_number_w=cell_mine[1]+cell_mine[2]+cell_mine[3]+cell_mine[7]+cell_mine[9]+cell_mine[13]+cell_mine[14]+cell_mine[15];
	6'b001001:cell_number_w=cell_mine[2]+cell_mine[3]+cell_mine[14]+cell_mine[8]+cell_mine[10]+cell_mine[14]+cell_mine[15]+cell_mine[16];
	6'b001010:cell_number_w=cell_mine[3]+cell_mine[4]+cell_mine[15]+cell_mine[9]+cell_mine[11]+cell_mine[15]+cell_mine[16]+cell_mine[17];
	
	6'b001101:cell_number_w=cell_mine[6]+cell_mine[7]+cell_mine[8]+cell_mine[12]+cell_mine[14]+cell_mine[18]+cell_mine[19]+cell_mine[20];
	6'b001110:cell_number_w=cell_mine[7]+cell_mine[8]+cell_mine[9]+cell_mine[13]+cell_mine[15]+cell_mine[19]+cell_mine[20]+cell_mine[21];
	6'b001111:cell_number_w=cell_mine[8]+cell_mine[9]+cell_mine[10]+cell_mine[14]+cell_mine[16]+cell_mine[20]+cell_mine[21]+cell_mine[22];
	6'b010000:cell_number_w=cell_mine[9]+cell_mine[10]+cell_mine[11]+cell_mine[15]+cell_mine[17]+cell_mine[21]+cell_mine[22]+cell_mine[23];
	
	6'b010011:cell_number_w=cell_mine[12]+cell_mine[13]+cell_mine[14]+cell_mine[18]+cell_mine[20]+cell_mine[24]+cell_mine[25]+cell_mine[26];
	6'b010100:cell_number_w=cell_mine[13]+cell_mine[14]+cell_mine[15]+cell_mine[19]+cell_mine[21]+cell_mine[25]+cell_mine[26]+cell_mine[27];
	6'b010101:cell_number_w=cell_mine[14]+cell_mine[15]+cell_mine[16]+cell_mine[20]+cell_mine[22]+cell_mine[26]+cell_mine[27]+cell_mine[28];
	6'b010110:cell_number_w=cell_mine[15]+cell_mine[16]+cell_mine[17]+cell_mine[21]+cell_mine[23]+cell_mine[27]+cell_mine[28]+cell_mine[29];
	
	6'b011001:cell_number_w=cell_mine[18]+cell_mine[19]+cell_mine[20]+cell_mine[24]+cell_mine[26]+cell_mine[30]+cell_mine[31]+cell_mine[32];
	6'b011010:cell_number_w=cell_mine[19]+cell_mine[20]+cell_mine[21]+cell_mine[25]+cell_mine[27]+cell_mine[31]+cell_mine[32]+cell_mine[33];
	6'b011011:cell_number_w=cell_mine[20]+cell_mine[21]+cell_mine[22]+cell_mine[26]+cell_mine[28]+cell_mine[32]+cell_mine[33]+cell_mine[34];
	6'b011100:cell_number_w=cell_mine[21]+cell_mine[22]+cell_mine[23]+cell_mine[27]+cell_mine[29]+cell_mine[33]+cell_mine[34]+cell_mine[35];


	6'b001011:cell_number_w=cell_mine[4]+cell_mine[5]+cell_mine[10]+cell_mine[16]+cell_mine[17];
	6'b010001:cell_number_w=cell_mine[10]+cell_mine[11]+cell_mine[16]+cell_mine[22]+cell_mine[23];
	6'b010111:cell_number_w=cell_mine[16]+cell_mine[17]+cell_mine[22]+cell_mine[28]+cell_mine[29];
	6'b011101:cell_number_w=cell_mine[22]+cell_mine[23]+cell_mine[28]+cell_mine[34]+cell_mine[35];

	6'b011110:cell_number_w=cell_mine[24]+cell_mine[25]+cell_mine[31];

    6'b011111:cell_number_w=cell_mine[24]+cell_mine[25]+cell_mine[26]+cell_mine[30]+cell_mine[32];
	6'b100000:cell_number_w=cell_mine[25]+cell_mine[26]+cell_mine[27]+cell_mine[31]+cell_mine[33];
	6'b100001:cell_number_w=cell_mine[26]+cell_mine[27]+cell_mine[28]+cell_mine[32]+cell_mine[34];
	6'b100010:cell_number_w=cell_mine[27]+cell_mine[28]+cell_mine[29]+cell_mine[33]+cell_mine[35];

	6'b100011:cell_number_w=cell_mine[28]+cell_mine[29]+cell_mine[34];

	default:cell_number_w=0;
	endcase	
	
	end

	always @(posedge clk or posedge rst_n) begin
		if (rst_n) begin
			// reset
			cell_number_r<=0;
		end
		else begin
			cell_number_r<=cell_number_w;			
		end
	end
endmodule
