//+++++++++++++++++++++++++++++++++++++++++++++++++
// DUT With Immediate assertions
//+++++++++++++++++++++++++++++++++++++++++++++++++
module assert_immediate();

reg  clk, grant, request;
time current_time;

initial begin
  clk = 0;
  grant   = 0;
  request = 0;
  #4 request = 1;
  #4 grant = 1;
  #4 request = 0;
  #4 $finish();
end

always #1 clk = ~clk;
//=================================================
// Assertion used in always block
//=================================================
always @ (posedge clk)
begin
  if (grant == 1) 
  begin
     CHECK_REQ_WHEN_GNT : assert (grant && request) ;
  end 
end

endmodule
