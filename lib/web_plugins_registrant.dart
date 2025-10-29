// Web-only plugin registration forwarder.
// This file is conditionally imported only on web builds.

// ignore: uri_does_not_exist
import 'generated_plugin_registrant.dart' as generated;

void ensureWebPluginRegistration() {
  // The generated registrant is created by Flutter's build for web and
  // provides a registerPlugins() method that wires up web implementations.
  // If it isn't present at analysis time, the conditional import ensures
  // this file isn't used on non-web builds.
  // ignore: undefined_function
  generated.registerPlugins();
}
