/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP
#define KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP

#include <map>
#include <functional>
#include <list>

template <typename... Args> class SubcommandRouter {
public:
    void addSubcommand(std::string name, std::function<void(Args...)> handler) {
        handlers[std::move(name)] = std::move(handler);
    }

    std::list<std::string> collectSubcommandNames() const {
        std::list<std::string> names;
        for (auto &[key, value] : handlers) {
            names.push_back(key);
        }
        return names;
    }

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



#endif //KAGOMECROSSTESTCLI_SUBCOMMAND_ROUTER_HPP
