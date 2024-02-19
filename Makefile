DIRS_BLACKICE := ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/blink/\
								./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/gate_or/
								# ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/blink/

DIRS_ICE40HX8K := ./fpga-example/ice40-hx8k-breakout-board/blink/\
									./fpga-example/ice40-hx8k-breakout-board/bram/ram2ports-init/\
									./fpga-example/ice40-hx8k-breakout-board/bram/ram_counter/\
									./fpga-example/ice40-hx8k-breakout-board/counter/\
									./fpga-example/ice40-hx8k-breakout-board/freq-div/\
									./fpga-example/ice40-hx8k-breakout-board/and2_lut4/
									# ./fpga-example/ice40-hx8k-breakout-board/

DIRS_CYCLONE := ./fpga-example/altera-c4e6e10/blink/\
								./fpga-example/altera-c4e6e10/fullAdder/
								# ./fpga-example/altera-c4e6e10/

DIRS_SIM := ./simulations/iverilog/counter/\
						./simulations/iverilog/fullAdder/\
						./simulations/iverilog/fullAdder-with-arguments/\
						./simulations/iverilog/template/
						# ./simulations/iverilog/

DIRS := $(DIRS_BLACKICE) $(DIRS_CYCLONE) $(DIRS_ICE40HX8K)

zip: zip-sim zip-syn

zip-syn:
	@for n in $(DIRS); do \
		cd $(PWD)/$$n && make zip; \
	done

zip-sim:
	@for n in $(DIRS_SIM); do \
		cd $(PWD)/$$n && make zip-sim; \
	done

