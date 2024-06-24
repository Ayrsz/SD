module calculadora(
	input clock, button_multiplicao, button_soma, button_subtracao, button_enable,
	inout sinalA, sinalB,
	inout [7:0] A, B,
	output reg sinalS,
	output reg [15:0] S,
	output reg [2:0] oper
	
);


reg [3:0] estado_botoes;
parameter  DESLIGADO = 0, ESPERANDO = 1, SOMA = 2, SUBTRACAO = 3, MULTIPLICACAO = 4;

initial begin
	oper = DESLIGADO;
	estado_botoes = 4'b1111;
end


always @(posedge clock) begin // logica calculadora

	case(oper)
		DESLIGADO: S = 0;
		ESPERANDO: S = 0;
		SOMA: begin
			if(A > B) begin
				sinalS = sinalA;
				if(sinalA != sinalB) S = A - B;
				else S = A + B;
			end
			else if(B >= A) begin
				sinalS = sinalB;
				if(sinalA != sinalB) S = B - A;
				else S = A + B;	
			end		
		end
		SUBTRACAO: begin
		if(sinalA != sinalB)begin
			sinalS = sinalA;
			S = A + B;
			end
			else if(A >= B) begin
				sinalS = sinalA;
				S = A - B;
			end 
			else begin
				if(sinalB == 1) sinalS = 0;
				else sinalS = 1;
				S = B - A;
				end
		end
		MULTIPLICACAO: begin
			if(sinalB == sinalA) sinalS = 0;
			else sinalS = 1;
			S = A * B;
		end
	endcase
end		
		

always @(posedge clock) begin // maquina de estados botao

	estado_botoes <= {button_soma, button_subtracao, button_multiplicao, button_enable};
	
	if(estado_botoes[0] && !button_enable) begin
		if(oper == DESLIGADO) oper <= ESPERANDO;
		else oper <= DESLIGADO;
	end
	else if(estado_botoes[1] && !button_multiplicao && oper != DESLIGADO) oper <= MULTIPLICACAO;
	else if(estado_botoes[2] && !button_subtracao   && oper != DESLIGADO) oper <= SUBTRACAO;
	else if(estado_botoes[3] && !button_soma        && oper != DESLIGADO) oper <= SOMA;
		
end

endmodule