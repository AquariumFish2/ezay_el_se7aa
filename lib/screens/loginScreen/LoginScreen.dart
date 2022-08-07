import 'package:docs/controllers/login/cityLoginController.dart';
import 'package:docs/controllers/login/loginController.dart';
import 'package:docs/controllers/login/roleLoginController.dart';
import 'package:docs/controllers/login/specLoginController.dart';
import 'package:docs/screens/loginScreen/widgets/loginDrobDownButton.dart';
import 'package:docs/screens/loginScreen/widgets/loginTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailTextcontroller = TextEditingController();
  final TextEditingController userNameTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController passwordConfirmTextController =
      TextEditingController();
  final TextEditingController phoneNumberTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned(
            bottom: 0,
            child: Container(
                width: 100.w,
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.fill,
                ))),
        SizedBox(
          height: 100.h,
          child: Form(
            child: SingleChildScrollView(
              child: Consumer<LoginController>(
                builder: (context, loginController, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 20.h,
                      child: Image.asset('assets/logo.jpg'),
                    ),
                    if (loginController.newUSer)
                      LoginTextFormField(
                          label: 'use name',
                          controller: userNameTextController,
                          tKey: const Key('userName'),
                          textInputAction: TextInputAction.next,
                          save: (v) {},
                          validate: (v) {
                            if (loginController.newUSer && v!.length < 2) {
                              return 'enter user name 3 letter at least';
                            }
                          },
                          multiline: false),
                    LoginTextFormField(
                        label: 'email address',
                        controller: emailTextcontroller,
                        tKey: const Key('email'),
                        save: () {},
                        validate: (v) {
                          if (!v!.contains('@') && !v.contains('.com')) {
                            return 'enter an email';
                          }
                        },
                        multiline: false),
                    LoginTextFormField(
                      textInputAction: TextInputAction.next,
                      invisible: true,
                      label: 'password',
                      controller: passwordTextController,
                      tKey: Key('password key'),
                      multiline: false,
                      save: (v) {},
                      validate: (v) {
                        if (v!.length < 8) {
                          return "enter 8 letters at least";
                        }
                      },
                    ),
                    if (loginController.newUSer)
                      LoginTextFormField(
                        textInputAction: TextInputAction.next,
                        invisible: true,
                        label: 'confirm password',
                        controller: passwordConfirmTextController,
                        tKey: const Key('password confirm'),
                        multiline: false,
                        save: (v) {},
                        validate: (v) {
                          if (v != passwordTextController.text) {
                            return 'the password doens\'t match';
                          }
                          if (v!.length < 8) {
                            return 'enter 8 letters at least';
                          }
                        },
                      ),
                    if (loginController.newUSer)
                      LoginTextFormField(
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.number,
                          label: 'phone number',
                          controller: phoneNumberTextController,
                          tKey: const Key('phone number'),
                          save: (v) {},
                          validate: (String? v) {
                            if (!v!.startsWith('0') &&
                                v.length != 10 &&
                                v.length != 11) {
                              return 'enter a right phone number';
                            }
                          },
                          multiline: false),
                    if (loginController.newUSer)
                      Consumer<CityLoginController>(
                        builder: ((context, cityLogController, _) =>
                            LoginDrobDownButton(
                                value: cityLogController.city,
                                onChanged: cityLogController.setCity,
                                hint: 'enter city',
                                items: cityLogController.cityItems)),
                      ),
                    if (loginController.newUSer)
                      Consumer<RoleLoginController>(
                          builder: (context, roleLogController, snapshot) {
                        return LoginDrobDownButton(
                            value: roleLogController.role,
                            onChanged: roleLogController.setRole,
                            hint: "your role in team",
                            items: roleLogController.roleItems);
                      }),
                    if (loginController.newUSer)
                      Consumer<SpecLoginController>(
                        builder: (context, specLogController, _) =>
                            LoginDrobDownButton(
                                value: specLogController.spec,
                                onChanged: specLogController.setSpec,
                                hint: "Specialization",
                                items: ['ss']),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                          onPressed: () {},
                          child: (!loginController.newUSer)
                              ? const Text('login')
                              : const Text('sign up')),
                    ),
                    TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromRGBO(255, 255, 255, 0))),
                      onPressed: () {
                        loginController.togleNewUSer();
                      },
                      child: (!loginController.newUSer)
                          ? const Text('sign up')
                          : const Text('signin'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
