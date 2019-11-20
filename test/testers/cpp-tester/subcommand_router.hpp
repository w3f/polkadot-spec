/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP
#define KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP

#include <functional>
#include <list>
#include <map>

/**
 * A dictionary command_name -> functor
 * Utility class to store functors associated with some names and
 * execute them using the names
 * @tparam Args input arguments of a stored functor
 */
template <typename... Args> class SubcommandRouter {
public:
  void addSubcommand(std::string name, std::function<void(Args...)> handler) {
    handlers[std::move(name)] = std::move(handler);
  }

  /**
   * @return names of all stored subcommands
   */
  std::list<std::string> collectSubcommandNames() const {
    std::list<std::string> names;
    for (auto &[key, value] : handlers) {
      names.push_back(key);
    }
    return names;
  }

  /**
   * @tparam FArgs input arguments of the called functor
   * @param name of the functor to call
   * @param args that would be passed to the functor
   * @return true if a functor with the corresponding name was found, false
   * otherwise
   */
  template <typename... FArgs>
  bool executeSubcommand(const std::string &name, FArgs &&... args) {
    if (handlers.find(name) != handlers.end()) {
      handlers.at(name)(std::forward<FArgs>(args)...);
      return true;
    }
    return false;
  }

private:
  std::map<std::string, std::function<void(Args...)>> handlers;
};

#endif // KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP
