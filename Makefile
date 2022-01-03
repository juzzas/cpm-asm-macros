# Z88DK macro testing suite

.PHONY: all clean

all: testver.com test_memcpy.com test_memfill.com test_memcmp.com test_misc.com

testver.com: cpm-map.asm cpmmacro.inc.asm testver.asm
	zcc +embedded -v  -m --list -subtype=none --no-crt cpm-map.asm testver.asm -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memcpy.com: cpm-map.asm cpmmacro.inc.asm test_memcpy.asm
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memcpy.asm -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memfill.com: cpm-map.asm cpmmacro.inc.asm test_memfill.asm
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memfill.asm -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memcmp.com: cpm-map.asm cpmmacro.inc.asm test_memcmp.asm
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memcmp.asm -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_misc.com: cpm-map.asm cpmmacro.inc.asm test_misc.asm
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_misc.asm -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@


clean:
	rm -f *.dsk *.map *.bin *.ihx *.lis *.com
