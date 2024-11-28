# Se determina el OS y se asignan el comando de borrado acordemente.
ifeq ($(OS), Windows_NT)
	cleanCommand = del
else
	cleanCommand = rm -f
endif

# Este define es para recrear la configuración usada en gtkwave con las ondas ya puestas
# se copia el contenido del archivo de configuración en configuracionGTKW y se escribe al archivo.
define configuracionGTKW
[timestart] 0
[size] 1908 987
[pos] 32767 32767
*-3.827247 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[treeopen] testbench.
[treeopen] testbench.S1.
[sst_width] 42
[signals_width] 158
[sst_expanded] 0
[sst_vpaned_height] 288
@200
-GMII
@28
testbench.Test1.Clk
testbench.Test1.mr_main_reset
testbench.Test1.power_on
@22
testbench.Test1.TXD[7:0]
@28
testbench.T1.TX_EN
testbench.T1.TX_ER
@200
-
-TRANSMISOR
@28
testbench.Test1.transmitting
@22
testbench.T1.tx_o_set[6:0]
@28
testbench.T1.TX_OSET_indicate
testbench.T1.tx_even
@22
testbench.T1.PUDR[9:0]
@200
-
-SINCRONIZADOR
@22
testbench.S1.SUDI[10:0]
@28
testbench.S1.code_sync_status
@200
-
[pattern_trace] 1
[pattern_trace] 0
endef

# Esto evita que se haga conflictos si tiene archivos llamados clean o sync.
.PHONY: sym clean mostrar_sym

# Regla para limpiar los archivos generados.
clean:
	$(cleanCommand) salida resultados.vcd ondas.gtkw

# Regla para crear y simular el módulo.
sym:
	iverilog -o salida testbench.v
	vvp salida

mostrar_sym:
	$(file >ondas.gtkw,$(configuracionGTKW))
	iverilog -o salida testbench.v
	vvp salida
	gtkwave resultados.vcd ondas.gtkw
