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
        std::cout << "showFinishedNotification()" << std::endl;
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
        std::cout << "updateCountdownNotification()" << std::endl;
    }

    template <>
    void stopNotification<Linux>() {
        if (notification) notify_notification_close(notification, nullptr);
        std::cout << "stopNotification()" << std::endl;
    }

    template <>
    void sendTickPayload<Linux>(int64_t* payload, size_t size) {
        if (!methodChannel) return;
        FlValue* value = fl_value_new_int64_list(payload, 4);
        fl_method_channel_invoke_method(methodChannel, "tick", value, nullptr, nullptr, nullptr);
    }
}