
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module partI(

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);



//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

lzd4 mylzd (.lzdIn(SW[3:0]), .lzdOut(LEDR[2:0]));

endmodule
