.SILENT:

all: build
	/usr/bin/mips64-elf-gcc -c -MMD -march=vr4300 -mtune=vr4300 -I/usr/mips64-elf/include -falign-functions=32 -ffunction-sections -fdata-sections -DN64 -O2 -Wall -Werror -Wno-error=deprecated-declarations -fdiagnostics-color=always -std=gnu99 -o build/main.o source/main.c
	/usr/bin/mips64-elf-gcc /usr/mips64-elf/lib/libdragon.a /usr/mips64-elf/lib/libdragonsys.a build/main.o -lc -Wl,-L/usr/mips64-elf/lib -Wl,-ldragon -Wl,-lm -Wl,-ldragonsys -Wl,-Tn64.ld -Wl,--gc-sections -Wl,--wrap -Wl,__do_global_ctors -Wl,-Map=build/main.map -o build/main.elf
	/usr/bin/mips64-elf-objcopy -O binary build/main.elf build/main.bin
	./build/n64tool --header /usr/mips64-elf/lib/header --title "Main" --output main.z64 build/main.bin
	./build/chksum64 main.z64 >/dev/null

build:
	mkdir -p build
	gcc -O3 tools/n64tool.c -o build/n64tool
	gcc -O3 tools/chksum64.c -o build/chksum64

run: all
	mame n64dd -cart main.z64

clean:
	rm -r build
	rm main.z64
