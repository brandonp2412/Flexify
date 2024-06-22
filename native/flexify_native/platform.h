//
// Created by joseph on 21/06/24.
//

#ifndef NATIVE_PLATFORM_H
#define NATIVE_PLATFORM_H


namespace flexify {

    enum Platform {
        Linux,
        Windows
    };

    template <typename CallbackT>
    struct NotificationActionHandlers {
        CallbackT stop;
        CallbackT addOneMin;
    };

    namespace platform_specific {

        template <Platform P, typename CallbackT>
        void nativeCodeInit(NotificationActionHandlers<CallbackT> callback);

        template <Platform P>
        void startNativeTimer();

        template <Platform P>
        void stopNativeTimer();

        template <Platform P>
        void startAttention();

        template <Platform P>
        void stopAttention();

        template <Platform P>
        void showFinishedNotification(const std::string& description);

        template <Platform P>
        void updateCountdownNotification(const std::string& description, const std::string& remainingTime);

        template <Platform P>
        void stopNotification();
    }
}

#endif //NATIVE_PLATFORM_H
