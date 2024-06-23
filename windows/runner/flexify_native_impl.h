//
// Created by joseph on 21/06/24.
//

#ifndef RUNNER_FLEXIFY_NATIVE_IMPL_H
#define RUNNER_FLEXIFY_NATIVE_IMPL_H

#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>

#include <flexify_native/channel.h>
#include <flexify_native/timestamp.h>
#include <flexify_native/timer_service.h>


namespace flexify::platform_specific {

    void initWindows(std::unique_ptr<flutter::MethodChannel<>> channel);

    void timer_method_call_handler(const flutter::MethodCall<>& call, std::unique_ptr<flutter::MethodResult<>> result);

    using NotifyActionCallback = void (*) (int*);

    template <>
    void nativeCodeInit<Windows>(NotificationActionHandlers<NotifyActionCallback> callback);

    template <>
    TimerArgs getTimerArgs<Windows>(const flutter::MethodCall<>& call, flutter::MethodResult<>* result);

    template <>
    std::optional<std::chrono::time_point<fclock_t>> getAddArgs<Windows>(const flutter::MethodCall<>& call, flutter::MethodResult<>* result);

    template<>
    void sendResult<Windows, flutter::MethodResult<>*, true>(flutter::MethodResult<>* result);

    template<>
    void sendResult<Windows, flutter::MethodResult<>*, false>(flutter::MethodResult<>* result);

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

    template <>
    void sendTickPayload<Windows>(int64_t* payload, size_t size);
}

#endif //RUNNER_FLEXIFY_NATIVE_IMPL_H
