#pragma once

#include <iostream>

#define BOOST_ENABLE_ASSERT_HANDLER
#include <boost/assert.hpp>

#include <exception>

//! Custom exception to signal missing implementation
struct NotImplemented : public std::runtime_error {
  NotImplemented() : std::runtime_error("Not implemented!") {}
};


//! Helpers to print asserts and associated messages
namespace boost {
  void assertion_failed(char const * expr, char const * function, char const * file, long line);

  void assertion_failed_msg(char const * expr, char const * msg, char const * function, char const * file, long line);
}
