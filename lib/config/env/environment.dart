import 'package:boilerplate_app/config/env/env.dart';
import 'package:flutter/foundation.dart';

String get baseUrl => kReleaseMode ? DevEnv.baseUrl : ProdEnv.baseUrl;


 