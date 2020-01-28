library swipe_up_menu;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwipeUpMenu extends StatefulWidget {
  final List<Widget> body;
  final ValueChanged<int> onChange;
  final List<SwipeUpMenuItem> items;
  final int startIndex;
  final Duration animationDuration;
  final ValueChanged<bool> canScroll;

  SwipeUpMenu({
    Key key,
    @required this.body,
    @required this.items,
    this.onChange,
    this.canScroll,
    this.startIndex = 0,
    this.animationDuration,
  })  : assert(body != null && body.length == items.length),
        assert(items != null),
        super(key: key);

  static SwipeUpMenuState of(BuildContext context, {bool nullOk = false}) {
    assert(context != null);
    assert(nullOk != null);
    final SwipeUpMenuState query =
        context.findAncestorStateOfType<SwipeUpMenuState>();
    if (query != null) return query;
    if (nullOk) return null;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'SwipeUpMenuState.of() called with a context that does not contain a SwipeUpMenuState.'),
      ErrorDescription(
          'No SwipeUpMenuState ancestor could be found starting from the context that was passed '
          'to SwipeUpMenuState.of(). This can happen because you do not have a WidgetsApp or '
          'MaterialApp widget (those widgets introduce a SwipeUpMenuState), or it can happen '
          'if the context you use comes from a widget above those widgets.'),
      context.describeElement('The context used was')
    ]);
  }

  @override
  SwipeUpMenuState createState() => SwipeUpMenuState();
}

class SwipeUpMenuState extends State<SwipeUpMenu>
    with SingleTickerProviderStateMixin {
  bool start;
  bool locked;
  int currentIndex;
  int selectingIndex;
  double verticalLocation = 0;
  double horizontalLocation = 0;
  Offset startLocation;
  Size size;

  AnimationController animationController;
  Animation<double> menuAppear;

  List<GlobalKey> keys;
  List<Widget> widgets;
  Size widgetSize;

  List<SwipeUpMenuItem> get items => widget.items;
  List<Widget> get body => widget.body;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: widget.animationDuration ?? Duration(milliseconds: 500));
    animationController.addListener(() {
      setState(() {});
    });
    currentIndex = widget.startIndex;
    selectingIndex = currentIndex;
    menuAppear =
        Tween<double>(begin: 0.5, end: 0.03).animate(animationController);
    keys = items.map((item) => GlobalKey()).toList();
    super.initState();
  }

  bool _notificationListener(Notification notification) {
    if (notification is UserScrollNotification) return true;
    if (notification is ScrollStartNotification)
      return _onVerticalDragStart(notification.dragDetails ?? null);
    if (notification is ScrollUpdateNotification)
      return _onVerticalDragUpdate(notification.dragDetails ?? null);
    if (notification is OverscrollNotification)
      return _onVerticalDragUpdate(notification.dragDetails ?? null);
    if (notification is ScrollEndNotification)
      return _onVerticalDragEnd(notification.dragDetails ?? null);
    return true;
  }

  bool _onVerticalDragStart(DragStartDetails details) {
    if (details == null) return true;
    if (details.globalPosition.dx > size.width * 0.85) {
      startLocation = details.globalPosition;
      setState(() {});
    }
    return true;
  }

  bool _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details == null) return true;
    if (start != null && start) {
      verticalLocation = details.globalPosition.dy;
      horizontalLocation = details.globalPosition?.dx;
      if (horizontalLocation < (size.width * 0.8).abs())
        locked = true;
      else
        locked = false;
      setState(() {});
    } else if (startLocation != null &&
        (details.globalPosition.dy - startLocation.dy).abs() >
            (size.height * 0.15).abs()) {
      start = true;
      animationController.forward();
      verticalLocation = details.globalPosition.dy;
      setState(() {});
    }
    return true;
  }

  bool _onVerticalDragEnd(DragEndDetails details) {
    if (start != null && start) {
      start = false;
      startLocation = null;
      animationController.reverse();
      horizontalLocation = 0;
      verticalLocation = 0;
      if (locked) {
        if (widget.onChange != null) widget.onChange(selectingIndex);
        currentIndex = selectingIndex;
      }
      setState(() {});
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    widgets =
        keys.map((key) => _getItemMenuTile(items[keys.indexOf(key)])).toList();
    return GestureDetector(
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          NotificationListener(
            onNotification: _notificationListener,
            child: body[currentIndex],
          ),
          Positioned(
            left: size.width * menuAppear.value,
            child: IgnorePointer(
              child: Container(
                width: size.width,
                height: size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widgets,
                ),
              ),
            ),
          )
        ],
      ),
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onHorizontalDragStart: (details) {
        print(details.globalPosition);
      },
    );
  }

  Offset _getObjectPositionByIndex(int index) {
    final RenderBox box = keys[index].currentContext?.findRenderObject();
    return box != null ? box.localToGlobal(Offset.zero) : null;
  }

  double _getHorizontalPosition(int index) {
    if (start != null && start) {
      Offset positon = _getObjectPositionByIndex(index);
      if (size == null || positon == null) return 0;
      double iStart = positon.dy;
      double iEnd = iStart + (size.height * 0.05);
      if (verticalLocation >= iStart && verticalLocation <= iEnd && !locked) {
        selectingIndex = index;
        double margin = (size.width - horizontalLocation) + size.width * 0.1;
        margin = margin < (size.width / 4) ? margin : (size.width / 4);
        return margin;
      } else if (selectingIndex == index) {
        double margin = (size.width - horizontalLocation) + size.width * 0.1;
        margin = margin < (size.width / 4) ? margin : (size.width / 4);
        return margin;
      } else {
        double margin =
            8.0 * (items.length - ((index - selectingIndex).abs() * 1));
        return margin < 0 ? 0 : margin;
      }
    }
    return 0;
  }

  Widget _getItemMenuTile(SwipeUpMenuItem item) {
    var index = items.indexOf(item);
    return Material(
      key: keys[index],
      color: Colors.transparent,
      child: Container(
        width: (size.width * 0.35),
        height: (size.height * 0.05),
        margin: EdgeInsets.only(
            top: 6, bottom: 6, right: _getHorizontalPosition(index)),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: item.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black38,
                  offset: Offset(0.0, 1),
                  blurRadius: 1.5,
                  spreadRadius: 1)
            ]),
        alignment: Alignment.center,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Row(
              children: <Widget>[
                item.icon != null ? item.icon : Container(),
                Expanded(
                  child: Center(child: item.title),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeUpMenuItem {
  final Text title;
  final Color backgroundColor;
  final Icon icon;

  SwipeUpMenuItem({
    @required this.title,
    this.icon,
    this.backgroundColor = Colors.white,
  }) : assert(title != null);
}
