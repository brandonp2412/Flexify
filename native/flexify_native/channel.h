//
// Created by joseph on 22/06/24.
//

#ifndef NATIVE_HANDLER_H
#define NATIVE_HANDLER_H

#include "timestamp.h"
#include "timer_service.h"

#include <chrono>
#include <iostream>
#include <optional>

namespace flexify {

    enum MethodCall {
        Timer,
        Add,
        Stop
    };

    struct TimerArgs {
        std::string title;
        std::optional<std::chrono::time_point<fclock_t>> timestamp;
        std::chrono::milliseconds restMs;
    };

    template <Platform P, MethodCall M, typename Channel, typename Result>
    inline void handleMethodCall(Channel channel, Result methodCall) {
        switch (M) {
            case Timer:
            {
                const auto args = platform_specific::getTimerArgs<P>(channel, methodCall);
                flexify::platform_specific::getTimerService<P>().start(args.title, args.timestamp, args.restMs);
                flexify::platform_specific::sendResult<P, Result, true>(methodCall);
                break;
            }
            case Add: {
                auto& timerService = flexify::platform_specific::getTimerService<P>();
                if (!timerService.isRunning()) {
                    const auto timestamp = flexify::platform_specific::getAddArgs<P>(channel, methodCall);
                    timerService.start("Rest timer", timestamp, flexify::ONE_MINUTE_MILLI);
                } else {
                    timerService.add(std::nullopt);
                }
                flexify::platform_specific::sendResult<P, Result, true>(methodCall);
                break;
            }
            case Stop:
                flexify::platform_specific::getTimerService<P>().stop();
                flexify::platform_specific::sendResult<P, Result, true>(methodCall);
                break;
            default:
                flexify::platform_specific::sendResult<P, Result, false>(methodCall);
                break;
        }
    }
}

#endif //NATIVE_HANDLER_H
