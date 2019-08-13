/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_SCALE_CODEC_HPP
#define KAGOMECROSSTESTCLI_SCALE_CODEC_HPP

#include <string>

struct ScaleCommandArgs {
    std::string subcommand;
    std::string input;
};

ScaleCommandArgs extractScaleArgs(int argc, char **argv);
void processScaleCodecCommand(ScaleCommandArgs args);

#endif //KAGOMECROSSTESTCLI_SCALE_CODEC_HPP
