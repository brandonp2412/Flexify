//
// Created by joseph on 22/06/24.
//

#ifndef NATIVE_HANDLER_H
#define NATIVE_HANDLER_H

#include "timestamp.h"
#include "timer_service.h"

#include <chrono>
#include <iostream>
#include <optional>
#include <flutter_linux/flutter_linux.h>

namespace flexify {

    template <Platform P>
    inline void timer_method_call_handler(FlMethodChannel* flChannel,
                                          FlMethodCall* method_call,
                                          gpointer user_data) {
        g_autoptr(FlMethodResponse) response = nullptr;

        std::cout << fl_method_call_get_name(method_call) << std::endl;

        if (strcmp(fl_method_call_get_name(method_call), "timer") == 0) {
            FlValue* args = fl_method_call_get_args(method_call);

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

            flexify::platform_specific::getTimerService<P>().start(title, timestamp, restMs);
            response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        } else if (strcmp(fl_method_call_get_name(method_call), "add") == 0) {
            auto& timerService = flexify::platform_specific::getTimerService<P>();
            if (!timerService.isRunning()) {
                FlValue* args = fl_method_call_get_args(method_call);
                FlValue* timestamp = fl_value_lookup_string(args, "timestamp");
                if (timestamp != nullptr || fl_value_get_type(timestamp) == FL_VALUE_TYPE_INT)
                {
                    timerService.start("Rest timer", flexify::convertLongToTimePoint(fl_value_get_int(timestamp)), flexify::ONE_MINUTE_MILLI);
                }
            } else {
                timerService.add(std::nullopt);
            }
            response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        } else if (strcmp(fl_method_call_get_name(method_call), "stop") == 0) {
            flexify::platform_specific::getTimerService<P>().stop();
            response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
        } else {
            response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
        }

        g_autoptr(GError) error = nullptr;
        if (!fl_method_call_respond(method_call, response, &error)) {
            g_warning("Failed to send response: %s", error->message);
        }
    }
}

#endif //NATIVE_HANDLER_H
