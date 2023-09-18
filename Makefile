DIRS_BLACKICE := ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/blink/\
								./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/gate_or/
								# ./fpga-example/ice40-hx4k-MyStorm-BlackIce-Mx/blink/

DIRS_CYCLONE := ./fpga-example/altera-c4e6e10/blink/\
								./fpga-example/altera-c4e6e10/fullAdder/
								# ./fpga-example/altera-c4e6e10/

DIRS_SIM := ./simulations/iverilog/counter/\
						./simulations/iverilog/fullAdder/\
						./simulations/iverilog/fullAdder-with-arguments/\
						./simulations/iverilog/template/
						# ./simulations/iverilog/

DIRS := $(DIRS_BLACKICE) $(DIRS_CYCLONE)

zip: zip-sim zip-syn

zip-syn:
	@for n in $(DIRS); do \
		cd $(PWD)/$$n && make zip; \
	done

zip-sim:
	@for n in $(DIRS_SIM); do \
		cd $(PWD)/$$n && make zip-sim; \
	done

