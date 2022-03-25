
test:
	$(MAKE) test_DES
	$(MAKE) test_FSMD

test_DES:
	$(MAKE) clean
	make -f Makefile_DES

test_FSMD:
	$(MAKE) clean
	make -f Makefile_FSMD

clean:
	rm -rf __pycache__ sim_build results.xml *.vcd
