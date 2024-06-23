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
        ~TimerService();

        void start(
                std::string pDescription,
                std::optional<std::chrono::time_point<fclock_t>> timestamp,
                std::chrono::milliseconds duration
                );

        void add(std::optional<std::chrono::time_point<fclock_t>> timestamp);
        void stop();
        void updateAppUI();

        inline bool isRunning() { return timer.isRunning(); }
    private:
        void update();

        bool shouldVibrate;
        FlexifyTimer<P> timer;
        std::string alarmSound;

        std::thread updateLoop;
        std::string description;
    };

    template <Platform P>
    TimerService<P>::TimerService() : shouldVibrate(false), timer(FlexifyTimer<P>::emptyTimer()) {

    }


    template <Platform P>
    TimerService<P>::~TimerService() {
        timer.expire();
        platform_specific::stopAttention<P>();
        platform_specific::stopNotification<P>();
        if (updateLoop.joinable()) updateLoop.join();
    }

    template <Platform P>
    void TimerService<P>::start(std::string pDescription,
                                std::optional<std::chrono::time_point<fclock_t>> timestamp,
                                std::chrono::milliseconds duration
    ) {
        timer.expire();
        if (updateLoop.joinable()) updateLoop.join();
        timer = FlexifyTimer<P>(duration);
        description = std::move(pDescription);

        // TODO: IMPLEMENT ALARM AND VIBRATE
        // alarmSound = sharedPrefs.getString("flutter.alarmSound", null);
        // shouldVibrate = sharedPrefs.getBoolean("flutter.vibrate", true);

        timer.start(timestamp.has_value() ? std::chrono::duration_cast<std::chrono::milliseconds>(fclock_t::now() - timestamp.value()) : 0ms);
        updateLoop = std::thread(&TimerService<P>::update, this);
    }

    template <Platform P>
    void TimerService<P>::add(std::optional<std::chrono::time_point<fclock_t>> timestamp) {
        platform_specific::stopAttention<P>();
        if (timer.hasExpired()) return start(description, timestamp, ONE_MINUTE_MILLI);
        timer.increaseDuration(ONE_MINUTE_MILLI);
    }

    template <Platform P>
    void TimerService<P>::stop() {
        timer.expire();
        platform_specific::stopAttention<P>();
        platform_specific::stopNotification<P>();
        updateAppUI();
    }


    template <Platform P>
    void TimerService<P>::updateAppUI() {
        int64_t payload[4] = {
                timer.getDuration().count(),
                (timer.getDuration() - timer.getRemaining()).count(),
                std::chrono::duration_cast<std::chrono::milliseconds>(fclock_t::now().time_since_epoch()).count(),
                timer.getState()
        };
        
        flexify::platform_specific::sendTickPayload<P>(payload, 4);
    }

    inline std::string formatRemainingSeconds(std::chrono::seconds sec) {
        const auto minutes = std::chrono::duration_cast<std::chrono::minutes>(sec);
        const auto seconds = sec - minutes;

        std::stringstream ss;
        ss << (minutes.count() < 10 ? "0" : "") << minutes.count() << (seconds.count() < 10 ? ":0" : ":") << seconds.count();
        return ss.str();
    }

    template <Platform P>
    void TimerService<P>::update() {
        while (!timer.hasExpired() && !timer.shouldExpire()) {
            if (timer.hasSecondsUpdated()) {
                const auto remaining = timer.getRemainingSeconds();
                if (remaining.count() > 0) platform_specific::updateCountdownNotification<P>(description,formatRemainingSeconds(remaining));
            }
            std::this_thread::sleep_for(1s / 60);
        }

        if (timer.shouldExpire()) {
            timer.expire();
            updateAppUI();
            platform_specific::showFinishedNotification<P>(description);
        }
    }
}

#endif //NATIVE_TIMER_SERVICE_H
