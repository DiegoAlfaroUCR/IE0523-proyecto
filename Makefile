# Se determina el OS y se asignan el comando de borrado acordemente.
ifeq ($(OS), Windows_NT)
	cleanCommand = del
else
	cleanCommand = rm -f
endif

# Constantes para simulación
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
OUTPUT = salida
WAVEFORM = resultados.vcd


# Regla para limpiar los archivos generados.
clean:
	$(cleanCommand) $(OUTPUT) $(WAVEFORM)


# Regla general para simular
simulate:
	$(IVERILOG) -o $(OUTPUT) $(TESTBENCH)
	$(VVP) $(OUTPUT)
	$(GTKWAVE) $(WAVEFORM) $(GTKW)

# Reglas de compilación según prueba requerida
PCS_completo:
	$(MAKE) simulate TESTBENCH=test/PCS_completo/testbench.v GTKW=test/PCS_completo/ondas.gtkw

sync_trans:
	$(MAKE) simulate TESTBENCH=test/Sync_Trans/testbench.v GTKW=test/Sync_Trans/ondas.gtkw

sync_receive:
	$(MAKE) simulate TESTBENCH=test/Sync_Receive/testbench.v GTKW=test/Sync_Receive/ondas.gtkw

sync:
	$(MAKE) simulate TESTBENCH=test/Sync/testbench.v GTKW=test/Sync/ondas.gtkw

receive:
	$(MAKE) simulate TESTBENCH=test/Receive/testbench.v GTKW=test/Receive/ondas.gtkw

transmit:
	$(MAKE) simulate TESTBENCH=test/Transmit/testbench.v GTKW=test/Transmit/ondas.gtkw

.PHONY: clean PCS_completo