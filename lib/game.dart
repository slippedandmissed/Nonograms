import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nonograms/image_processing.dart';
import 'package:nonograms/nonogram.dart';
import 'package:localstorage/localstorage.dart';

part 'game.freezed.dart';
part 'game.g.dart';

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required NonogramSet nonogramSet,
    required NonogramSet progress,
    required String imagePath,
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) => _$GameFromJson(json);
}

class StoredGames extends ChangeNotifier {
  final _localStorage = LocalStorage("games");

  Future<List<String>> getGameIds() async {
    await _localStorage.ready;
    final gameIds =
        (_localStorage.getItem("gameIds") as String?)?.split(",") ?? [];
    return gameIds;
  }

  Future<Game> getGame(String id) async {
    await _localStorage.ready;
    final jsonString = _localStorage.getItem("game:$id") as String;
    final game = Game.fromJson(json.decode(jsonString));
    return game;
  }

  Future<void> storeGame(Game game) async {
    await _localStorage.ready;
    final ids = await getGameIds();
    if (!ids.contains(game.id)) {
      final idsString = [...ids, game.id].join(",");
      await _localStorage.setItem("gameIds", idsString);
    }
    final jsonString = json.encode(game.toJson());
    await _localStorage.setItem("game:${game.id}", jsonString);
    notifyListeners();
  }

  Future<void> deleteGame(String id, String filename) async {
    await _localStorage.ready;
    final ids = await getGameIds();
    final newIds = ids.where((e) => e != id).toList();
    if (newIds.isEmpty) {
      await _localStorage.deleteItem("gameIds");
    } else {
      final idsString = newIds.join(",");
      await _localStorage.setItem("gameIds", idsString);
    }
    await _localStorage.deleteItem("game:$id");
    final filePath = await getFilePath(filename);
    await File(filePath).delete();
    notifyListeners();
  }
}

final storedGamesProvider = ChangeNotifierProvider<StoredGames>((ref) {
  return StoredGames();
});
