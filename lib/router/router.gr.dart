// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    ImportSettingsRoute.name: (routeData) {
      final args = routeData.argsAs<ImportSettingsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ImportSettingsPage(
          key: args.key,
          image: args.image,
        ),
      );
    },
  };
}

/// generated route for
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
      : super(
          DashboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'DashboardRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ImportSettingsPage]
class ImportSettingsRoute extends PageRouteInfo<ImportSettingsRouteArgs> {
  ImportSettingsRoute({
    Key? key,
    required Image image,
    List<PageRouteInfo>? children,
  }) : super(
          ImportSettingsRoute.name,
          args: ImportSettingsRouteArgs(
            key: key,
            image: image,
          ),
          initialChildren: children,
        );

  static const String name = 'ImportSettingsRoute';

  static const PageInfo<ImportSettingsRouteArgs> page =
      PageInfo<ImportSettingsRouteArgs>(name);
}

class ImportSettingsRouteArgs {
  const ImportSettingsRouteArgs({
    this.key,
    required this.image,
  });

  final Key? key;

  final Image image;

  @override
  String toString() {
    return 'ImportSettingsRouteArgs{key: $key, image: $image}';
  }
}
