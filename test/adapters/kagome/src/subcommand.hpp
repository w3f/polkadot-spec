/*
 * Copyright (c) 2019 Web3 Technologies Foundation
 *
 * This file is part of Polkadot Host Test Suite
 *
 * Polkadot Host Test Suite is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Polkadot Host Tests is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
 */

#pragma once

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
