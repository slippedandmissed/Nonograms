import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Key;
import 'package:nonograms/dashboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nonograms/import_settings_page.dart';
import 'package:image/image.dart';
import 'package:nonograms/nonogram.dart';
import 'package:nonograms/play.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Screen|Page,Route")
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: "/",
          page: DashboardRoute.page,
        ),
        AutoRoute(
          path: "/import-image",
          page: ImportSettingsRoute.page,
        ),
        AutoRoute(
          path: "/play",
          page: PlayRoute.page,
        )
      ];
}

final routerProvider = Provider(
  (ref) => AppRouter(),
);
