//+++++++++++++++++++++++++++++++++++++++++++++++++
//   DUT With assertions
//+++++++++++++++++++++++++++++++++++++++++++++++++
module noncon_assertion();

logic clk = 0;
always #1 clk ++;

logic req,busy,gnt;

sequence noncon_seq;
  req ##1 (busy [=3]) ##1 gnt;
endsequence

sequence con_seq;
  req ##1 (busy [*3]) ##1 gnt;
endsequence

sequence goto_seq;
  req ##1 (busy [->3]) ##1 gnt;
endsequence

property noncon_prop;
  @ (posedge clk) 
      req |-> noncon_seq;
endproperty

property con_prop;
  @ (posedge clk) 
      req |-> con_seq;
endproperty

property goto_prop;
  @ (posedge clk) 
      req |-> goto_seq;
endproperty

noncon_assert   : assert property (noncon_prop);
con_assert   : assert property (con_prop);
goto_assert   : assert property (goto_prop);

initial begin
  // Pass sequence
  gen_seq(3,0); 
  repeat (20) @ (posedge clk);
  // This was fail in goto, but not here
  gen_seq(3,1); 
  repeat (20) @ (posedge clk);
  gen_seq(3,5); 
  // Lets fail one 
  repeat (20) @ (posedge clk);
  gen_seq(5,5); 
  // Terminate the sim
  #30 $finish;
end

task  gen_seq (int busy_delay,int gnt_delay);
  req <= 0; busy <= 0;gnt <= 0;
  @ (posedge clk);
  req <= 1;
  @ (posedge clk);
  req  <= 0;
  repeat (busy_delay) begin
   @ (posedge clk);
    busy <= 1;
   @ (posedge clk);
    busy <= 0;
  end
  repeat (gnt_delay) @ (posedge clk);
  gnt <= 1;
  @ (posedge clk);
  gnt <= 0;
endtask

endmodule
