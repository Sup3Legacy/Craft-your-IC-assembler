all: assembler.exe

clean:
	dune clean

assembler.exe:
	dune build assembler.exe
	@cp _build/default/assembler.exe assembler

.PHONY: all clean assembler.exe
