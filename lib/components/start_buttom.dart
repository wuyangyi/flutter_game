import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:flutter_game/game/box_game.dart';
import 'package:flutter_game/view.dart';

//游戏开始按钮
class StartButton {
  final BoxGame game;
  Rect rect;
  Sprite sprite;

  StartButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * 1.5,
      (game.screenSize.height * .75) - (game.tileSize * 1.5),
      game.tileSize * 6,
      game.tileSize * 3,
    );
    sprite = Sprite('ui/start-button.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  //点击
  void onTapDown() {
    game.score = 0;
    game.activeView = View.playing;
    game.spawner.start();
    game.playPlayingBGM();
  }
}