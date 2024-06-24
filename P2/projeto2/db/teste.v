module teste(
	output reg [7:0] data,
	output reg RW, RS, EN, 
   input clk, sinalA, sinalB, button_multiplicao, button_soma, button_subtracao, button_enable,
	input [7:0] a, b
);


initial begin
	RS = 0;
	RW = 0;
	EN = 1;
	data = 8'b00000001;
	
end

wire sinalS;
wire [15:0] S;
wire [2:0] oper;
parameter OFF = 0, ON = 1, ADD = 2, SUBTRACT = 3, MULTIPLY = 4;

calculadora(clk, button_multiplicao, button_soma, button_subtracao, button_enable, sinalA, sinalB, a, b, sinalS, S, oper);

parameter WAIT = 0, WRITE = 1, FINAL = 25;
parameter ONEMS = 50000, HALFMS = 25000;
reg [31:0] counter = 0;
reg [1:0] state = WRITE;
reg [7:0] instructions = 0;

always @(posedge clk) begin // divisor de frequencia 1.5ms
	case (state)
		WRITE: begin
			if (counter == ONEMS) begin
				counter <= 0;
				state <= WAIT;
				EN <= 0;
			end
			else counter <= counter + 1;
		end
		WAIT: begin
			if (counter == HALFMS) begin
				counter <= 0;
				state <= WRITE;
				EN <= 1;
				if (instructions < FINAL) instructions <= instructions + 1;
			   else if(instructions == FINAL) instructions <= 2;
			end
			else counter <= counter + 1;
		end
		default: counter <= 0;
	endcase
end


always @(posedge clk) begin // maquina de estados LCD

	if(oper!= OFF)begin
		case (instructions) 
			0: begin data <= 8'b00111000; RS <= 0; end // Mode Function
			1: begin data <= 8'b00000001; RS <= 0; end // CLEAR
			2: begin data <= 8'b10000000; RS <= 0; end // posicao a
			3: begin                                                    // sinal a
					if(sinalA==0) begin data <= 8'b00101011; RS <= 1; end // +
					else begin data <= 8'b00101101; RS <= 1; end          // -
				end
			4: begin data <= 8'd48+(a/100); RS <= 1; end     // centena a
			5: begin data <= 8'd48+((a/10)%10); RS <= 1; end // dezena a
			6: begin data <= 8'd48+(a%10); RS <= 1; end      // unidade a
			7: begin data <= 8'b10000110; RS <= 0; end // posicao operacao
			8: begin                                                     // operacao
					if(oper == ADD)begin data <= 8'd43; RS <= 1; end       // +
					if(oper == SUBTRACT)begin data <= 8'd45; RS <= 1; end  // -
					if(oper == MULTIPLY)begin data <= 8'd120; RS <= 1; end // X
				end
			9:begin data <= 8'b10001001; RS <= 0; end // posicao b
			10: begin                                                   // sinal b
					if(sinalB==0) begin data <= 8'b00101011; RS <= 1; end // +
					else begin data <= 8'b00101101; RS <= 1; end          // -
				end
			11: begin data <= 8'd48+(b/100); RS <= 1; end     // centena b
			12: begin data <= 8'd48+((b/10)%10); RS <= 1; end // dezena b
			13: begin data <= 8'd48+(b%10); RS <= 1; end      // unidade b
			14: begin data <= 8'b11000000; RS <= 0; end // posicao s
			15: begin 
					if(oper!= ON)begin 													// sinal s
						if(sinalS==0) begin data <= 8'b00101011; RS <= 1; end // +
						else begin data <= 8'b00101101; RS <= 1; end          // -
					 end
				 end
			16: begin
					if(oper!= ON)begin data <= 8'd48+(S/10000); RS <= 1;end //dezena milhar s
				 end
			17: begin
					if(oper!= ON)begin data <= 8'd48+((S/1000)%10); RS <= 1;end //milhar s
				 end
			18: begin
					if(oper!= ON)begin data <= 8'd48+((S/100)%10); RS <= 1;end //centena s
				 end
			19: begin
					if(oper!= ON)begin data <= 8'd48+((S/10)%10); RS <= 1;end //dezena s
				 end
			20: begin
					if(oper!= ON)begin data <= 8'd48+(S%10); RS <= 1;end //unidade s
				 end
			default: begin data <= 8'b10000000; RS <= 0; end
		endcase
	end
	else begin data <= 8'b00000001; RS <= 0; end // if off
	
end

endmodule
