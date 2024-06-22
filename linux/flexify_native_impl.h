//
// Created by joseph on 21/06/24.
//

#ifndef RUNNER_FLEXIFY_NATIVE_IMPL_H
#define RUNNER_FLEXIFY_NATIVE_IMPL_H

#include <flexify_native/channel.h>
#include <flexify_native/timestamp.h>
#include <flexify_native/timer_service.h>

#include <libnotify/notify.h>

namespace flexify::platform_specific {

    void initLinux(FlMethodChannel* channel);

    template <>
    void nativeCodeInit<Linux>(NotificationActionHandlers<NotifyActionCallback> callback);

    template <>
    TimerService<Linux>& getTimerService();

    template <>
    void startNativeTimer<Linux>();

    template <>
    void stopNativeTimer<Linux>();

    template <>
    void startAttention<Linux>();

    template <>
    void stopAttention<Linux>();

    template <>
    void showFinishedNotification<Linux>(const std::string& description);

    template <>
    void updateCountdownNotification<Linux>(const std::string& description, const std::string& remainingTime);

    template <>
    void stopNotification<Linux>();

    template <>
    void sendTickPayload<Linux>(int64_t* payload, size_t size);
}

#endif //RUNNER_FLEXIFY_NATIVE_IMPL_H
