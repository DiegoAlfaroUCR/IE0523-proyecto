# Archivos de Verilog
SRC_FILES = Receive.v testbench.v tester.v


# Nombre del archivo de salida del VCD
VCD_FILE = Receive_tb.vcd

# Nombre del archivo de simulación
SIM_FILE = receive_sim.out

# Compilador de Verilog (puede ser iverilog, Verilator, etc.)
VERILOG_COMPILER = iverilog

# Comando para simular
SIMULATOR = vvp

# Comando para abrir GTKWave
GTKWAVE = gtkwave

# Objetivo predeterminado
all: sim gtkwave


# Compilación de archivos Verilog
sim:
	$(VERILOG_COMPILER) -o $(SIM_FILE) $(SRC_FILES)

# Ejecuta la simulación y genera el archivo VCD
run: sim
	$(SIMULATOR) $(SIM_FILE)

# Abre GTKWave con el archivo VCD generado
gtkwave: run
	$(GTKWAVE) $(VCD_FILE) 

# Limpia los archivos generados
clean:
	rm -f $(SIM_FILE) $(VCD_FILE)

# PHONY targets
.PHONY: all sim run gtkwave clean 
