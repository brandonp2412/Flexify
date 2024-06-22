#ifndef NATIVE_TIMER_H
#define NATIVE_TIMER_H


#include <chrono>
#include "platform.h"

using namespace std::chrono_literals;

namespace flexify {

    enum TimerState {
        Running,
        Paused,
        Expired
    };

    template<Platform P>
    class FlexifyTimer {
    public:
        explicit FlexifyTimer(std::chrono::milliseconds timerDuration);

        ~FlexifyTimer();

        static inline FlexifyTimer<P> emptyTimer() { return FlexifyTimer<P>(0ms); }

        void start(std::chrono::milliseconds elapsedTime = 0ms);

        void stop();

        void expire();

        void increaseDuration(std::chrono::milliseconds increase);

        bool hasSecondsUpdated();

        inline bool isRunning() { return state == TimerState::Running; }

        inline bool hasExpired() { return state == TimerState::Expired; }

        inline std::chrono::seconds getRemainingSeconds() { return std::chrono::duration_cast<std::chrono::seconds>(state == TimerState::Running ? endTime - std::chrono::high_resolution_clock::now() : timerDuration); }

    private:
        TimerState state;
        std::chrono::seconds previousSeconds;
        std::chrono::milliseconds timerDuration;
        std::chrono::milliseconds totalTimerDuration;
        std::chrono::time_point<std::chrono::high_resolution_clock> endTime;
    };

    template<Platform P>
    bool FlexifyTimer<P>::hasSecondsUpdated() {
        const std::chrono::seconds remainingSeconds = getRemainingSeconds();
        if (previousSeconds == remainingSeconds) return false;
        previousSeconds = remainingSeconds;
        return true;
    }

    template<Platform P>
    FlexifyTimer<P>::FlexifyTimer(std::chrono::milliseconds msTimerDuration) : state(TimerState::Paused),
                                                                              timerDuration(msTimerDuration),
                                                                              totalTimerDuration(msTimerDuration) {
    }

    template<Platform P>
    FlexifyTimer<P>::~FlexifyTimer() {
        stop();
    }

    template<Platform P>
    void FlexifyTimer<P>::start(std::chrono::milliseconds elapsedTime) {
        if (state != TimerState::Paused) return;
        timerDuration -= elapsedTime;
        endTime = std::chrono::high_resolution_clock::now() + timerDuration;
        platform_specific::startNativeTimer<P>();
        state = TimerState::Running;
    }

    template<Platform P>
    void FlexifyTimer<P>::stop() {
        if (state != TimerState::Running) return;
        timerDuration = std::chrono::duration_cast<std::chrono::milliseconds>(
                endTime - std::chrono::high_resolution_clock::now());
        platform_specific::stopNativeTimer<P>();
        state = TimerState::Paused;
    }

    template<Platform P>
    void FlexifyTimer<P>::expire() {
        stop();
        state = TimerState::Expired;
        timerDuration = 0ms;
        totalTimerDuration = 0ms;
    }

    template<Platform P>
    void FlexifyTimer<P>::increaseDuration(std::chrono::milliseconds increase) {
        const bool wasRunning = isRunning();
        if (wasRunning) stop();
        timerDuration += increase;
        totalTimerDuration += increase;
        if (wasRunning) start();
    }

}

#endif //NATIVE_TIMER_H
