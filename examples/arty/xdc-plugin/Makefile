CXX = $(shell yosys-config --cxx)
CXXFLAGS = $(shell yosys-config --cxxflags)
LDFLAGS = $(shell yosys-config --ldflags)
LDLIBS = $(shell yosys-config --ldlibs)
PLUGINS_DIR = $(shell yosys-config --datdir)/plugins

OBJS = xdc.o

xdc.so: $(OBJS)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -shared -o $@ $^ $(LDLIBS)

.PHONY: install
install: xdc.so
	mkdir -p $(PLUGINS_DIR)
	cp xdc.so $(PLUGINS_DIR)/xdc.so

clean:
	rm -f *.d *.o xdc.so

