

import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:flutter_game/components/fly.dart';
import 'package:flutter_game/game/box_game.dart';

//正常苍蝇
class HouseFly extends Fly {
  HouseFly(BoxGame game, double x, double y) : super(game) {
    flyRect = Rect.fromLTWH(x, y, game.tileSize * 1, game.tileSize * 1);
    flyingSprite = List<Sprite>();
    flyingSprite.add(Sprite('flies/house-fly-1.png'));
    flyingSprite.add(Sprite('flies/house-fly-2.png'));
    deadSprite = Sprite('flies/house-fly-dead.png');
  }

}