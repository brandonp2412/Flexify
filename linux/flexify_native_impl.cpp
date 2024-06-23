//
// Created by joseph on 21/06/24.
//

#include "flexify_native_impl.h"
#include <iostream>
#include <filesystem>
#include <libnotify/notify.h>

namespace flexify::platform_specific
{


    struct FlexifyApplicationData {
        FlexifyApplicationData() : methodChannel(nullptr), notification(nullptr) {}

        FlexifyApplicationData(FlMethodChannel* channel) : iconPath(std::filesystem::canonical("/proc/self/exe").parent_path() += "/data/flutter_assets/assets/ic_launcher.png"),
                                                           methodChannel(channel),
                                                           notification(nullptr),
                                                           timer_service(std::make_unique<flexify::TimerService<flexify::Linux>>())
                                                           {}
        std::string iconPath;
        FlMethodChannel* methodChannel;
        NotifyNotification *notification;
        std::unique_ptr<flexify::TimerService<flexify::Linux>> timer_service;
    };

    FlexifyApplicationData applicationData;

    void initLinux(FlMethodChannel* channel) {
        applicationData = FlexifyApplicationData(channel);
        flexify::platform_specific::nativeCodeInit<flexify::Linux, NotifyActionCallback>({
            [](NotifyNotification *notification, char *action, gpointer user_data){
                applicationData.timer_service->stop();
                },
            [](NotifyNotification *notification, char *action, gpointer user_data){
                applicationData.timer_service->add(std::nullopt);
                applicationData.timer_service->updateAppUI();
            }
        });
    }

    void timer_method_call_handler(FlMethodChannel* flChannel, FlMethodCall* method_call, gpointer) {
        if (strcmp(fl_method_call_get_name(method_call), "timer") == 0) flexify::handleMethodCall<Linux, MethodCall::Timer, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else if (strcmp(fl_method_call_get_name(method_call), "add") == 0) flexify::handleMethodCall<Linux, MethodCall::Add, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else if (strcmp(fl_method_call_get_name(method_call), "stop") == 0) flexify::handleMethodCall<Linux, MethodCall::Stop, FlMethodChannel*, FlMethodCall*>(flChannel, method_call);
        else {
            flexify::platform_specific::sendResult<Linux, FlMethodCall*, false>(method_call);
        }
    }

    template <>
    TimerArgs getTimerArgs<Linux>(FlMethodChannel*, FlMethodCall* methodCall) {
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
    std::optional<std::chrono::time_point<fclock_t>> getAddArgs<Linux>(FlMethodChannel*, FlMethodCall* methodCall) {
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
        return *applicationData.timer_service;
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


    template <>
    void showFinishedNotification<Linux>(const std::string& description) {
        if (!applicationData.notification) {
            applicationData.notification = notify_notification_new("Timer Finished", description.c_str(), applicationData.iconPath.c_str());
        } else {
            notify_notification_update(applicationData.notification, "Timer Finished", description.c_str(), applicationData.iconPath.c_str());
        }

        notify_notification_set_urgency(applicationData.notification, NotifyUrgency::NOTIFY_URGENCY_CRITICAL);
        notify_notification_set_timeout(applicationData.notification, 60000); /* TODO: HOW LONG SHOULD WE BE HERE FOR */
        if (!notify_notification_show(applicationData.notification, nullptr)) std::cerr << "Notification failed to show!" << std::endl;
    }

    template <>
    void updateCountdownNotification<Linux>(const std::string& description, const std::string& remainingTime) {
        if (!applicationData.notification) {
            applicationData.notification = notify_notification_new(description.c_str(), remainingTime.c_str(), applicationData.iconPath.c_str());
            notify_notification_add_action(applicationData.notification, "action_close", "Stop", callbacks.stop, nullptr, nullptr);
            notify_notification_add_action(applicationData.notification, "action_click", "Add 1 min", callbacks.addOneMin, nullptr, nullptr);
            notify_notification_set_timeout(applicationData.notification, NOTIFY_EXPIRES_NEVER);
        } else {
            notify_notification_update(applicationData.notification, description.c_str(), remainingTime.c_str(), applicationData.iconPath.c_str());
        }

        notify_notification_set_urgency(applicationData.notification, NotifyUrgency::NOTIFY_URGENCY_NORMAL);
        if (!notify_notification_show(applicationData.notification, nullptr)) std::cerr << "Notification failed to show!" << std::endl;
    }

    template <>
    void stopNotification<Linux>() {
        if (applicationData.notification) notify_notification_close(applicationData.notification, nullptr);
    }

    template <>
    void sendTickPayload<Linux>(int64_t* payload, size_t size) {
        if (!applicationData.methodChannel) return;
        FlValue* value = fl_value_new_int64_list(payload, size);
        fl_method_channel_invoke_method(applicationData.methodChannel, "tick", value, nullptr, nullptr, nullptr);
    }
}
