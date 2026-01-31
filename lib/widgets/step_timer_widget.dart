import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shefu/widgets/circular_countdown_timer.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class StepTimerWidget extends StatefulWidget {
  final int timerDurationSeconds; // Pass duration in seconds

  const StepTimerWidget({super.key, required this.timerDurationSeconds});

  @override
  State<StepTimerWidget> createState() => _StepTimerWidgetState();
}

class _StepTimerWidgetState extends State<StepTimerWidget> {
  final CountDownController _controller = CountDownController();
  bool _isStarted = false;
  bool _isPaused = false;
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    if (widget.timerDurationSeconds <= 0) {
      return const SizedBox.shrink(); // display nothing if no timer
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!; // Get localizations

    return Column(
      mainAxisSize: .min,
      children: [
        // Display timer duration as text
        Text(
          '${(widget.timerDurationSeconds / 60).round()} ${l10n.minutes_abbreviation}',
          style: TextStyle(fontSize: 12.0, color: colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onLongPress: () {
            _controller.reset();
            setState(() {
              _isStarted = false;
              _isPaused = false;
            });
          },
          onTap: () {
            setState(() {
              if (_isStarted) {
                if (_isPaused) {
                  _controller.resume();
                  _isPaused = false;
                } else {
                  _controller.pause();
                  _isPaused = true;
                }
              } else {
                // Restart the timer with the full duration
                _controller.restart(duration: widget.timerDurationSeconds);
                _isStarted = true;
                _isPaused = false;
              }
            });
          },
          child: CircularCountDownTimer(
            duration: widget.timerDurationSeconds,
            initialDuration: 0,
            controller: _controller,
            width: 64,
            height: 64,
            ringColor: colorScheme.surfaceContainerHighest,
            ringGradient: null,
            fillColor: colorScheme.primary,
            fillGradient: null,
            backgroundColor: Colors.transparent,
            strokeWidth: 5.0,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(
              fontSize: 14.0,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.MM_SS,
            isReverse: true,
            isReverseAnimation: true,
            isTimerTextShown: true,
            autoStart: false, // Don't autostart
            onStart: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.pauseUsage),
                  duration: const Duration(seconds: 5),
                  backgroundColor: colorScheme.secondary,
                  // TODO only display once?
                ),
              );
            },
            onComplete: () async {
              setState(() {
                _isStarted = false;
                _isPaused = false;
              });
              await player.play(AssetSource('notification-ping-335500.mp3'));
              HapticFeedback.vibrate();
            },
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              // Show 'Start' only when not started
              if (!_isStarted) {
                return l10n.start;
              }
              // Use default MM:SS format if not started yet
              return Function.apply(defaultFormatterFunction, [duration]);
            },
          ),
        ),
      ],
    );
  }
}
