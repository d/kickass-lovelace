#include <iosfwd>
#include <string>
#include <vector>

struct Instruction : std::string {
  using std::string::basic_string;
};

struct Stage {
  std::vector<Instruction> instructions_;

  explicit Stage(std::vector<Instruction> instructions);
};

class DockerfileParser {
 public:
  explicit DockerfileParser(std::istream& ifile);
  std::vector<Stage> Parse() const;

 private:
  std::istream& ifile_;
};
