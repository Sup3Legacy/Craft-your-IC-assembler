all: assembler.exe

clean:
	dune clean

assembler.exe:
	dune build assembler.exe

.PHONY: all clean assembler.exe
