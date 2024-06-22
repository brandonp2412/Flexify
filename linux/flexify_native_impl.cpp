//
// Created by joseph on 21/06/24.
//

#include "flexify_native_impl.h"
#include <iostream>
#include <libnotify/notify.h>

flexify::TimerService<flexify::Linux> timer_service;
FlMethodChannel* methodChannel = nullptr;

namespace flexify::platform_specific
{
    void initLinux(FlMethodChannel* channel) {
        methodChannel = channel;
        timer_service = flexify::TimerService<flexify::Linux>();
        flexify::platform_specific::nativeCodeInit<flexify::Linux, NotifyActionCallback>({
            [](NotifyNotification *notification, char *action, gpointer user_data){
                timer_service.stop();
                },
            [](NotifyNotification *notification, char *action, gpointer user_data){
                timer_service.add(std::nullopt);
                timer_service.updateAppUI();
            }
        });
    }

    void timer_method_call_handler(FlMethodChannel* flChannel, FlMethodCall* method_call, gpointer user_data) {
        if (strcmp(fl_method_call_get_name(method_call), "timer") == 0) flexify::handleMethodCall<Linux, MethodCall::Timer, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else if (strcmp(fl_method_call_get_name(method_call), "add") == 0) flexify::handleMethodCall<Linux, MethodCall::Add, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else if (strcmp(fl_method_call_get_name(method_call), "stop") == 0) flexify::handleMethodCall<Linux, MethodCall::Stop, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else {
            flexify::platform_specific::sendResult<Linux, FlMethodCall*, false>(method_call);
        }
    }

    template <>
    TimerArgs getTimerArgs<Linux>(FlMethodChannel* channel, FlMethodCall* methodCall) {
        FlValue* args = fl_method_call_get_args(methodCall);

        FlValue* titleValue = fl_value_lookup_string(args, "title");
        FlValue* timestampValue = fl_value_lookup_string(args, "timestamp");
        FlValue* restMsValue = fl_value_lookup_string(args, "restMs");

        std::string title;
        std::optional<std::chrono::time_point<fclock_t>> timestamp;
        std::chrono::milliseconds restMs;

        if (titleValue != nullptr && fl_value_get_type(titleValue) == FL_VALUE_TYPE_STRING) {
            title = fl_value_get_string(titleValue);
        }

        if (timestampValue != nullptr && fl_value_get_type(timestampValue) == FL_VALUE_TYPE_INT) {
            timestamp = flexify::convertLongToTimePoint(fl_value_get_int(timestampValue));
        }

        if (restMsValue != nullptr && fl_value_get_type(restMsValue) == FL_VALUE_TYPE_INT) {
            restMs = std::chrono::milliseconds(fl_value_get_int(restMsValue));
        } else restMs = std::chrono::milliseconds (210000);

        return { title, timestamp, restMs };
    }

    template <>
    std::optional<std::chrono::time_point<fclock_t>> getAddArgs<Linux>(FlMethodChannel* channel, FlMethodCall* methodCall) {
        FlValue* args = fl_method_call_get_args(methodCall);
        FlValue* timestamp = fl_value_lookup_string(args, "timestamp");
        if (timestamp != nullptr || fl_value_get_type(timestamp) == FL_VALUE_TYPE_INT)
        {
            return flexify::convertLongToTimePoint(fl_value_get_int(timestamp));
        }
        return std::nullopt;
    }

    template<>
    void sendResult<Linux, FlMethodCall*, true>(FlMethodCall* result) {
        g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        g_autoptr(GError) error = nullptr;
        if (!fl_method_call_respond(result, response, &error)) {
            g_warning("Failed to send response: %s", error->message);
        }
    }

    template<>
    void sendResult<Linux, FlMethodCall*, false>(FlMethodCall* result) {
        g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
        g_autoptr(GError) error = nullptr;
        if (!fl_method_call_respond(result, response, &error)) {
            g_warning("Failed to send response: %s", error->message);
        }
    }

    NotificationActionHandlers<NotifyActionCallback> callbacks;

    template <>
    void nativeCodeInit<Linux>(NotificationActionHandlers<NotifyActionCallback> callback) {
        notify_init("flexify");
        callbacks = callback;
    }

    template <>
    TimerService<Linux>& getTimerService() {
        return timer_service;
    }

    template <>
    void startNativeTimer<Linux>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void stopNativeTimer<Linux>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void startAttention<Linux>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    template <>
    void stopAttention<Linux>() {
        /* TODO: SHOULD THIS BE IMPLEMENTED? */
    }

    NotifyNotification *notification;
    template <>
    void showFinishedNotification<Linux>(const std::string& description) {
        if (!notification) {
            notification = notify_notification_new("Timer Finished", description.c_str(), 0);
        } else {
            notify_notification_update(notification, "Timer Finished", description.c_str(), 0);
        }

        notify_notification_set_urgency(notification, NotifyUrgency::NOTIFY_URGENCY_CRITICAL);
        notify_notification_set_timeout(notification, 60000); /* TODO: HOW LONG SHOULD WE BE HERE FOR */
        if (!notify_notification_show(notification, nullptr)) std::cerr << "Notification failed to show!" << std::endl;
    }

    template <>
    void updateCountdownNotification<Linux>(const std::string& description, const std::string& remainingTime) {
        if (!notification) {
            notification = notify_notification_new(description.c_str(), remainingTime.c_str(), 0);
            notify_notification_add_action(notification, "action_click", "Add One Minute", callbacks.addOneMin, nullptr, nullptr);
            notify_notification_add_action(notification, "action_close", "Stop", callbacks.stop, nullptr, nullptr);
            notify_notification_set_timeout(notification, 1000);
        } else {
            notify_notification_update(notification, description.c_str(), remainingTime.c_str(), 0);
            notify_notification_set_timeout(notification, 1000);
        }

        notify_notification_set_urgency(notification, NotifyUrgency::NOTIFY_URGENCY_NORMAL);
        if (!notify_notification_show(notification, nullptr)) std::cerr << "Notification failed to show!" << std::endl;
    }

    template <>
    void stopNotification<Linux>() {
        if (notification) notify_notification_close(notification, nullptr);
    }

    template <>
    void sendTickPayload<Linux>(int64_t* payload, size_t size) {
        if (!methodChannel) return;
        FlValue* value = fl_value_new_int64_list(payload, 4);
        fl_method_channel_invoke_method(methodChannel, "tick", value, nullptr, nullptr, nullptr);
    }
}
