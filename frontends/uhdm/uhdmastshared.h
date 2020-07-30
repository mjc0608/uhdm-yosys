#ifndef _UHDM_AST_SHARED_H_
#define _UHDM_AST_SHARED_H_ 1

#include <string>
#include <unordered_map>
#include "uhdmastreport.h"

YOSYS_NAMESPACE_BEGIN

class UhdmAstShared {
	private:
		// Used for generating enum names
		unsigned enum_count = 0;

		// Used for generating port IDS
		unsigned port_count = 0;

	public:
		// Generate the next enum ID (starting with 0)
		unsigned next_enum_id() { return enum_count++; }

		// Generate the next port ID (starting with 1)
		unsigned next_port_id() { return ++port_count; }

		// Flag that determines whether debug info should be printed
		bool debug_flag = false;

		// Flag that determines whether errors should be fatal
		bool stop_on_error = true;

		// Top nodes of the design (modules, interfaces)
		std::unordered_map<std::string, AST::AstNode*> top_nodes;

		// Map from already visited UHDM nodes to AST nodes
		std::unordered_map<const UHDM::BaseClass*, AST::AstNode*> visited;

		// UHDM node coverage report
		UhdmAstReport report;
};

YOSYS_NAMESPACE_END

#endif