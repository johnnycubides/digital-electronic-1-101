/******************************************************************************
*                                                                             *
* Copyright 2016 myStorm Copyright and related                                *
* rights are licensed under the Solderpad Hardware License, Version 0.51      *
* (the “License”); you may not use this file except in compliance with        *
* the License. You may obtain a copy of the License at                        *
* http://solderpad.org/licenses/SHL-0.51. Unless required by applicable       *
* law or agreed to in writing, software, hardware and materials               *
* distributed under this License is distributed on an “AS IS” BASIS,          *
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or             *
* implied. See the License for the specific language governing                *
* permissions and limitations under the License.                              *
*                                                                             *
******************************************************************************/
module top 
#(parameter INIT=0)
(
  // 25MHz clock input
  input  clk,
  // Led outputs
  /* output [3:0] led */
  output led
);

  // turn other leds off (active low)
  /* assign led[2:0] = 3'b111; */

  clock_divider #(.INIT(INIT)) div
  (
    .clk_in(clk),
    .clk_out (led)
  );

endmodule
