import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';

//游戏背景
class Backyard {
  final BoxGame game;
  Sprite bgSprite;

  Rect bgRect;

  Backyard(this.game) {
    bgSprite = Sprite("backyard.png");
    bgRect = Rect.fromLTWH(
      0,
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23,
    );
  }

  void render(Canvas canvas) {
    bgSprite.renderRect(canvas, bgRect);
  }

  void update(double t) {}

}