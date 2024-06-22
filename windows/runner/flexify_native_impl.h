//
// Created by joseph on 21/06/24.
//

#ifndef RUNNER_FLEXIFY_NATIVE_IMPL_H
#define RUNNER_FLEXIFY_NATIVE_IMPL_H

#include <flexify_native/channel.h>
#include <flexify_native/timestamp.h>
#include <flexify_native/timer_service.h>

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>


namespace flexify::platform_specific {

    struct NotifyActionCallback;

    void initWindows(flutter::MethodChannel<>& channel);

    template <>
    void nativeCodeInit<Windows>(NotificationActionHandlers<NotifyActionCallback> callback);

    template <>
    TimerService<Windows>& getTimerService();

    template <>
    void startNativeTimer<Windows>();

    template <>
    void stopNativeTimer<Windows>();

    template <>
    void startAttention<Windows>();

    template <>
    void stopAttention<Windows>();

    template <>
    void showFinishedNotification<Windows>(const std::string& description);

    template <>
    void updateCountdownNotification<Windows>(const std::string& description, const std::string& remainingTime);

    template <>
    void stopNotification<Windows>();
}

#endif //RUNNER_FLEXIFY_NATIVE_IMPL_H
