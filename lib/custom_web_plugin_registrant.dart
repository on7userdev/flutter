// Manual web plugin registration for environments where the generated
// registrant is unavailable.
// This file is only imported on web builds.

// ignore_for_file: unused_import

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';

void ensureManualWebPluginRegistration() {
  // The webPluginRegistrar is provided by flutter_web_plugins at runtime.
  final Registrar registrar = webPluginRegistrar;
  // Register core first, then dependent plugins.
  FirebaseCoreWeb.registerWith(registrar);
  FirebaseFirestoreWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
