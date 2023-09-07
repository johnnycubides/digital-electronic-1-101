module top(input b, a, cin, output cout, s);

/* LEDs y SWs invertidos */
wire [1:0] out;

fulladder fulladder(~b,~a,~cin,out[1], out[0]);

assign cout = ~out[1];
assign s = ~out[0];

/* LEds y SW no invertidos */
/* fulladder fulladder(~b,~a,~cin, cout, s); */

endmodule
