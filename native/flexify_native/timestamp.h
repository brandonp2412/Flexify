//
// Created by joseph on 22/06/24.
//

#ifndef FLEXIFYNATIVE_TIMESTAMP_H
#define FLEXIFYNATIVE_TIMESTAMP_H

#include <chrono>
#include <optional>

#include "timer.h"

namespace flexify {
    inline std::optional<std::chrono::time_point<fclock_t>> convertLongToTimePoint(int64_t timestamp) {
        if (timestamp == 0) return std::nullopt;
        return std::chrono::time_point<fclock_t>(std::chrono::milliseconds(timestamp));
    }
}

#endif //FLEXIFYNATIVE_TIMESTAMP_H
