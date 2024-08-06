import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  //plalist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: "Undead",
      artistName: "Yoasobi",
      albumImagePath: "assets/images/Yoasobi_-_Undead.png",
      audioPath: "assets/audio/Y2meta.app - UNDEAD (128 kbps).mp3",
    ),

    // song 2
    Song(
      songName: "Idol",
      artistName: "Yoasobi",
      albumImagePath: "assets/images/Idol_(Yoasobi_song).png",
      audioPath: "assets/audio/Y2meta.app - UNDEAD (128 kbps).mp3",
    ),

    // song 3
    Song(
      songName: "Yoru Ni Kakeru",
      artistName: "Yoasobi",
      albumImagePath: "assets/images/Yoru_ni_Kakeru_cover_art.jpg",
      audioPath: "assets/audio/Y2meta.app - UNDEAD (128 kbps).mp3",
    ),
  ];

  // currnt song playng index
  int? _currentSongIndex;

  /*

  A U D I O P L A Y E R

  */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // pasue current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() {
    // if more than 2 seconds have passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      _audioPlayer.seek(Duration.zero);
    }
    // if it's within the first 2 seconds, go to previous song
    else {
      if (_currentSongIndex! > 0) {
        // go to previous song if it's not the first song
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _currentDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen(
      (event) => playNextSong(),
    );
  }

  // dispose audio player

  /*
  Getters
  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
  Setters
  */

  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // plat the song at the new index
    }

    // update UI
    notifyListeners();
  }
}
