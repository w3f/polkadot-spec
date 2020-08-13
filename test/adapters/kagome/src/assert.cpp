#include "assert.hpp"

namespace boost {

  void assertion_failed(char const * expr, char const * function, char const * file, long line) {
    std::cout << "Assert inside function '" << function
              << "' in file '" << file
              << "' on line '" << line
              << "' when evaluating '" << expr
              << "'" << std::endl;
  }

  void assertion_failed_msg(char const * expr, char const * msg, char const * function, char const * file, long line) {
    std::cout << "Error inside function '" << function
              << "' in file '" << file
              << "' on line '" << line
              << "' when evaluating '" << expr
              << "': " << msg << std::endl;
  }

} // namespace boost
