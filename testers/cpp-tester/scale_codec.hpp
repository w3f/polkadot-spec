/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef KAGOMECROSSTESTCLI_SCALE_CODEC_HPP
#define KAGOMECROSSTESTCLI_SCALE_CODEC_HPP

#include <string>

// arguments for SCALE tests
struct ScaleCommandArgs {
    std::string subcommand;
    std::string input;
};

// parses CLI input
ScaleCommandArgs extractScaleArgs(int argc, char **argv);

// executes SCALE tests according to provided args
void processScaleCodecCommand(ScaleCommandArgs args);

#endif //KAGOMECROSSTESTCLI_SCALE_CODEC_HPP
