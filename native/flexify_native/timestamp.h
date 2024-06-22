//
// Created by joseph on 22/06/24.
//

#ifndef FLEXIFYNATIVE_TIMESTAMP_H
#define FLEXIFYNATIVE_TIMESTAMP_H

#include <chrono>
#include <optional>


namespace flexify {
    inline std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> convertLongToTimePoint(int64_t timestamp) {
        if (timestamp == 0) return std::nullopt;
        return std::chrono::time_point<std::chrono::system_clock>(std::chrono::milliseconds(timestamp));
    }
}

#endif //FLEXIFYNATIVE_TIMESTAMP_H
