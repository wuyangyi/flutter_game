import 'dart:ui';
import 'package:flutter_game/components/callout.dart';
import 'package:flutter_game/game/box_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter_game/view.dart';
import 'package:flame/flame.dart';

/*
 * 蚊子超类
 */
class Fly {
  //位置
  double x;
  double y;

  //大小
  double width;
  double height;

  final BoxGame game; //主循环手脚架
  Rect flyRect; //苍蝇

  bool isDead = false;//苍蝇是否死亡

  bool isOffScreen = false; //点击到苍蝇

  List<Sprite> flyingSprite; //未死亡的绘制
  Sprite deadSprite; //死亡的绘制
  double flyingSpriteIndex = 0; //当前未死亡的绘制

  double get speed => game.tileSize * 3; //飞行速度
  Offset targetLocation; //苍蝇的目的地

  Callout callout; //苍蝇倒计时

  Fly(this.game) {
    setTargetLocation();
    callout = Callout(this);
  }

  void setTargetLocation() {
    double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize * 1.35));
    double y = (game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize * 2.85))) + (game.tileSize * 1.5);
    targetLocation = Offset(x, y);
  }

  void render(Canvas canvas) {
//    canvas.drawRect(flyRect.inflate(flyRect.width / 2), Paint()..color = Color(0x77ffffff));

    if (isDead) {
      deadSprite.renderRect(canvas, flyRect.inflate(flyRect.width / 2));
    } else {
      flyingSprite[flyingSpriteIndex.toInt() >= 2 ? flyingSpriteIndex.toInt() % 2 : flyingSpriteIndex.toInt()].renderRect(canvas, flyRect.inflate(flyRect.width / 2));
      if (game.activeView == View.playing) {
        callout.render(canvas);
      }
    }

//    canvas.drawRect(flyRect, Paint()..color = Color(0x88000000));
  }

  //若游戏以每秒60帧的速度运行， 则1秒将执行60次upDate方法，t的时间增量为1/60 = 0.0166s
  void upDate(double t) {
    if (isDead) {
      flyRect = flyRect.translate(0, game.tileSize * 12 * t);
      if (flyRect.top > game.screenSize.height) {
        isOffScreen = true;
      }
    } else {
      flyingSpriteIndex += 30 * t;
      while (flyingSpriteIndex >= 2) {
        flyingSpriteIndex -= 2;
      }

      //飞行
      double stepDistance = speed * t;
      Offset toTarget = targetLocation - Offset(flyRect.left, flyRect.top);
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        flyRect = flyRect.shift(stepToTarget);
      } else {
        flyRect = flyRect.shift(toTarget);
        setTargetLocation();
      }
      callout.update(t);
    }
  }

  //拍到苍蝇
  void onTapDown() {
    if (!isDead) {
      isDead = true;
      if (game.soundButton.isEnabled) {
        Flame.audio.play('sfx/ouch' + (game.rnd.nextInt(11) + 1).toString() + '.ogg');
      }
      if (game.activeView == View.playing) {
        game.score += 1;
        if (game.score > (game.storage.getInt('highscore') ?? 0)) {
          game.storage.setInt('highscore', game.score);
          game.highscoreDisplay.updateHighscore();
        }
      }
    }
  }
}