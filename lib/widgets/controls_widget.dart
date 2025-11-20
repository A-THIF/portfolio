import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class ControlsWidget extends StatefulWidget {
  final VoidCallback onLeftStart;
  final VoidCallback onRightStart;
  final VoidCallback onLeftEnd;
  final VoidCallback onRightEnd;
  final VoidCallback onStopAll;

  const ControlsWidget({
    required this.onLeftStart,
    required this.onRightStart,
    required this.onLeftEnd,
    required this.onRightEnd,
    required this.onStopAll,
    super.key,
  });

  @override
  State<ControlsWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _focusNode.dispose();
    super.dispose();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.onStopAll();
        widget.onLeftStart();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.onStopAll();
        widget.onRightStart();
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        widget.onLeftEnd();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        widget.onRightEnd();
      }
    }
    return false;
  }

  void _handlePointerScroll(PointerScrollEvent event) {
    widget.onStopAll();
    if (event.scrollDelta.dy < 0) {
      widget.onRightStart();
    } else if (event.scrollDelta.dy > 0) {
      widget.onLeftStart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) _handlePointerScroll(event);
      },
      behavior: HitTestBehavior.translucent,
      child: GestureDetector(
        onTap: () {
          widget.onStopAll();
        },
        onHorizontalDragUpdate: (details) {
          widget.onStopAll();
          if (details.delta.dx > 0) {
            widget.onRightStart();
          } else if (details.delta.dx < 0) {
            widget.onLeftStart();
          }
        },
        onHorizontalDragEnd: (_) {
          widget.onStopAll();
        },
        behavior: HitTestBehavior.opaque,
        child: const SizedBox.expand(),
      ),
    );
  }
}
