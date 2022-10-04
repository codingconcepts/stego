.PHONY: build

validate_version:
ifndef VERSION
	$(error VERSION is undefined)
endif

conceal_text:
	crystal build stego.cr && \
		./stego conceal text \
		-i testing/input.png \
		-o testing/output.png

conceal_file:
	crystal build stego.cr && \
		./stego conceal file \
		-i testing/input.png \
		-o testing/output.png \
		testing

reveal_text:
	crystal build stego.cr && \
		./stego reveal text \
		-i testing/output.png

reveal_file:
	crystal build stego.cr && \
		./stego reveal file \
		-i testing/output.png

build: validate_version
	crystal build --release -o build/stego stego.cr
	(cd build && tar -zcvf stego_${VERSION}_macos.tar.gz ./stego)
	rm ./build/stego ./build/*.dwarf