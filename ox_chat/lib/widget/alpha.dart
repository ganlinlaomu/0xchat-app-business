import 'package:flutter/material.dart';

typedef void AlphaChanged(String alpha);
typedef void OnTouchStart();
typedef void OnTouchMove();
typedef void OnTouchEnd();
//Default Index data.
const List<String> ALPHAS_INDEX = const ["☆","A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"];

class Alpha extends StatefulWidget {
//  static List<String> _alphas = ALPHAS_INDEX;

  /// Font size of a single letter
  double? alphaItemSize;
  List<String>? alphas;

  /// When the selected letter changes
  AlphaChanged? onAlphaChange;

  OnTouchStart? onTouchStart;
  OnTouchMove? onTouchMove;
  OnTouchEnd? onTouchEnd;

  /// Background color in the active state
  Color? activeBgColor;

  /// Background color in the inactive state
  Color? bgColor;

  /// Font color in the inactive state
  Color? fontColor;

  /// Font color in the active state
  Color? fontActiveColor;

  Alpha(
      {Key? key,

      /// Height size and font size of the letter list
      this.alphaItemSize = 19.0,

      /// Selectable set of letters
      this.alphas = ALPHAS_INDEX,

      /// Callback generated by touching the right letter set
      this.onAlphaChange,
      this.onTouchStart,
      this.onTouchMove,
      this.onTouchEnd,
      this.activeBgColor = Colors.transparent,
      this.bgColor = Colors.transparent,
      this.fontColor = Colors.black,
      this.fontActiveColor = Colors.black26})
      : super(key: key);

  @override
  AlphaState createState() {
    return new AlphaState();
  }
}

class AlphaState extends State<Alpha> {
//  Timer _changeTimer;

  bool isTouched = false;

  List<double> indexRange = [];

  /// Height of the first letter or category from the global coordinate system
  double? _distance2Top;

  // The last letter just before the touch ends
  String? _lastTag;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    if (widget.alphas == null) {
      widget.alphas = ALPHAS_INDEX;
    }
    List alphas = widget.alphas!;
    for (int i = 0; i <= alphas.length; i++) {
      indexRange.add((i) * widget.alphaItemSize!);
    }
  }

  String? _getHitAlpha(offset) {
    int hit = (offset / widget.alphaItemSize).toInt();
    if (hit < 0) {
      return null;
    }
    if (hit >= widget.alphas!.length) {
      return null;
    }
    return widget.alphas![hit];
  }

  _onAlphaChange([String? tag]) {
    if (widget.onAlphaChange != null && tag != null && tag != _lastTag) {
      _lastTag = tag;
      widget.onAlphaChange!(tag);
    }
  }

  _touchStartEvent(String? tag) {
    this.setState(() {
      isTouched = true;
    });
    if (tag != null) {
      _onAlphaChange(tag);
    }

    if (widget.onTouchStart != null && tag != null) {
      widget.onTouchStart!();
    }
  }

  _touchMoveEvent(String? tag) {
    if (tag != null) {
      _onAlphaChange(tag);
    }
    if (widget.onTouchMove != null) {
      widget.onTouchMove!();
    }
  }

  _touchEndEvent() {
    this.setState(() {
      isTouched = false;
    });
    // This could have been avoided here. However, to ensure data readiness, it is triggered once more at the end
    if (_lastTag != null) {
      _onAlphaChange(_lastTag);
    }
    if (widget.onTouchEnd != null) {
      widget.onTouchEnd!();
    }
  }

  _buildAlpha() {
    List<Widget> result = [];
    for (var alpha in widget.alphas!) {
      result.add(new SizedBox(
        key: Key(alpha),
        height: widget.alphaItemSize,
        child: new Text(alpha, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color:widget.fontColor)),
      ));
    }
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          alignment: Alignment.center,
          color: isTouched ? widget.activeBgColor : widget.bgColor,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(mainAxisSize: MainAxisSize.min, children: result),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragDown: (DragDownDetails details) {
          _distance2Top = _getDistanceToTop();

          int touchOffset2Begin = details.globalPosition.dy.toInt() - _distance2Top!.toInt();
          String? tag = _getHitAlpha(touchOffset2Begin);
          _touchStartEvent(tag);
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          int touchOffset2Begin = details.globalPosition.dy.toInt() - _distance2Top!.toInt();
          String? tag = _getHitAlpha(touchOffset2Begin);
          if (tag != null) {
            _touchMoveEvent(tag);
          }
        },
        onVerticalDragEnd: (DragEndDetails details) {
          _touchEndEvent();
        },
        child: _buildAlpha());
  }

  double? _getDistanceToTop() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null) {
      return renderBox
          .localToGlobal(Offset.zero)
          .dy
          .toInt() + (renderBox.size.height - widget.alphaItemSize! * widget.alphas!.length) / 2;
    }
    return null;
  }

}
