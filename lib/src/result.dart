import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mathmodel.dart';

class Result extends StatefulWidget {
  final TabController tabController;
  
  Result({@required this.tabController});

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> with TickerProviderStateMixin {

  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    final mathModel = Provider.of<MathModel>(context, listen: false);
    mathModel.addListener(() {
      mathModel.isClearable?animationController.forward():animationController.reset();
    });
    animationController = AnimationController(duration: const Duration(milliseconds: 400),vsync: this);
    final curve = CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack);
    animation = Tween<double>(begin: 30.0, end: 60.0).animate(curve)
      ..addListener(() {setState(() {});});
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: animation.value,
      width: double.infinity,
      alignment: Alignment.centerRight,
      child: Consumer<MathModel>(
        builder: (context, model, _) {
          final _textController = TextEditingController();
          if (model.result!='' && animationController.status == AnimationStatus.dismissed) {
            _textController.text = '= ' + model.result;
          } else {
            _textController.text = model.result;
          }
          // if (model.latexExp.last.contains('matrix')) {
          //   widget.tabController.index = 1;
          // } else {
          //   widget.tabController.index = 0;
          // }
          return TabBarView(
            controller: widget.tabController,
            children: <Widget>[
              TextField(
                controller: _textController,
                readOnly: true,
                textAlign: TextAlign.right,
                autofocus: true,
                decoration: null,
                style: TextStyle(
                  fontFamily: 'Minion-Pro',
                  fontSize: animation.value - 5,
                ),
              ),
              ToggleButtons(
                children: <Widget>[
                  Text('Invert'),
                  Text('TBD'),
                ],
                isSelected: [false, false],
                onPressed: (index) {
                  print(index);
                },
              ),
            ],
          );
        }
      ),
    );
  }
}
