counter_arty.fasm: counter_arty.v
ifndef YOSYS
	$(error YOSYS is not set)
endif
	$(YOSYS) -s "xdc2fasm.ys" -l yosys.log

xdc-plugin/xdc.so:
	$(MAKE) -C xdc-plugin xdc.so
	$(MAKE) -C xdc-plugin install

clean:
	$(MAKE) -C xdc-plugin clean
	rm -rf *.eblif *.premap.v *synth.v *.fasm *.log
