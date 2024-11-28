# Se determina el OS y se asignan el comando de borrado acordemente.
ifeq ($(OS), Windows_NT)
	cleanCommand = del
else
	cleanCommand = rm -f
endif

# Este define es para recrear la configuración usada en gtkwave con las ondas ya puestas
# se copia el contenido del archivo de configuración en configuracionGTKW y se escribe al archivo.
define configuracionGTKW

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
	gtkwave resultados.vcd 

#ondas.gtkw
