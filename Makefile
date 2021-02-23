all: assembler.exe

clean:
	dune clean
	rm -f assembler

assembler.exe:
	dune build src/assembler.exe
	@cp _build/default/src/assembler.exe assembler
	chmod +w assembler

.PHONY: all clean
