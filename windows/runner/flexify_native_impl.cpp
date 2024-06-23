//
// Created by joseph on 21/06/24.
//

#include "flexify_native_impl.h"

#include <iostream>

flexify::TimerService<flexify::Windows> timer_service;
std::unique_ptr<flutter::MethodChannel<>> methodChannel;

namespace flexify::platform_specific
{
    void initWindows(std::unique_ptr<flutter::MethodChannel<>> channel) {
        methodChannel = std::move(channel);
        timer_service = flexify::TimerService<flexify::Windows>();
        /*
        flexify::platform_specific::nativeCodeInit<flexify::Windows, NotifyActionCallback>({
            [](NotifyNotification *notification, char *action, gpointer user_data){
                timer_service.stop();
                },
            [](NotifyNotification *notification, char *action, gpointer user_data){
                timer_service.add(std::nullopt);
                timer_service.updateAppUI();
            }
        });*/
    }

    void timer_method_call_handler(const flutter::MethodCall<>& call, const std::unique_ptr<flutter::MethodResult<>>& result) {
        if (call.method_name() == "timer") flexify::handleMethodCall<Windows, MethodCall::Timer, const flutter::MethodCall<>*, flutter::MethodResult<>*>(&call, result.get());
        else if (call.method_name() == "add") flexify::handleMethodCall<Windows, MethodCall::Add, const flutter::MethodCall<>*, flutter::MethodResult<>*>(&call, result.get());
        else if (call.method_name() == "stop") flexify::handleMethodCall<Windows, MethodCall::Stop, const flutter::MethodCall<>*, flutter::MethodResult<>*>(&call, result.get());
        else {
            flexify::platform_specific::sendResult<Windows, flutter::MethodResult<>*, false>(result.get());
        }
    }

    template <>
    TimerArgs getTimerArgs<Windows>(const flutter::MethodCall<>* call, flutter::MethodResult<>* result) {
        const auto& args = std::get<flutter::EncodableMap>(*call->arguments());

        std::string title;
        std::optional<std::chrono::time_point<fclock_t>> timestamp;
        std::chrono::milliseconds restMs;

        if (const auto titleValue = args.find(flutter::EncodableValue("title")); titleValue != args.end()) {
            title = std::get<std::string>(titleValue->second);
        }

        if (const auto timestampValue = args.find(flutter::EncodableValue("timestamp")); timestampValue != args.end()) {
            timestamp = flexify::convertLongToTimePoint(std::get<int64_t>(timestampValue->second));
        }

        if (const auto restMsValue = args.find(flutter::EncodableValue("restMs")); restMsValue != args.end()) {
            restMs = std::chrono::milliseconds(std::get<int64_t>(restMsValue->second));
        } else restMs = std::chrono::milliseconds (210000);

        return { title, timestamp, restMs };
    }

    template <>
    std::optional<std::chrono::time_point<fclock_t>> getAddArgs<Windows>(const flutter::MethodCall<>* call, flutter::MethodResult<>* result) {
        const auto& args = std::get<flutter::EncodableMap>(*call->arguments());
        if (const auto timestamp = args.find(flutter::EncodableValue("timestamp")); timestamp != args.end())
        {
            return flexify::convertLongToTimePoint(std::get<int64_t>(timestamp->second));
        }
        return std::nullopt;
    }

    template<>
    void sendResult<Windows, flutter::MethodResult<>*, true>(flutter::MethodResult<>* result) {
        result->NotImplemented();
    }

    template<>
    void sendResult<Windows, flutter::MethodResult<>*, false>(flutter::MethodResult<>* result) {
        result->Success();
    }

    NotificationActionHandlers<NotifyActionCallback> callbacks;

    template <>
    void nativeCodeInit<Windows>(NotificationActionHandlers<NotifyActionCallback> callback) {

        callbacks = callback;
    }

    template <>
    TimerService<Windows>& getTimerService() {
        return timer_service;
    }

    template <>
    void startNativeTimer<Windows>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void stopNativeTimer<Windows>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void startAttention<Windows>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void stopAttention<Windows>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }


    template <>
    void showFinishedNotification<Windows>(const std::string& description) {

    }

    template <>
    void updateCountdownNotification<Windows>(const std::string& description, const std::string& remainingTime) {

    }

    template <>
    void stopNotification<Windows>() {

    }

    template <>
    void sendTickPayload<Windows>(int64_t* payload, size_t size) {
        if (!methodChannel) return;
        methodChannel->InvokeMethod("tick", std::make_unique<flutter::EncodableValue>((payload, payload + size - 1)),nullptr);
    }
}
