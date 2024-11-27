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
[pos] 65503 65503
*-5.112947 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1
[treeopen] testbench.
[sst_width] 42
[signals_width] 190
[sst_expanded] 0
[sst_vpaned_height] 288
@200
-Señales del sistema
@28
testbench.S1.Clk
testbench.S1.power_on
testbench.S1.mr_main_reset
testbench.S1.PUDI[9:0]
@200
-
-Registros internos
@24
testbench.S1.State[10:0]
testbench.S1.next_State[10:0]
@200
-
@28
testbench.S1.cggood
@24
testbench.S1.good_cgs[1:0]
@200
-
@28
testbench.S1.PUDI_indicate
testbench.S1.PUDI_COMMA
testbench.S1.PUDI_D
testbench.S1.PUDI_INVALID
testbench.S1.rx_even
@200
-
-Salidas
@28
testbench.S1.SUDI[10:0]
testbench.S1.code_sync_status
[pattern_trace] 1
[pattern_trace] 0
endef

# Esto evita que se haga conflictos si tiene archivos llamados clean o sync.
.PHONY: sync clean mostrar_sync

# Regla para limpiar los archivos generados.
clean:
	$(cleanCommand) salida resultados.vcd ondas.gtkw

# Regla para crear y simular el módulo.
sync:
	iverilog -o salida testbench.v
	vvp salida

mostrar_sync:
	$(file >ondas.gtkw,$(configuracionGTKW))
	iverilog -o salida testbench.v
	vvp salida
	gtkwave resultados.vcd ondas.gtkw
