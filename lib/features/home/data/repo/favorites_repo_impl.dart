

// Data Layer - Implementation

import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/repo/favorites_repo.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final Box<bool> _favoritesBox;

  FavoritesRepositoryImpl(this._favoritesBox);

  @override
  Future<List<String>> getFavorites() async {
    return _favoritesBox.keys
        .cast<String>()
        .where((key) => _favoritesBox.get(key) == true)
        .toList();
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _favoritesBox.get(id, defaultValue: false) ?? false;
  }

  @override
  Future<void> addFavorite(String id) async {
    await _favoritesBox.put(id, true);
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _favoritesBox.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _favoritesBox.clear();
  }

}

