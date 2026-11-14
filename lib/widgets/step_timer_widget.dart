import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:shefu/widgets/circular_countdown_timer.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

class const StepTimerWidget({
  super.key,

  /// Duration in seconds.
  required final int timerDurationSeconds,
}) extends StatefulWidget {
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

    return GestureDetector(
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
      child: Container(
        width: 72,
        height: 72,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: theme.colorScheme.onSurface.withAlpha(
              theme.brightness == Brightness.dark ? 40 : 140,
            ),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withAlpha(80),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularCountDownTimer(
              duration: widget.timerDurationSeconds,
              initialDuration: 0,
              controller: _controller,
              width: 64,
              height: 64,
              ringColor: colorScheme.surfaceContainerHigh,
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
                if (!_isStarted) {
                  // Display timer duration as text
                  return '${(widget.timerDurationSeconds / 60).round()} ${l10n.minutes_abbreviation}';
                }
                return Function.apply(defaultFormatterFunction, [duration]);
              },
            ),

            Positioned(
              bottom: 7,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 10, color: colorScheme.primary),
                  Text(
                    (_isStarted) ? l10n.pause : l10n.start,
                    style: TextStyle(
                      fontSize: 7,
                      height: 1,
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
