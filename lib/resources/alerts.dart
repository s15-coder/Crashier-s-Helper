import 'package:flutter/material.dart';
import 'package:market_scanner/resources/static_r.dart';

class Alerts {
  static final _singleton = Alerts._();
  Alerts._();
  factory Alerts() => _singleton;

  ///The actions [ActionModel] are used like predefined buttons.
  ///
  ///Max can pass two buttons or nothing if you dont need it.
  Future showGenericAlert({
    required BuildContext context,
    required String tilte,
    required String description,
    bool isDismissible = true,
    Widget? content,
    ActionModel? actionOne,
    ActionModel? actionTwo,
  }) async {
    Size size = MediaQuery.of(context).size;

    await showDialog(
        barrierDismissible: isDismissible,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              tilte,
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  description,
                  textAlign: TextAlign.center,
                ),
                content != null ? content : Container(),
                ..._getButtonsSection(
                    size: size, actionOne: actionOne, actionTwo: actionTwo)
              ],
            ),
            actionsOverflowButtonSpacing: 15,
          );
        });
  }
}

List<Widget> _getButtonsSection({
  required Size size,
  ActionModel? actionOne,
  ActionModel? actionTwo,
}) {
  List<Widget> widgets = [];
  int amountButtons = 0;
  if (actionOne != null) {
    amountButtons++;
  }
  if (actionTwo != null) {
    amountButtons++;
  }
  if (amountButtons > 0) {
    widgets.add(SizedBox(height: size.height * 0.03));
  }
  if (actionOne != null && actionTwo != null) {
    widgets.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [getChoosenButton(actionOne), getChoosenButton(actionTwo)],
    ));
  } else if (actionOne != null) {
    widgets.add(getChoosenButton(actionOne));
  } else if (actionTwo != null) {
    widgets.add(getChoosenButton(actionTwo));
  }
  return widgets;
}

class ActionModel {
  VoidCallback onPressed;
  String title;
  bool filled;
  ActionModel(
      {required this.onPressed, required this.title, this.filled = true});
}

Widget getChoosenButton(ActionModel actionModel) {
  if (!actionModel.filled) {
    return TextButton(
        onPressed: actionModel.onPressed,
        child: Text(
          actionModel.title,
          style: TextStyle(color: StaticResources.darkPuple),
        ));
  } else {
    return ElevatedButton(
      onPressed: actionModel.onPressed,
      child: Text(actionModel.title),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        backgroundColor:
            MaterialStateProperty.all<Color>(StaticResources.darkPuple),
      ),
    );
  }
}
