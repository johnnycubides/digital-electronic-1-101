DIRS_BLACKICE := ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/blink/\
								./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/gate_or/\
									./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/template/\
									./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/femtoriscv/
								# ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/

DIRS_ICE40HX8K := ./fpga-example/ice40-hx8k-breakout-board/blink/\
									./fpga-example/ice40-hx8k-breakout-board/bram/ram2ports-init/\
									./fpga-example/ice40-hx8k-breakout-board/bram/ram_counter/\
									./fpga-example/ice40-hx8k-breakout-board/counter/\
									./fpga-example/ice40-hx8k-breakout-board/freq-div/\
									./fpga-example/ice40-hx8k-breakout-board/and2_lut4/\
									./fpga-example/ice40-hx8k-breakout-board/femtoriscv/
									# ./fpga-example/ice40-hx8k-breakout-board/template
									# ./fpga-example/ice40-hx8k-breakout-board/

DIRS_COLORLIGHT := ./fpga-example/colorlight-5a-75e/blink/\
									 ./fpga-example/colorlight-5a-75e/template/\
									 ./fpga-example/colorlight-5a-75e/femtoriscv/
									 # ./fpga-example/colorlight-5a-75e/

DIRS_CYCLONE := ./fpga-example/altera-c4e6e10/blink/\
								./fpga-example/altera-c4e6e10/fullAdder/\
								./fpga-example/altera-c4e6e10/template/
								# ./fpga-example/altera-c4e6e10/

DIRS_OPEN_EP4CE6_C := ./fpga-example/openep4ce6-c/template/

DIRS_SIM := ./simulations/iverilog/counter/\
						./simulations/iverilog/fullAdder/\
						./simulations/iverilog/fullAdder-with-arguments/\
						./simulations/iverilog/uart_8n1/\
						./simulations/iverilog/template/
						# ./simulations/iverilog/

DIRS := $(DIRS_BLACKICE) $(DIRS_CYCLONE) $(DIRS_ICE40HX8K) $(DIRS_COLORLIGHT) $(DIRS_OPEN_EP4CE6_C)

zip: zip-sim zip-syn

zip-syn:
	@for n in $(DIRS); do \
		cd $(PWD)/$$n && make zip; \
	done

zip-sim:
	@for n in $(DIRS_SIM); do \
		cd $(PWD)/$$n && make zip-sim; \
	done

