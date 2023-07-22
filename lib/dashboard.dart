import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nonograms/game.dart';
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/import_settings_page.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("Nonograms")),
      body: _games == null
          ? const Center(
              child: CircularProgressIndicator(),
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
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}

class SavedGamePreview extends StatelessWidget {
  const SavedGamePreview({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final nonogramSet = game.progress;
    var imageWidth =
        (nonogramSet.mosaicWidth - 1) * nonogramSet.kernels[0][0].gridWidth +
            nonogramSet.kernels[0][nonogramSet.kernels[0].length - 1].gridWidth;
    var imageHeight =
        (nonogramSet.mosaicHeight - 1) * nonogramSet.kernels[0][0].gridHeight +
            nonogramSet.kernels[nonogramSet.kernels.length - 1][0].gridHeight;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GridPreview(
          imageWidth: imageWidth,
          imageHeight: imageHeight,
          kernelWidth: nonogramSet.kernels[0][0].gridWidth,
          kernelHeight: nonogramSet.kernels[0][0].gridHeight,
          totalWidth: 300,
          nonogramView: true,
          nonogram: nonogramSet,
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
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Image.file(
            File(game.imagePath),
            width: 200,
          ),
        ),
      ],
    );
  }
}
