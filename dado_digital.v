module DadoDigital(
   input clk, 		//Señal de reloj 50MHz
	input start,		//Pulso de inicio
	input stop,		//Pulso de paro
	output [7:0]an,seg //Config Display
);

	//Declaracion de registros
	reg [7:0]anodos,segmentos;
	reg [31:0]cnt;	//Contador de frecuencia
	reg senal;		//Señal a X frecuencia
	reg [5:0]cnt_dado;	//Caras
	reg edo, nextEdo;
	reg [7:0]data[0:5]; //Memoria
	//Bloque de instrucciones
	initial begin
					  //pgfedcba
		data[0] = 8'b11111001; //1
		data[1] = 8'b10100100; //2
		data[2] = 8'b10110000; //3.
		data[3] = 8'b10011001; //4
		data[4] = 8'b10010010; //5
		data[5] = 8'b10000011; //6.
	end
	//Inicializacion de variables
	initial begin
		anodos = 8'b11111110;
		segmentos = 0;
		cnt = 0;
		cnt_dado = 0;
		senal = 0;
		nextEdo = 0;
	end

	//Bloque de instrucciones 
	// -> frecuencia de cambio <-
	always@(posedge clk) begin
		if(cnt == 500_000)begin
			senal <= ~senal;
			cnt <= 0;
		end
		else cnt <= cnt + 1;
	end
	//Bloque de isntrucciones
	// -> Maquina de estados <-
	always@(posedge clk)begin
		case(edo)
			0: nextEdo = (start == 0) ? 1:0; //Espera
			1: nextEdo = (stop == 0) ? 0:1;	//Dado
		endcase
	end always@(posedge clk) edo = nextEdo; 
	//Bloque de instrucciones
	// -> Conf dado <-
	always@(posedge senal)begin
		case(edo)
			//Mantenemos el ultimo valor del dado.
			0: cnt_dado <= cnt_dado;
			//Hacemos girar el dado	
			1: cnt_dado <= (cnt_dado == 5) ? 0: cnt_dado + 1;
		endcase
		segmentos <= data[cnt_dado];
	end
	//Asignacion de variables fisicas
	assign an = anodos;
	assign seg = segmentos;
endmodule

