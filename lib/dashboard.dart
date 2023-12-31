import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nonograms/game.dart';
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/import_settings_page.dart';
import 'package:nonograms/play.dart';
import 'package:nonograms/router/router.dart';

@RoutePage()
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  List<Game?>? _games;

  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    ref.read(storedGamesProvider).addListener(_loadGames);
    _loadGames();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    final storedGames = ref.read(storedGamesProvider);
    setState(() {
      _games = null;
    });
    final gameIds = await storedGames.getGameIds();
    setState(() {
      _games = List.generate(gameIds.length, (index) => null);
    });
    for (int i = 0; i < gameIds.length; i++) {
      final gameId = gameIds[i];
      storedGames.getGame(gameId).then((game) {
        setState(() {
          _games![i] = game;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final addButton = FloatingActionButton(
      onPressed: () async {
        final picker = ImagePicker();
        final selected = await picker.pickImage(source: ImageSource.gallery);
        if (selected == null) {
          return;
        }
        final bytes = await selected.readAsBytes();
        final image = await loadImage(bytes);
        if (image == null) {
          return;
        }
        if (mounted) context.router.push(ImportSettingsRoute(image: image));
      },
      child: const Icon(Icons.add),
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Nonograms")),
      body: _games == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _games!.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "You don't have any games!",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text("Click the button below to get started."),
                      const SizedBox(
                        height: 32,
                      ),
                      addButton,
                    ],
                  ),
                )
              : PageView(
                  controller: _pageController,
                  children: [
                    for (final game in _games!)
                      game == null
                          ? const Center(child: CircularProgressIndicator())
                          : SavedGamePreview(game: game),
                  ],
                ),
      floatingActionButton:
          _games == null || _games!.isEmpty ? null : addButton,
    );
  }
}

final imagePathProvider =
    FutureProvider.family<String, String>((ref, filename) async {
  return await getFilePath(filename);
});

class SavedGamePreview extends ConsumerWidget {
  const SavedGamePreview({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(imagePathProvider(game.imagePath));
    final nonogramSet = game.progress;
    var imageWidth =
        (nonogramSet.mosaicWidth - 1) * nonogramSet.kernels[0][0].gridWidth +
            nonogramSet.kernels[0][nonogramSet.kernels[0].length - 1].gridWidth;
    var imageHeight =
        (nonogramSet.mosaicHeight - 1) * nonogramSet.kernels[0][0].gridHeight +
            nonogramSet.kernels[nonogramSet.kernels.length - 1][0].gridHeight;

    final wins = List.generate(
      game.nonogramSet.mosaicHeight,
      (i) => List.generate(
        game.nonogramSet.mosaicWidth,
        (j) => doesWin(game.nonogramSet.kernels[i][j].solution,
            game.progress.kernels[i][j].solution),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: imagePath.when(
              data: (imagePath) => Image(
                image: FileImage(
                  File(imagePath),
                ),
                width: 200,
              ),
              loading: () => const SizedBox(
                  width: 200, height: 200, child: CircularProgressIndicator()),
              error: (e, __) => Text("$e"),
            ),
          ),
          const SizedBox(height: 32),
          GridPreview(
            imageWidth: imageWidth,
            imageHeight: imageHeight,
            kernelWidth: nonogramSet.kernels[0][0].gridWidth,
            kernelHeight: nonogramSet.kernels[0][0].gridHeight,
            totalWidth: 300,
            nonogramView: true,
            nonogram: nonogramSet,
            wins: wins,
            onTap: (kernelX, kernelY) {
              context.router.push(PlayRoute(
                gameId: game.id,
                solution: game.nonogramSet.kernels[kernelY][kernelX],
                progress: game.progress.kernels[kernelY][kernelX],
                kernelX: kernelX,
                kernelY: kernelY,
              ));
            },
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              showAlertDialog(
                context,
                onContinue: () async {
                  await ref
                      .read(storedGamesProvider)
                      .deleteGame(game.id, game.imagePath);
                },
              );
            },
            child: const Icon(Icons.delete_forever, size: 32),
          ),
          const SizedBox(height: 128),
        ],
      ),
    );
  }
}

showAlertDialog(BuildContext context, {required Function() onContinue}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text("Cancel"),
  );
  Widget continueButton = TextButton(
    onPressed: () {
      Navigator.pop(context);
      onContinue();
    },
    child: const Text("Continue"),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Delete Game"),
    content: const Text(
        "Are you sure you want to delete this game? All of your progress will be lost"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
