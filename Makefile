# Z88DK macro testing suite

.PHONY: clean all

all: testver.com test_memcpy.com test_memcpy.com test_memfill.com test_memcmp.com test_misc.com

testver.com: cpm-map.asm cpmmacro.asm.m4 testver.asm.m4
	zcc +embedded -v  -m --list -subtype=none --no-crt cpm-map.asm testver.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memcpy.com: cpm-map.asm cpmmacro.asm.m4 test_memcpy.asm.m4
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memcpy.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memfill.com: cpm-map.asm cpmmacro.asm.m4 test_memfill.asm.m4
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memfill.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memcmp.com: cpm-map.asm cpmmacro.asm.m4 test_memcmp.asm.m4
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memcmp.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_misc.com: cpm-map.asm cpmmacro.asm.m4 test_misc.asm.m4
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_misc.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@


clean:
	rm -f *.dsk *.map *.bin *.ihx *.lis *.com
