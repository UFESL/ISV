module arb(clk, rst, req1, req2, gnt1, gnt2);
input clk, rst, req1, req2;
output gnt1, gnt2;
reg state, gnt1, gnt2;
always @ (posedge clk or posedge rst)
    if (rst)
        state <= 0;
    else
        state <= gnt1;
always @ (*)
    if (state) begin
        gnt1 = ~req1 & ~req2;
        gnt2 = req2;
	
        // Assert 1: assert(req2 == gnt2)
        //assert(req2 == gnt2);
		if (req2 != gnt2) 
			$display("Erro1");
        
    end
    else begin
        gnt1 = req1;
        gnt2 = req2 & ~req1;
    end

// Assert 2: assert property(gnt1|->~gnt2)
//assert property (gnt1 |-> ~gnt2);
always @ (*)
    if (gnt1)
        if (gnt2)
			$display("Erro2");

always @ (*)
    if (gnt1)
        if (gnt2 != req2)
			$display("Erro3");

endmodule