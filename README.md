# Swipe Up Menu
[![Pub](https://img.shields.io/pub/v/swipe_up_menu.svg)](https://pub.dev/packages/swipe_up_menu)
[![Pull Requests are welcome](https://img.shields.io/badge/license-MIT-blue)](https://github.com/rod90ad/swipe_up_menu/blob/master/LICENSE)
[![Pull Requests are welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](https://github.com/rod90ad/swipe_up_menu/pulls)
[![Codemagic build status](https://api.codemagic.io/apps/5e2ef0fa151bb635435f124a/5e2ef0fa151bb635435f1249/status_badge.svg)](https://codemagic.io/apps/5e2ef0fa151bb635435f124a/5e2ef0fa151bb635435f1249/latest_build)

A Flutter package to create a Swipe Menu who appears when slide on the right side of screen.

![Showcase](https://i.imgur.com/j5rhcvF.gif)

# Basic Usage

```dart
SwipeUpMenu(
    body: <Widget>[
        Scaffold(appBar: AppBar(title: Text("Page 1"), centerTitle:  true), backgroundColor: Colors.blue),
        Scaffold(appBar: AppBar(title: Text("Page 2"), centerTitle:  true), backgroundColor: Colors.yellow),
    ],
    items: <SwipeUpMenuItem>[
        SwipeUpMenuItem(title: Text("Menu 1"), icon: Icon(Icons.home, color: Colors.white), backgroundColor: Colors.blue),
        SwipeUpMenuItem(title: Text("Menu 2"), icon: Icon(Icons.mail, color: Colors.white), backgroundColor: Colors.yellow),
    ],
    startIndex: 0,
    onChange: (index){}
)
```

### Options

| Property | Type | Description | Default |
|----------|------|-------------|---------|
| `required` body | List<Widget> | The list of body of your App | -
| `required` items | List<SwipeUpMenuItem> | The list of items to show in menu | -
| startIndex | Integer | The start index of menus | `0`
| onChange | Function | The function who return a index when it change | `null`