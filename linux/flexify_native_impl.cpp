//
// Created by joseph on 21/06/24.
//

#include "flexify_native_impl.h"
#include <iostream>
#include <libnotify/notify.h>

namespace flexify::platform_specific
{

    NotificationActionHandlers<NotifyActionCallback> callbacks;

    template <>
    void nativeCodeInit<Linux>(NotificationActionHandlers<NotifyActionCallback> callback) {
        notify_init("flexify");
        callbacks = callback;
    }

    template <>
    void startNativeTimer<Linux>() {
        std::cout << "startNativeTimer()" << std::endl;
    }

    template <>
    void stopNativeTimer<Linux>() {
        std::cout << "stopNativeTimer()" << std::endl;
    }

    template <>
    void startAttention<Linux>() {
        std::cout << "startAttention()" << std::endl;
    }

    template <>
    void stopAttention<Linux>() {
        std::cout << "stopAttention()" << std::endl;
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
        if (!notify_notification_show(notification, nullptr)) std::cerr << "Notification failed to show!" << std::endl;
        std::cout << "showFinishedNotification()" << std::endl;
    }



    template <>
    void updateCountdownNotification<Linux>(const std::string& description, const std::string& remainingTime) {
        if (!notification) {
            notification = notify_notification_new(description.c_str(), remainingTime.c_str(), 0);
            notify_notification_add_action(notification, "action_click", "Stop", callbacks.stop, nullptr, nullptr);
            notify_notification_add_action(notification, "action_click", "Add One Minute", callbacks.addOneMin, nullptr, nullptr);
            notify_notification_set_timeout(notification, 1000);
        } else {
            notify_notification_update(notification, description.c_str(), remainingTime.c_str(), 0);
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
}