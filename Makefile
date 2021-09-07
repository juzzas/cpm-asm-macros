# Z88DK macro testing suite

.PHONY: clean

testver.com: cpm-map.asm cpmmacro.asm.m4 testver.asm.m4
	zcc +embedded -v  -m --list -subtype=none --no-crt cpm-map.asm testver.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@

test_memcpy.com: cpm-map.asm cpmmacro.asm.m4 test_memcpy.asm.m4
	zcc +embedded -v -m --list -subtype=none --no-crt cpm-map.asm test_memcpy.asm.m4 -o $@ -create-app  -Cz"+glue --clean --pad"
	cp $@__.bin $@


clean:
	rm -f *.dsk *.map *.bin *.ihx *.lis *.com
