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
    PlayRoute.name: (routeData) {
      final args = routeData.argsAs<PlayRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: PlayPage(
          key: args.key,
          gameId: args.gameId,
          solution: args.solution,
          progress: args.progress,
          kernelX: args.kernelX,
          kernelY: args.kernelY,
        ),
      );
    },
    DashboardRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
  };
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

/// generated route for
/// [PlayPage]
class PlayRoute extends PageRouteInfo<PlayRouteArgs> {
  PlayRoute({
    Key? key,
    required String gameId,
    required Nonogram solution,
    required Nonogram progress,
    required int kernelX,
    required int kernelY,
    List<PageRouteInfo>? children,
  }) : super(
          PlayRoute.name,
          args: PlayRouteArgs(
            key: key,
            gameId: gameId,
            solution: solution,
            progress: progress,
            kernelX: kernelX,
            kernelY: kernelY,
          ),
          initialChildren: children,
        );

  static const String name = 'PlayRoute';

  static const PageInfo<PlayRouteArgs> page = PageInfo<PlayRouteArgs>(name);
}

class PlayRouteArgs {
  const PlayRouteArgs({
    this.key,
    required this.gameId,
    required this.solution,
    required this.progress,
    required this.kernelX,
    required this.kernelY,
  });

  final Key? key;

  final String gameId;

  final Nonogram solution;

  final Nonogram progress;

  final int kernelX;

  final int kernelY;

  @override
  String toString() {
    return 'PlayRouteArgs{key: $key, gameId: $gameId, solution: $solution, progress: $progress, kernelX: $kernelX, kernelY: $kernelY}';
  }
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
