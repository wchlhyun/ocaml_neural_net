compile:
	ocamlbuild -use-ocamlfind main.byte -lflag -linkall

test:
	ocamlbuild -use-ocamlfind tests.byte && ./tests.byte

train:
	ocamlbuild -use-ocamlfind train.byte -lflag -linkall && ./train.byte

testnn:
	ocamlbuild -use-ocamlfind nn_tester.byte && ./nn_tester.byte

testmnist:
	ocamlbuild -use-ocamlfind mnist_tester.byte -lflag -linkall && ./mnist_tester.byte

install:
	opam install owl conflibjpeg conflibpng camlimages

zip:
	zip source.zip *.ml*

clean:
	ocamlbuild -clean
	rm -f source.zip

utop:
	make compile
	utop -init .ocamlinit
