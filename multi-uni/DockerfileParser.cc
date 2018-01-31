#include "DockerfileParser.h"
#include <cassert>
#include <istream>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

DockerfileParser::DockerfileParser(std::istream &ifile) : ifile_(ifile) {}

std::vector<Stage> DockerfileParser::Parse() const {
  std::vector<Stage> stages;
  std::string line;
  while (getline(ifile_, line)) {
    std::string_view line_view(line.data(), 4);
    if (line_view.substr(0, 4) == "FROM") {
      stages.emplace_back(std::vector<Instruction>{Instruction{line}});
    } else {
      assert(!stages.empty());
      std::string concatenated(move(line));
      while (!concatenated.empty() && concatenated.back() == '\\' &&
             getline(ifile_, line)) {
        concatenated.push_back('\n');
        concatenated.append(line);
      }
      stages.back().instructions_.emplace_back(move(concatenated));
    }
  }

  return stages;
}
Stage::Stage(std::vector<Instruction> instructions)
    : instructions_(instructions) {}
