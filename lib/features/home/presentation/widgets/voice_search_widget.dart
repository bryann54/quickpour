import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';

class VoiceSearchWidget extends StatefulWidget {
  final Function(String) onVoiceResult;
  final AuthRepository? authRepository;

  const VoiceSearchWidget({
    super.key,
    required this.onVoiceResult,
    this.authRepository,
  });

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _isInitialized = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (mounted) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      }
    });
  }

  Future<void> _initializeSpeech() async {
    try {
      _isInitialized = await _speech.initialize(
        onStatus: _handleSpeechStatus,
        onError: _handleSpeechError,
      );

      if (!_isInitialized && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing speech: $e')),
        );
      }
    }
  }

  void _handleSpeechStatus(String status) {
    if (status == 'notListening' && mounted) {
      setState(() => _isListening = false);
      _animationController.stop();
    }
  }

  void _handleSpeechError(dynamic error) {
    if (mounted) {
      setState(() => _isListening = false);
      _animationController.stop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.errorMsg}')),
      );
    }
  }

  Future<void> _listen() async {
    if (!_isInitialized) {
      await _initializeSpeech();
    }

    if (!_isListening && _isInitialized) {
      setState(() => _isListening = true);
      _animationController.forward();

      await _speech.listen(
        onResult: (result) {
          if (result.finalResult && mounted) {
            final searchQuery = result.recognizedWords;
            setState(() => _isListening = false);
            _animationController.stop();
            widget.onVoiceResult(searchQuery);
          }
        },
      );
    } else if (_isListening) {
      setState(() => _isListening = false);
      _animationController.stop();
      await _speech.stop();
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: FloatingActionButton(
            elevation: 15,
            onPressed: _listen,
            backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: FaIcon(
                _isListening
                    ? FontAwesomeIcons.stop
                    : FontAwesomeIcons.microphoneAlt,
                key: ValueKey<bool>(_isListening),
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
          ).animate().fadeIn(duration: 1000.ms).slideX(begin: 0.3),
        );
      },
    );
  }
}
