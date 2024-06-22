//
// Created by joseph on 21/06/24.
//

#ifndef NATIVE_TIMER_SERVICE_H
#define NATIVE_TIMER_SERVICE_H

#include <thread>
#include <string>
#include <chrono>
#include <optional>
#include <sstream>
#include <iostream>

#include "timer.h"
#include "platform.h"


namespace flexify {
    const std::chrono::milliseconds ONE_MINUTE_MILLI = 1min;

    template <Platform P>
    class TimerService {
    public:
        TimerService();

        void start(
                std::string pDescription,
                std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> timestamp,
                std::chrono::milliseconds duration
                );

        void add(std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> timestamp);
        void stop();

        inline bool isRunning() { return timer.isRunning(); }
    private:
        void update();

        bool shouldVibrate;
        std::string alarmSound;

        std::thread updateLoop;
        std::string description;
        FlexifyTimer<P> timer = FlexifyTimer<P>::emptyTimer();
    };


    template<Platform P>
    TimerService<P>::TimerService() {
    }

    template<Platform P>
    void TimerService<P>::start(std::string pDescription,
                                std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> timestamp,
                                std::chrono::milliseconds duration
    ) {
        timer.expire();
        if (updateLoop.joinable()) updateLoop.join();
        timer = FlexifyTimer<P>(duration);
        description = std::move(pDescription);

        // TODO: IMPLEMENT ALARM AND VIBRATE
        // alarmSound = sharedPrefs.getString("flutter.alarmSound", null);
        // shouldVibrate = sharedPrefs.getBoolean("flutter.vibrate", true);

        timer.start(timestamp.has_value() ? std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::high_resolution_clock::now() - timestamp.value()) : 0ms);

        // TODO: platform_specific::showNotification<P>();
        // TODO: start notification loop
        updateLoop = std::thread(&TimerService<P>::update, this);
    }

    template<Platform P>
    void TimerService<P>::add(std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> timestamp) {
        platform_specific::stopAttention<P>();

        if (timer.hasExpired()) return start(description, timestamp, ONE_MINUTE_MILLI);

        timer.increaseDuration(ONE_MINUTE_MILLI);
        //platform_specific::updateCountdownNotification<P>();

        // TODO if add is from notification then we need to update app UI
    }

    template<Platform P>
    void TimerService<P>::stop() {
        timer.expire();
        platform_specific::stopAttention<P>();

        // TODO if stop from notification update app UI
        platform_specific::stopNotification<P>();
    }

    inline std::string formatRemainingSeconds(std::chrono::seconds sec) {
        const auto minutes = std::chrono::duration_cast<std::chrono::minutes>(sec);
        const auto seconds = sec - minutes;

        std::stringstream ss;
        ss << (minutes.count() < 10 ? "0" : "") << minutes.count() << (seconds.count() < 10 ? ":0" : ":") << seconds.count();
        std::cout << ss.str() << std::endl;
        return ss.str();
    }

    template<Platform P>
    void TimerService<P>::update() {
        std::cout << "UPDATE THREAD RUNNING LOLOLO" << timer.hasExpired() << std::endl;
        while (!timer.hasExpired()) {
            if (timer.hasSecondsUpdated()) platform_specific::updateCountdownNotification<P>(description,formatRemainingSeconds(timer.getRemainingSeconds()));
            std::this_thread::sleep_for(1min / 60);
        }
    }
}

#endif //NATIVE_TIMER_SERVICE_H
