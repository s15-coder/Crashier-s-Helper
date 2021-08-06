import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';
import 'package:market_scanner/services/service_api.dart';
import 'package:market_scanner/views/pages/beauty_divider.dart';
import 'package:market_scanner/views/widget/custom_textfield.dart';
import 'package:market_scanner/views/widget/social_container.dart';
import 'package:market_scanner/views/widget/title_developer.dart';

class DeveloperPage extends StatelessWidget {
  DeveloperPage({Key? key}) : super(key: key);
  static final routeName = "developer_page";
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: StaticResources.darkPuple,
        centerTitle: true,
        title: Text('Developer'),
      ),
      body: Container(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DeveloperTitle(),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  SocialContainer(
                    iconData: FontAwesomeIcons.linkedin,
                    onPressed: () => Utils().launchTo(
                      'https://www.linkedin.com/in/esteban15/',
                    ),
                  ),
                  SocialContainer(
                    iconData: Icons.email,
                    onPressed: () => Utils().launchTo(
                      'mailto:serestebanoo@gmail.com?subject=Contactado por aplicación&&body=Hola Esteban, ví tu aplicación y me contacte porque ',
                    ),
                  ),
                  SocialContainer(
                    iconData: FontAwesomeIcons.whatsapp,
                    onPressed: () => Utils().launchTo(
                        'https://wa.me/+573207193212?text=Hola Esteban, ví tu aplicación y me contacte porque '),
                  ),
                ],
              ),
              BeautyDivider(),
              Container(
                margin: EdgeInsets.only(
                  right: size.width * 0.1,
                  left: size.width * 0.1,
                  top: size.height * 0.04,
                ),
                child: CustomTextField(
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email,
                    color: StaticResources.darkPuple,
                  ),
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'Email',
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: size.width * 0.1,
                  right: size.width * 0.1,
                  top: size.height * 0.04,
                  bottom: size.height * 0.02,
                ),
                child: CustomTextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  controller: messageController,
                  labelText: 'Message',
                  hintText: 'Message',
                  maxLength: 350,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String message = messageController.text;
                  if (email.isNotEmpty && message.isNotEmpty) {
                    if (emailRegExp.hasMatch(email)) {
                      Alerts().showGenericAlert(
                          isDismissible: false,
                          context: context,
                          tilte: "Loading",
                          description: "Please wait...");

                      Map response = await ServiceApi().sendMessage(
                        email,
                        message,
                      );
                      Navigator.pop(context);
                      if (response["ok"]) {
                        emailController.text = "";
                        messageController.text = "";

                        Alerts().showGenericAlert(
                            context: context,
                            tilte: "Successful",
                            description: "Message sent succesfully",
                            actionOne: ActionModel(
                              onPressed: () => Navigator.pop(context),
                              title: "Accept",
                              filled: true,
                            ));
                      } else {
                        Alerts().showGenericAlert(
                            context: context,
                            tilte: "Wrong",
                            description: "Something went wrong, try later.",
                            actionOne: ActionModel(
                              onPressed: () => Navigator.pop(context),
                              title: "Accept",
                              filled: true,
                            ));
                      }
                      print(response);
                    } else {
                      Alerts().showGenericAlert(
                          context: context,
                          tilte: "Valid Email",
                          description: "Insert a valid email",
                          actionOne: ActionModel(
                            onPressed: () => Navigator.pop(context),
                            title: "Accept",
                            filled: true,
                          ));
                    }
                  } else {
                    Alerts().showGenericAlert(
                        context: context,
                        tilte: "Requiered field",
                        description: "You must fill both fields.",
                        actionOne: ActionModel(
                          onPressed: () => Navigator.pop(context),
                          title: "Accept",
                          filled: true,
                        ));
                  }
                },
                child: Text(
                  "Send",
                  style: TextStyle(fontSize: 19),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 30, vertical: 13)),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      StaticResources.darkPuple),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
