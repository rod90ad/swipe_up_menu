import 'package:flutter/material.dart';

class SwipeUpMenu extends StatefulWidget {
  
  final List<Widget> body;
  final ValueChanged<int> onChange;
  final List<SwipeUpMenuItem> items;
  final int startIndex;

  SwipeUpMenu({
    Key key,
    @required this.body,
    @required this.onChange,
    @required this.items,
    @required this.startIndex,
  }):
    assert(body!=null),
    assert(onChange!=null),
    assert(items!=null),
    super(key:key);
  
  @override
  _SwipeUpMenuState createState() => _SwipeUpMenuState();
}

class _SwipeUpMenuState extends State<SwipeUpMenu> with SingleTickerProviderStateMixin {
  
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
  void initState(){
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController.addListener((){
      setState(() {});
    });
    currentIndex = widget.startIndex;
    selectingIndex = currentIndex; 
    menuAppear = Tween<double>(begin: 0.5, end: 0.03).animate(animationController);
    keys = items.map((item) => GlobalKey()).toList();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    widgets = keys.map((key) => _getItemMenuTile(items[keys.indexOf(key)])).toList();
    return SafeArea(
      child: GestureDetector(
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            body[currentIndex],
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
        onVerticalDragStart: (details){
          if(details.globalPosition.dx > size.width * 0.85){
            startLocation = details.globalPosition;
          }
        },
        onVerticalDragUpdate: (details){
          if(start!=null && start){
            verticalLocation = details.globalPosition.dy;
            horizontalLocation = details.globalPosition.dx;
            if(horizontalLocation < size.width*0.8)
              locked = true;
            else
              locked = false;
            setState(() {});
          }else if(startLocation!=null && (details.globalPosition.dy-startLocation.dy).abs() > size.height * 0.15){
            start=true;
            animationController.forward();
            verticalLocation = details.globalPosition.dy;
            setState(() {});
          }
        },
        onVerticalDragEnd: (details){
          if(start!=null && start){
            start=false;
            startLocation = null;
            animationController.reverse();
            horizontalLocation=0;
            verticalLocation=0;
            if(locked){
              widget.onChange(selectingIndex);
              currentIndex = selectingIndex;
            }
            setState(() {});
          }
        },
      ),
    );
  }

  Offset _getObjectPositionByIndex(int index){
    final RenderBox box = keys[index].currentContext?.findRenderObject();
    return box!= null ? box.localToGlobal(Offset.zero) : null;
  }

  double _getHorizontalPosition(int index){
    if(start!=null && start){
      Offset positon = _getObjectPositionByIndex(index);
      if(size==null || positon==null)
        return 0;
      double iStart = positon.dy;
      double iEnd = iStart + (size.height * 0.05);
      if(verticalLocation>=iStart && verticalLocation<=iEnd  && !locked){
        selectingIndex = index;
        double margin = (size.width - horizontalLocation) + size.width * 0.1;
        margin = margin < (size.width/4) ? margin : (size.width/4);
        return margin;
      }else if(selectingIndex==index){
        double margin = (size.width - horizontalLocation) + size.width * 0.1;
        margin = margin < (size.width/4) ? margin : (size.width/4);
        return margin;
      }else{
        double margin = 8.0 * (items.length - ((index - selectingIndex).abs() * 1));
        return margin < 0 ? 0 : margin;
      }
    }
    return 0;
  }

  Widget _getItemMenuTile(SwipeUpMenuItem item){
    var index = items.indexOf(item);
    return Material(
      key: keys[index],
      color: Colors.transparent,
      child: Container(
        width: (size.width * 0.35),
        height: (size.height * 0.05),
        margin: EdgeInsets.only(top: 6, bottom: 6, right: _getHorizontalPosition(index)),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: item.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black38, offset: Offset(0.0, 1), blurRadius: 1.5, spreadRadius: 1)]
        ),
        alignment: Alignment.center,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Row(
              children: <Widget>[
                item.icon!=null ? item.icon : Container(),
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

class SwipeUpMenuItem{

  final Text title;
  final Color backgroundColor;
  final Icon icon;

  SwipeUpMenuItem({
    @required this.title,
    this.icon,
    this.backgroundColor = Colors.white,
  }) : assert(title!=null);
}