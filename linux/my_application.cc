#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"
#include "flexify_native_impl.h"
#include <chrono>
#include <iostream>


struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  FlMethodChannel* timer_channel;
};



G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

flexify::TimerService<flexify::Linux> timer_service = flexify::TimerService<flexify::Linux>();

static void timer_method_call_handler(FlMethodChannel* channel,
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
        std::optional<std::chrono::time_point<std::chrono::high_resolution_clock>> timestamp;
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

        timer_service.start(title, timestamp, restMs);
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if (strcmp(fl_method_call_get_name(method_call), "add") == 0) {
        if (!timer_service.isRunning()) {
            FlValue* args = fl_method_call_get_args(method_call);
            FlValue* timestamp = fl_value_lookup_string(args, "timestamp");
            if (timestamp != nullptr || fl_value_get_type(timestamp) == FL_VALUE_TYPE_INT)
            {
                timer_service.start("Rest timer", flexify::convertLongToTimePoint(fl_value_get_int(timestamp)), flexify::ONE_MINUTE_MILLI);
            }
        } else {
            timer_service.add(std::nullopt);
        }
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else if (strcmp(fl_method_call_get_name(method_call), "stop") == 0) {
        timer_service.stop();
        response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    } else {
        response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    }

    g_autoptr(GError) error = nullptr;
    if (!fl_method_call_respond(method_call, response, &error)) {
        g_warning("Failed to send response: %s", error->message);
    }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "flexify");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "flexify");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->timer_channel = fl_method_channel_new(
            fl_engine_get_binary_messenger(fl_view_get_engine(view)),
            "com.presley.flexify/timer", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->timer_channel, timer_method_call_handler, self, nullptr);

  flexify::platform_specific::nativeCodeInit<flexify::Linux, NotifyActionCallback>({
      [](NotifyNotification *notification, char *action, gpointer user_data){ timer_service.stop(); },
      [](NotifyNotification *notification, char *action, gpointer user_data){ timer_service.add(std::nullopt); }
  });

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_object(&self->timer_channel);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}
