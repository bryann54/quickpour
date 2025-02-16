import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:chupachap/features/product_search/presentation/pages/search_page.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';

class VoiceSearchWidget extends StatefulWidget {
  final Function(String)? onVoiceResult;
  final AuthRepository? authRepository;

  const VoiceSearchWidget({
    super.key,
    this.onVoiceResult,
    this.authRepository,
  });

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with SingleTickerProviderStateMixin {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  // Animation controller for pulse effect
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    // Define the pulse animation
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    // Start the animation when listening starts
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening') {
          setState(() => _isListening = false);
          _animationController.stop(); // Stop animation when not listening
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        _animationController.stop(); // Stop animation on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error.errorMsg}')),
        );
      },
    );

    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
    }
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _animationController.forward(); // Start pulse animation
        _speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              final searchQuery = result.recognizedWords;

              // Call the callback if provided
              if (widget.onVoiceResult != null) {
                widget.onVoiceResult!(searchQuery);
              }

              // Navigate to search page with the voice input
              _navigateToSearch(searchQuery);

              setState(() => _isListening = false);
              _animationController.stop(); // Stop animation when done
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _animationController.stop(); // Stop animation when stopped manually
      _speech.stop();
    }
  }

  void _navigateToSearch(String query) {
    final controller = TextEditingController(text: query);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(
          searchController: controller,
          authRepository: widget.authRepository ?? AuthRepository(),
        ),
      ),
    );
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
