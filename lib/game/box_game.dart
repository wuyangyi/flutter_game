import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_game/components/agile_fly.dart';
import 'package:flutter_game/components/backyard.dart';
import 'package:flutter_game/components/credits_button.dart';
import 'package:flutter_game/components/drooler_fly.dart';
import 'package:flutter_game/components/fly.dart'; //手势库
import 'package:flutter_game/components/help_button.dart';
import 'package:flutter_game/components/highscore_display.dart';
import 'dart:math';

import 'package:flutter_game/components/house_fly.dart';
import 'package:flutter_game/components/hungry_fly.dart';
import 'package:flutter_game/components/macho_fly.dart';
import 'package:flutter_game/components/music_button.dart';
import 'package:flutter_game/components/score_display.dart';
import 'package:flutter_game/components/sound_button.dart';
import 'package:flutter_game/components/start_buttom.dart';
import 'package:flutter_game/controllers/spawner.dart';
import 'package:flutter_game/view.dart';
import 'package:flutter_game/views/home_view.dart';
import 'package:flutter_game/views/lost_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

//游戏主循环
class BoxGame extends Game {
  Size screenSize; //屏幕大小(只有当屏幕的大小发生变化时才会更新)
  View activeView = View.home; //当前界面

  HomeView homeView; //首页
  StartButton startButton; //游戏开始按钮
  LostView lostView; //游戏失败
  HelpButton helpButton; //帮助按钮
  CreditsButton creditsButton; //
  ScoreDisplay scoreDisplay; //积分
  HighscoreDisplay highscoreDisplay; // 最高分
  AudioPlayer homeBGM;//主页背景音乐
  AudioPlayer playingBGM; //游戏时的背景音乐
  MusicButton musicButton; //背景音乐控制
  SoundButton soundButton; //蚊子声音控制

  FlySpawner spawner; //苍蝇生成控制器

  bool hasWon = false; //是否胜利

  double tileSize; //苍蝇的大小
  List<Fly> flies; //苍蝇

  Random rnd;

  Backyard background; //背景

  int score; //当前得分

  final SharedPreferences storage;

  BoxGame(this.storage) {
    initialize();
  }

  void initialize() async {
    score = 0;
    flies = List<Fly>();
    resize(await Flame.util.initialDimensions());

    rnd = Random();

    background = Backyard(this); //背景
    homeView = HomeView(this);
    startButton = StartButton(this);
    lostView = LostView(this);

    spawner = FlySpawner(this);
    helpButton = HelpButton(this);
    creditsButton = CreditsButton(this);
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);
    musicButton = MusicButton(this);
    soundButton = SoundButton(this);

    homeBGM = await Flame.audio.loopLongAudio('bgm/home.mp3', volume: .25);
    homeBGM.pause();
    playingBGM = await Flame.audio.loopLongAudio('bgm/playing.mp3', volume: .25);
    playingBGM.pause();

    playHomeBGM();
  }

  //播放主页背景音乐
  void playHomeBGM() {
    playingBGM.pause();
    playingBGM.seek(Duration.zero);
    homeBGM.resume();
  }

  //播放游戏背景音乐
  void playPlayingBGM() {
    homeBGM.pause();
    homeBGM.seek(Duration.zero);
    playingBGM.resume();
  }

  @override
  void resize(Size size) {
    screenSize = size;
    tileSize = screenSize.width / 9;
  }

  @override
  void render(Canvas canvas) {
    // TODO: 实现渲染
    background.render(canvas); //绘制背景

    highscoreDisplay.render(canvas); //最高分

    //积分
    if (activeView == View.playing) {
      scoreDisplay.render(canvas);
    }

    //绘制苍蝇
    flies.forEach((Fly fly){
      fly.render(canvas);
    });

    if (activeView == View.home) {
      homeView.render(canvas);
    }

    if (activeView == View.home || activeView == View.lost) {
      startButton.render(canvas);
      helpButton.render(canvas);
      creditsButton.render(canvas);
    }

    musicButton.render(canvas);
    soundButton.render(canvas);

    if (activeView == View.lost) {
      lostView.render(canvas);
    }

    if (activeView == View.help) {
      helpButton.render(canvas);
    }

    if (activeView == View.credits) {
      creditsButton.render(canvas);
    }


  }

  @override
  void update(double t) {
    // TODO: 实现更新
    spawner.update(t);
    flies.forEach((Fly fly){
      fly.upDate(t);
    });
    flies.removeWhere((Fly fly) => fly.isOffScreen);
    if (activeView == View.playing) {
      scoreDisplay.update(t);
    }

  }

  //处理点击
  void onTapDown(TapDownDetails d) {
    bool isHandled = false;

    // dialog boxes
    if (!isHandled) {
      if (activeView == View.help || activeView == View.credits) {
        activeView = View.home;
        isHandled = true;
      }
    }

    // help button
    if (!isHandled && helpButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        helpButton.onTapDown();
        isHandled = true;
      }
    }

    // credits button
    if (!isHandled && creditsButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        creditsButton.onTapDown();
        isHandled = true;
      }
    }

    //点击开始
    if (!isHandled && startButton.rect.contains(d.globalPosition)) {
      if (activeView == View.home || activeView == View.lost) {
        startButton.onTapDown();
        isHandled = true;
      }
    }

    //点击苍蝇
    if (!isHandled) {
      bool didHitAFly = false;
      flies.forEach((Fly fly) {
        if (fly.flyRect.contains(d.globalPosition)) { //点击到苍蝇
          fly.onTapDown();
          isHandled = true;
          didHitAFly = true;
        }
      });
      if (activeView == View.playing && !didHitAFly) {
        if (soundButton.isEnabled) {
          Flame.audio.play('sfx/haha' + (rnd.nextInt(5) + 1).toString() + '.ogg');
        }
        playHomeBGM();
        activeView = View.lost;
      }
    }

    // music button
    if (!isHandled && musicButton.rect.contains(d.globalPosition)) {
      musicButton.onTapDown();
      isHandled = true;
    }

    // sound button
    if (!isHandled && soundButton.rect.contains(d.globalPosition)) {
      soundButton.onTapDown();
      isHandled = true;
    }


  }

  void spawnFly() {
    double x = rnd.nextDouble() * (screenSize.width - (tileSize * 1.35));
    double y = (rnd.nextDouble() * (screenSize.height - (tileSize * 2.85))) + (tileSize * 1.5);
    switch (rnd.nextInt(5)) {
      case 0:
        flies.add(HouseFly(this, x, y));
        break;
      case 1:
        flies.add(DroolerFly(this, x, y));
        break;
      case 2:
        flies.add(AgileFly(this, x, y));
        break;
      case 3:
        flies.add(MachoFly(this, x, y));
        break;
      case 4:
        flies.add(HungryFly(this, x, y));
        break;
    }
  }

}