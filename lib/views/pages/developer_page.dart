import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_scanner/resources/alerts.dart';
import 'package:market_scanner/resources/static_r.dart';
import 'package:market_scanner/resources/utils.dart';
import 'package:market_scanner/services/service_api.dart';
import 'package:market_scanner/views/widget/beauty_divider.dart';
import 'package:market_scanner/views/widget/custom_textfield.dart';
import 'package:market_scanner/views/widget/social_container.dart';
import 'package:market_scanner/views/widget/title_developer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.developer),
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
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.email,
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
                  labelText: AppLocalizations.of(context)!.message,
                  hintText: AppLocalizations.of(context)!.message,
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
                              title: AppLocalizations.of(context)!.accept,
                              filled: true,
                            ));
                      } else {
                        Alerts().showGenericAlert(
                            context: context,
                            tilte: AppLocalizations.of(context)!.error,
                            description: AppLocalizations.of(context)!.tryLater,
                            actionOne: ActionModel(
                              onPressed: () => Navigator.pop(context),
                              title: AppLocalizations.of(context)!.accept,
                              filled: true,
                            ));
                      }
                      print(response);
                    } else {
                      Alerts().showGenericAlert(
                          context: context,
                          tilte: AppLocalizations.of(context)!.invalidEmail,
                          description:
                              AppLocalizations.of(context)!.inserValidEmail,
                          actionOne: ActionModel(
                            onPressed: () => Navigator.pop(context),
                            title: AppLocalizations.of(context)!.accept,
                            filled: true,
                          ));
                    }
                  } else {
                    Alerts().showGenericAlert(
                        context: context,
                        tilte: AppLocalizations.of(context)!.requiredFields,
                        description:
                            AppLocalizations.of(context)!.fillBothFields,
                        actionOne: ActionModel(
                          onPressed: () => Navigator.pop(context),
                          title: AppLocalizations.of(context)!.accept,
                          filled: true,
                        ));
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.send,
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
