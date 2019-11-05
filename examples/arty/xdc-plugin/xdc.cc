/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *  ---
 *
 *   XDC commands + FASM backend.
 *
 *   This plugin operates on the existing design and modifies its structure
 *   based on the content of the XDC (Xilinx Design Constraints) file.
 *   Since the XDC file consists of Tcl commands it is read using Yosys's
 *   tcl command and processed by the new XDC commands imported to the
 *   Tcl interpreter.
 */

#include "kernel/register.h"
#include "kernel/rtlil.h"
#include "kernel/log.h"

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

int current_iobank = 0;

// Coordinates of HCLK_IOI tiles associated with a specified bank
// This is very part specific and is for Arty's xc7a35tcsg324 part
std::unordered_map<int, std::string> bank_tiles = {
	{14, "X1Y26"},
	{15, "X1Y78"},
	{16, "X1Y130"},
	{34, "X113Y26"},
	{35, "X113Y78"}
};

enum SetPropertyOptions { INTERNAL_VREF };

std::unordered_map<std::string, SetPropertyOptions> set_property_options_map  = {
	{"INTERNAL_VREF", INTERNAL_VREF}
};

struct GetPorts : public Pass {
	GetPorts() : Pass("get_ports", "Print matching ports") {}
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("   get_ports \n");
		log("\n");
		log("Get matching ports\n");
		log("\n");
		log("Print the output to stdout too. This is useful when all Yosys is executed\n");
		log("\n");
	}
	void execute(std::vector<std::string> args, RTLIL::Design*) YS_OVERRIDE
	{
		std::string text;
		for (auto& arg : args) {
			text += arg + ' ';
		}
		if (!text.empty()) text.resize(text.size()-1);
		log("%s\n", text.c_str());
	}
} GetPorts;

struct GetIOBanks : public Pass {
	GetIOBanks() : Pass("get_iobanks", "Set IO Bank number") {}
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("   get_iobanks \n");
		log("\n");
		log("Get IO Bank number\n");
		log("\n");
	}
	void execute(std::vector<std::string> args, RTLIL::Design* ) YS_OVERRIDE
	{
		if (args.size() != 2) {
			log("Incorrect number of arguments. %zu instead of 1", args.size());
			return;
		}
		current_iobank = std::atoi(args[1].c_str());
		if (bank_tiles.count(current_iobank) == 0) {
			log("get_iobanks: Incorrect bank number: %d\n", current_iobank);
			current_iobank = 0;
		}
	}
} GetIOBanks;

struct SetProperty : public Pass {
	SetProperty() : Pass("set_property", "Set a given property") {}
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    set_property PROPERTY VALUE OBJECT\n");
		log("\n");
		log("Set the given property to the specified value on an object\n");
		log("\n");
	}
	void execute(std::vector<std::string> args, RTLIL::Design* design) YS_OVERRIDE
	{
		if (design->top_module() == nullptr) {
			log("No top module detected\n");
			return;
		}
		std::string option(args[1]);
		if (set_property_options_map.count(option) == 0) {
			log("set_property: %s option is currently not supported\n", option.c_str());
			return;
		}
		switch (set_property_options_map[option]) {
			case INTERNAL_VREF:
				process_vref(std::vector<std::string>(args.begin() + 2, args.end()), design);
				break;
			default:
				assert(false);
		}
	}
	void process_vref(std::vector<std::string> args, RTLIL::Design* design)
       	{
		if (args.size() != 2) {
			log("Incorrect number of arguments: %zu\n", args.size());
			return;
		}
		if (current_iobank == 0) {
			log("set_property: No valid bank set. Use get_iobanks.\n");
			return;
		}
		RTLIL::Module* top_module = design->top_module();
		if (!design->has(ID(BANK))) {
			RTLIL::Module* bank_module = design->addModule(ID(BANK));
			bank_module->makeblackbox();
			bank_module->avail_parameters.insert(ID(NUMBER));
			bank_module->avail_parameters.insert(ID(INTERNAL_VREF));
		}
		char bank_cell_name[16];
		snprintf(bank_cell_name, 16, "\\bank_cell_%d", current_iobank);
		int internal_vref = 1000 * std::atof(args[0].c_str());
		if (internal_vref != 600 &&
				internal_vref != 675 &&
				internal_vref != 750 &&
				internal_vref != 900) {
			log("Incorrect INTERNAL_VREF value\n");
			return;
		}
		RTLIL::Cell* bank_cell = top_module->cell(RTLIL::IdString(bank_cell_name));
		if (!bank_cell) {
			bank_cell = top_module->addCell(RTLIL::IdString(bank_cell_name), ID(BANK));
		}
		bank_cell->setParam(ID(NUMBER), RTLIL::Const(current_iobank));
		bank_cell->setParam(ID(INTERNAL_VREF), RTLIL::Const(internal_vref));
	}

} SetProperty;


struct WriteFasm : public Backend {
	//static std::unordered_map<int, std::string> bank_tiles;
	WriteFasm() : Backend("fasm", "Write out FASM features") { }
	void help() YS_OVERRIDE
	{
		//   |---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|---v---|
		log("\n");
		log("    write_fasm filename\n");
		log("\n");
		log("Write out a file with vref FASM features\n");
		log("\n");
	}
	void execute(std::ostream *&f, std::string filename,  std::vector<std::string> args, RTLIL::Design *design) YS_OVERRIDE
	{
		size_t argidx = 1;
		extra_args(f, filename, args, argidx);
		process_vref(f, design);
	}

	void process_vref(std::ostream *&f, RTLIL::Design* design) {
		RTLIL::Module* top_module(design->top_module());
		if (top_module == nullptr) {
			log("No top module detected\n");
			return;
		}
		// Return if no BANK module exists as this means there are no cells
		if (!design->has(ID(BANK))) {
			return;
		}
		// Generate a fasm feature associated with the INTERNAL_VREF value per bank
		// e.g. VREF value of 0.675 for bank 34 is associated with tile HCLK_IOI3_X113Y26
		// hence we need to emit the following fasm feature: HCLK_IOI3_X113Y26.VREF.V_675_MV
		for (auto cell : top_module->cells()) {
                        if (cell->type != ID(BANK)) continue;
			int bank_number(cell->getParam(ID(NUMBER)).as_int());
			int bank_vref(cell->getParam(ID(INTERNAL_VREF)).as_int());
			*f << "HCLK_IOI3_" << bank_tiles[bank_number] <<".VREF.V_" << bank_vref << "_MV\n";
                }
	}
} WriteFasm;

PRIVATE_NAMESPACE_END
