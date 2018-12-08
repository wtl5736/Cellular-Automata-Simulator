#
# Makefile for CompOrg Project - Elementary Cellular Automaton
#

#
# Location of the processing programs
#
RASM  = /home/fac/wrc/bin/rasm
RLINK = /home/fac/wrc/bin/rlink
RSIM  = /home/fac/wrc/bin/rsim

#
# Suffixes to be used or created
#
.SUFFIXES:	.asm .obj .lst .out

#
# Object files to be created
#
OBJECTS = cell_auto_sim.obj cell_auto_dead_or_alive.obj cell_auto_algorithm.obj cell_auto_printers.obj

#
# Transformation rule: .asm into .obj
#
.asm.obj:
	$(RASM) -l $*.asm > $*.lst

#
# Transformation rule: .obj into .out
#
.obj.out:
	$(RLINK) -o $*.out $*.obj

#
# Main target
#
cell_auto_sim.out:	$(OBJECTS)
	$(RLINK) -m -o cell_auto_sim.out $(OBJECTS) > cell_auto_sim.map

run:	cell_auto_sim.out
	$(RSIM) cell_auto_sim.out
