import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';

enum AnimationType {
  Open,
  Close,
  BlurTappedOn,
  BlurTappedOff,
  VideoTapped,
  ChatTapped,
  PhoneTapped,
  NoOp,
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FlareButtonAnimation(),
    );
  }
}

class FlareButtonAnimation extends StatefulWidget {
  @override
  _FlareButtonAnimationState createState() => _FlareButtonAnimationState();
}

class _FlareButtonAnimationState extends State<FlareButtonAnimation> {
  final FlareControls animationControls = FlareControls();
  double assetWidth, assetHeight, middleOfAsset, buttonDiameter;

  bool isOpen;
  bool blurOn;

  AnimationType currentAnimation;

  @override
  void initState() {
    super.initState();

    assetWidth = 100;
    assetHeight = 550;
    middleOfAsset = assetWidth / 2;
    buttonDiameter = 56;
    isOpen = false;
    blurOn = true;
    currentAnimation = AnimationType.NoOp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      width: assetWidth,
      height: assetHeight,
      child: GestureDetector(
        onTapUp: (detail) {
          Offset localPosition = (context.findRenderObject() as RenderBox)
              .globalToLocal(detail.globalPosition);

          getPosition(localPosition);

          animationControls.play(getAnimationString(currentAnimation));

          print(localPosition.dy);
        },
        child: FlareActor(
          'assets/flare/dynamic-button.flr',
          controller: animationControls,
          animation: '',
        ),
      ),
    );
  }

  getPosition(Offset localPos) {
    if (localPos.dy <= 525.0 && localPos.dy >= 470.0) {
      if (isOpen) {
        currentAnimation = AnimationType.Close;
      } else {
        currentAnimation = AnimationType.Open;
      }
      isOpen = !isOpen;
    } else if (localPos.dy <= 460.0 && localPos.dy >= 405 && isOpen == true) {
      currentAnimation = AnimationType.PhoneTapped;
    } else if (localPos.dy <= 395.0 && localPos.dy >= 340.0 && isOpen == true) {
      currentAnimation = AnimationType.ChatTapped;
    } else if (localPos.dy <= 330.0 && localPos.dy >= 275.0 && isOpen == true) {
      currentAnimation = AnimationType.VideoTapped;
    } else if (localPos.dy <= 265.0 && localPos.dy >= 210.0 && isOpen == true) {
      if (blurOn) {
        currentAnimation = AnimationType.BlurTappedOff;
      } else {
        currentAnimation = AnimationType.BlurTappedOn;
      }
    } else {
      currentAnimation = AnimationType.NoOp;
    }

    setState(() {});
  }

  String getAnimationString(AnimationType currentAnimation) {
    switch (currentAnimation) {
      case AnimationType.Open:
        return "open";
      case AnimationType.Close:
        return "close";
      case AnimationType.BlurTappedOn:
        return "blur_tapped_on";
      case AnimationType.BlurTappedOff:
        return "blur_tapped_off";
      case AnimationType.VideoTapped:
        return "video_tapped";
      case AnimationType.ChatTapped:
        return "chat_tapped";
      case AnimationType.PhoneTapped:
        return 'phone_tapped';
      case AnimationType.NoOp:
        return '';
    }
    return '';
  }
}
