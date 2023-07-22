import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
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
  final localStorage = LocalStorage("games");

  Future<List<String>> getGameIds() async {
    await localStorage.ready;
    final gameIds =
        (localStorage.getItem("gameIds") as String?)?.split(",") ?? [];
    return gameIds;
  }

  Future<Game> getGame(String id) async {
    await localStorage.ready;
    final jsonString = localStorage.getItem("game:$id") as String;
    final game = Game.fromJson(json.decode(jsonString));
    return game;
  }

  Future<void> storeGame(Game game) async {
    await localStorage.ready;
    final ids = await getGameIds();
    if (!ids.contains(game.id)) {
      final idsString = [...ids, game.id].join(",");
      await localStorage.setItem("gameIds", idsString);
    }
    final jsonString = json.encode(game.toJson());
    await localStorage.setItem("game:${game.id}", jsonString);
    notifyListeners();
  }
}

final storedGamesProvider = ChangeNotifierProvider<StoredGames>((ref) {
  return StoredGames();
});
