import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/// Un widget moderne et interactif pour la lecture d'un extrait audio de 30 secondes.
/// Utilise le package just_audio pour charger et lire un fichier audio à partir d'une URL.
class AudioPlayerWidget extends StatefulWidget {
  /// URL de l'extrait audio (30 secondes) à lire.
  final String previewUrl;

  const AudioPlayerWidget({Key? key, required this.previewUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  String? _error;

  // Stocke les subscriptions pour pouvoir les annuler
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  /// Initialise le lecteur audio en chargeant l'URL et en écoutant les mises à jour.
  Future<void> _initAudio() async {
    try {
      // Charge l'URL de l'extrait audio.
      await _audioPlayer.setUrl(widget.previewUrl);

      // Récupère la durée une fois que le média est chargé.
      setState(() {
        _duration = _audioPlayer.duration ?? Duration.zero;
      });

      // Écoute la position actuelle du lecteur.
      _positionSubscription = _audioPlayer.positionStream.listen((pos) {
        setState(() {
          _position = pos;
        });
      });

      // Surveille l'état du lecteur pour réinitialiser lorsque la lecture est terminée.
      _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _audioPlayer.seek(Duration.zero);
          });
        }
      });
    } catch (e) {
      setState(() {
        _error = "Erreur lors de l'initialisation audio: $e";
      });
      print(_error);
    }
  }

  /// Bascule entre lecture et pause.
  Future<void> _playPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      setState(() {
        _error = "Erreur lors de la lecture : $e";
      });
      print(_error);
    }
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _playerStateSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Formate une durée en minutes:secondes (ex. "02:30").
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Affichage du bouton play/pause avec une animation fluide
        GestureDetector(
          onTap: _playPause,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: _isPlaying
                ? Icon(
              Icons.pause_circle_filled,
              size: 64,
              color: Theme.of(context).primaryColor,
              key: const ValueKey('pause'),
            )
                : Icon(
              Icons.play_circle_fill,
              size: 64,
              color: Theme.of(context).primaryColor,
              key: const ValueKey('play'),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Barre de progression interactive (désactivée si la durée est nulle)
        Slider(
          min: 0,
          max: _duration.inMilliseconds.toDouble() > 0
              ? _duration.inMilliseconds.toDouble()
              : 1.0,
          value: _position.inMilliseconds.clamp(0, _duration.inMilliseconds).toDouble(),
          onChanged: _duration.inMilliseconds > 0
              ? (value) {
            _audioPlayer.seek(Duration(milliseconds: value.toInt()));
          }
              : null,
        ),
        // Affichage de la position et de la durée totale
        Text(
          "${_formatDuration(_position)} / ${_formatDuration(_duration)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}
