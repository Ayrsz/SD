module helloworld(
	output reg [7:0] data,
	output reg RW, RS, EN, 
	input clk
);

initial begin
	RS = 0;
	RW = 0;
	EN = 1;
end

parameter WAIT = 0, WRITE = 1, FINAL = 10;
reg [31:0] counter = 0;
parameter ONEMS = 50000, HALFMS = 25000;
reg [1:0] state = WRITE;
reg [7:0] instructions = 0;

always @(posedge clk) begin
	case (state)
		WRITE:begin
			if (counter == ONEMS) begin
				counter <= 0;
				state <= WAIT;
				EN <= 0;
			end
			else counter <= counter + 1;
		end
		WAIT:begin
			if (counter == HALFMS) begin
				counter <= 0;
				state <= WRITE;
				EN <= 1;
				if (instructions < FINAL) instructions <= instructions + 1;
			end
			else counter <= counter + 1;
		end
	endcase
end


always @(posedge clk) begin
	case (instructions) 
		0: begin data <= 8'b00111000; RS <= 0; end
		1: begin data <= 8'b00001100; RS <= 0; end
		2: begin data <= 8'b00000001; RS <= 0; end
		3: begin data <= 8'b10000000; RS <= 0; end
		4: begin data <= 8'h48; RS <= 1; end // H
		5: begin data <= 8'h65; RS <= 1; end // e
		6: begin data <= 8'b11000000; RS <= 0; end
		7: begin data <= 8'h57; RS <= 1; end // W
		8: begin data <= 8'h6F; RS <= 1; end // o
		default: begin data <= 8'b10000000; RS <= 0; end
	endcase
end

endmodule