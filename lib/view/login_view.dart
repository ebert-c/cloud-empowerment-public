import 'package:cloudempowerment/util/auth.dart';
import 'package:cloudempowerment/util/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../model/session_model.dart';
import '../util/util.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> _loginKey = GlobalKey<ScaffoldState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Session? newSession = null;

  Future<void> login(String username, String password) async {
    final progress = ProgressHUD.of(_loginKey.currentContext!);
    progress?.show();
    Session session = await LoginController().login(username, password, newSession);

    progress?.dismiss();
    if (session.isValid) {
      Navigator.of(context).popAndPushNamed(ROUTES.HOME, arguments: session);
      if (!await AppConnectivity.isConnected()) {
        showToast(STRINGS.OFFLINE_MODE_NOTIFICATION);
      }
    } else {
      showToast(STRINGS.INVALID_CREDENTIALS);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: COLORS.WHITE,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
        child: ProgressHUD(
          indicatorColor: COLORS.RED,
          backgroundColor: COLORS.LIGHT_GREY,
          borderColor: COLORS.GREY,
          barrierColor: COLORS.TRANSPARENT,
          child: Column(
            key: _loginKey,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(48),
                child: Container(
                  child: Image(image: AssetImage('assets/logo.png')),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                STRINGS.SIGN_IN,
                style: TextStyle(
                    color: COLORS.BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    STRINGS.HI_THERE_NICE_TO_SEE_YOU_AGAIN,
                    style: TextStyle(
                        color: COLORS.BLACK, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    STRINGS.USERNAME,
                    style: TextStyle(
                        color: COLORS.RED, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextField(
                cursorColor: COLORS.RED,
                controller: usernameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  fillColor: COLORS.WHITE,
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: COLORS.RED),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    STRINGS.PASSWORD,
                    style: TextStyle(
                        color: COLORS.RED, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextField(
                obscureText: true,
                cursorColor: COLORS.RED,
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  // border: InputBorder.none,
                  fillColor: COLORS.WHITE,
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: COLORS.RED),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () =>
                      {login(usernameController.text.trim(), passwordController.text)},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(COLORS.RED),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: Text(STRINGS.SIGN_IN,
                        maxLines: 1,
                        style: TextStyle(fontSize: 20, color: COLORS.WHITE)),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MaterialButton(
                    onPressed: () => {},
                    child: Text(STRINGS.FORGOT_PASSWORD),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
