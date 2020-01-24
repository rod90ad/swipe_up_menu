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
  double topStart;
  double distanceBetween;
  Size size;
  AnimationController animationController;
  Animation<double> menuAppear;

  List<SwipeUpMenuItem> get items => widget.items;
  List<Widget> get body => widget.body;

  @override
  void initState(){
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController.addListener((){
      setState(() {});
    });
    currentIndex = widget.startIndex;
    selectingIndex = currentIndex; 
    menuAppear = Tween<double>(begin: 0.5, end: 0.03).animate(animationController);
  }
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    topStart = size.height - size.height*0.8;
    distanceBetween = ((size.height - size.height*0.2) - topStart) / items.length;
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
                    children: items.map((item) {
                      return _getItemMenuTile(item);
                    }).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
        onVerticalDragStart: (details){
          if(details.globalPosition.dx > size.width * 0.85){
            start=true;
            animationController.forward();
            verticalLocation = details.globalPosition.dy;
            setState(() {});
          }
        },
        onVerticalDragUpdate: (details){
          if(start){
            verticalLocation = details.globalPosition.dy;
            horizontalLocation = details.globalPosition.dx;
            if(horizontalLocation < size.width*0.8)
              locked = true;
            else
              locked = false;
            setState(() {});
          }
        },
        onVerticalDragEnd: (details){
          if(start!=null && start){
            start=false;
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

  double _getWidthByIndex(int index){
    if(start!=null && start){
      double iStart = (topStart + (index * distanceBetween));
      double iEnd = (iStart + distanceBetween);
      if(verticalLocation>=iStart && verticalLocation<=iEnd && !locked){
        double mid = (distanceBetween/2);
        double vStart = verticalLocation - iStart;
        if(vStart > mid){
          return 30 * (mid/vStart);
        }else{
          return 30 * (vStart/mid);
        }
      }
    }
    return 0;
  }

  double _getHorizontalPosition(int index){
    if(start!=null && start){
      double iStart = (topStart + (index * distanceBetween));
      double iEnd = (iStart + distanceBetween);
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
        double margin = 10.0 * (items.length - ((index - selectingIndex).abs() * 1));
        return margin < 0 ? 0 : margin;
      }
    }
    return 0;
  }

  Widget _getItemMenuTile(SwipeUpMenuItem item){
    var index = items.indexOf(item);
    return Material(
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
                item.icon!=null ? Icon(item.icon, color: Colors.white) : Container(),
                item.icon!=null ? SizedBox(width: 6) : Container(),
                Expanded(
                  child: Text("${item.title}", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.center),
                )
              ],
            ),
            Positioned(
              left: (item.icon!=null ? -10 : -8),
              top: (item.icon!=null ? -13 : -5),
              child: Container(
                width: size.width * 0.04,
                height: size.width * 0.04,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
                child: Text("$item.notification", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  double _getHeightByIndex(int index){
    double iStart = (topStart + (index * distanceBetween));
    double iEnd = (iStart + distanceBetween);
    if(verticalLocation>=iStart && verticalLocation<=iEnd && (!locked || selectingIndex==index)){
      double mid = (distanceBetween/2);
      double vStart = verticalLocation - iStart;
      if(vStart > mid){
        return 10 * (mid/vStart);
      }else{
        return 10 * (vStart/mid);
      }
    }
    return distanceBetween * 0.1;
  }
}

class SwipeUpMenuItem{

  final String title;
  final Color backgroundColor;
  final IconData icon;

  SwipeUpMenuItem({
    @required this.title,
    this.icon,
    this.backgroundColor = Colors.white,
  }) : assert(title.isNotEmpty && title!=null);
}