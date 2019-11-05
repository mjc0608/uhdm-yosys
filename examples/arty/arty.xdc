set_property LOC R2 [get_ports ddram_a]
set_property SLEW FAST [get_ports ddram_a]
set_property IOSTANDARD SSTL135 [get_ports ddram_a]
## ddram:0.a
set_property INTERNAL_VREF 0.600 [get_iobanks 14]
set_property INTERNAL_VREF 0.675 [get_iobanks 15]
set_property INTERNAL_VREF 0.750 [get_iobanks 16]
set_property INTERNAL_VREF 0.900 [get_iobanks 34]
set_property INTERNAL_VREF 0.900 [get_iobanks 35]

