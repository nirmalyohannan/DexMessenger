import 'dart:developer';
import 'dart:typed_data';
import 'package:dex_messenger/Screens/ScreenSplash/screen_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/data/models/live_emoji_model.dart';

import 'package:flutter/material.dart';

class LiveEmojisProvider extends ChangeNotifier {
  bool isInitialised = false;
  int totalEmojis =
      1; //should not be 0 otherwise (loadedEmojis/totalEmojis == infinity)
  int loadedEmojis = 0;
  List<LiveEmojiModel> liveEmojisList = [];
  var x = [];
  Map<String, Uint8List> liveEmojisMemoryMap = {};
  Map<String, Uint8List> liveEmojisForegroundMemoryMap = {};
  Map<String, Uint8List> liveEmojisBackgroundMemoryMap = {};

  late Box<Map<String, dynamic>> _liveEmojiModelBox;
  late Box<Uint8List> _liveEmojiBox;
  late Box<Uint8List> _liveEmojiForegroundBox;
  late Box<Uint8List> _liveEmojiBackgroundBox;

  initiate() async {
    log('Initiating: liveEmojiProvider');
    _liveEmojiModelBox =
        await Hive.openBox<Map<String, dynamic>>('liveEmojiModelBox');
    _liveEmojiBox = await Hive.openBox<Uint8List>('liveEmojiBox');
    _liveEmojiForegroundBox = await Hive.openBox('liveEmojiForegroundBox');
    _liveEmojiBackgroundBox = await Hive.openBox('liveEmojiBackGroundBox');

    //-------------------------------------------------------------------
    for (var key in _liveEmojiModelBox.keys) {
      LiveEmojiModel liveEmojiModel =
          LiveEmojiModel.fromJson(_liveEmojiModelBox.get(key)!, key);
      liveEmojisList.add(liveEmojiModel);
    }

    for (String key in _liveEmojiBox.keys) {
      liveEmojisMemoryMap[key] = _liveEmojiBox.get(key)!;
    }
    for (String key in _liveEmojiForegroundBox.keys) {
      liveEmojisForegroundMemoryMap[key] = _liveEmojiForegroundBox.get(key)!;
    }
    for (String key in _liveEmojiBackgroundBox.keys) {
      liveEmojisBackgroundMemoryMap[key] = _liveEmojiBackgroundBox.get(key)!;
    }
    log('LiveEmojiProvider: Loaded Emojis to Memory');
    log('LiveEmojiProvider: Started Listening for new Emojis');

    log('LiveEmojiProvider: emojis count: ${liveEmojisMemoryMap.keys.length}');
    log('LiveEmojiProvider: emojiBackGround count: ${liveEmojisBackgroundMemoryMap.keys.length}');
    log('LiveEmojiProvider: emojiForeground count: ${liveEmojisForegroundMemoryMap.keys.length}');
    //-------------------------------------------------------------------
    FirebaseFirestore.instance
        .collection('liveEmojis')
        .snapshots()
        .listen((event) async {
      log('LiveEmojiProvider: new Change Listened');
      var emojiDocs = event.docs;
      //-------------------------------
      totalEmojis = emojiDocs.length;
      notifyListeners();
      //---------------------------
      for (var emoji in emojiDocs) {
        LiveEmojiModel liveEmojiModel =
            LiveEmojiModel.fromJson(emoji.data(), emoji.id);
        // liveEmojis.add(liveEmojiModel);
        if (!_liveEmojisContain(liveEmojiModel)) {
          liveEmojisList.add(liveEmojiModel);
        }
        // log('liveEmojisList has:${liveEmojiModel.name}');
//-----------------Loading Emoji into Memory & Hive---------------------------------------
        if (liveEmojisMemoryMap[liveEmojiModel.name] == null) {
          http.Response response =
              await http.get(Uri.parse(liveEmojiModel.emoji));
          liveEmojisMemoryMap[liveEmojiModel.name] = response.bodyBytes;
          await _liveEmojiBox.put(liveEmojiModel.name, response.bodyBytes);
          log('LiveEmojiProvider: emojis count: ${liveEmojisMemoryMap.keys.length}');
          notifyListeners();
        }

//-------------------Loading Foreground and background into Memory & Hive----------------
        if (liveEmojiModel.foreground != null) {
          if (liveEmojisForegroundMemoryMap[liveEmojiModel.foreground!] ==
              null) {
            http.Response response =
                await http.get(Uri.parse(liveEmojiModel.foreground!));
            liveEmojisForegroundMemoryMap[liveEmojiModel.foreground!] =
                response.bodyBytes;

            await _liveEmojiForegroundBox.put(
                liveEmojiModel.foreground, response.bodyBytes);
            log('LiveEmojiProvider: emojiForeground count: ${liveEmojisForegroundMemoryMap.keys.length}');
          }
        }
        //---------
        if (liveEmojiModel.background != null) {
          if (liveEmojisBackgroundMemoryMap[liveEmojiModel.background!] ==
              null) {
            http.Response response =
                await http.get(Uri.parse(liveEmojiModel.background!));
            liveEmojisBackgroundMemoryMap[liveEmojiModel.background!] =
                response.bodyBytes;
            await _liveEmojiBackgroundBox.put(
                liveEmojiModel.background, response.bodyBytes);
            log('LiveEmojiProvider: emojiBackGround count: ${liveEmojisBackgroundMemoryMap.keys.length}');
          }
        }
        //-----------------------------------------------------
        loadedEmojis = liveEmojisMemoryMap.length;
        notifyListeners();
      }

      isInitialised = true;
      notifyListeners();
    });
  }

  bool _liveEmojisContain(LiveEmojiModel liveEmojiModel) {
    bool contains = false;
    for (var element in liveEmojisList) {
      if (element.name == liveEmojiModel.name) {
        contains = true;
        return contains;
      }
    }

    return contains;
  }

  LiveEmojiModel findLiveEmoji(String name) {
    return liveEmojisList.where((element) => element.name == name).first;
  }
}
