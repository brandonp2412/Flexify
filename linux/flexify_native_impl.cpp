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
    void nativeCodeInit<Windows>(NotificationActionHandlers<NotifyActionCallback> callback) {
        notify_init("flexify");
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


    NotifyNotification *notification;
    template <>
    void showFinishedNotification<Windows>(const std::string& description) {

        std::cout << "showFinishedNotification()" << std::endl;
    }



    template <>
    void updateCountdownNotification<Windows>(const std::string& description, const std::string& remainingTime) {

        std::cout << "updateCountdownNotification()" << std::endl;
    }

    template <>
    void stopNotification<Windows>() {

        std::cout << "stopNotification()" << std::endl;
    }

    template <>
    void sendTickPayload<Windows>(int64_t* payload, size_t size) {
        if (!methodChannel) return;

    }
}