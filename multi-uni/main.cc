#include <cassert>
#include <fstream>
#include "DockerfileParser.h"
int main(int argc, const char *argv[]) {
  assert(argc > 1);
  std::fstream ifile{argv[1]};
  DockerfileParser dockerfileParser(ifile);
  dockerfileParser.Parse();
  return 0;
}
