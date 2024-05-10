import 'package:flutter/material.dart';
import 'package:users_app/authScreens/login_tab_page.dart';
import 'package:users_app/authScreens/registration_tab_page.dart';
class AuthScreen extends StatefulWidget
{
  const AuthScreen({super.key});



  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:AppBar (
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors:
                [
                  Colors.deepOrangeAccent,
                  Colors.green,

                ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          title:const Text(
            "Reuseits",
                style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
        ),
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.white54,
              tabs:[
                Tab(
                  text: "login",
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  text: "Registraion ",
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                )

          ]
          ),


        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors:
              [
                Colors.deepOrangeAccent,
                Colors.green,

              ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: TabBarView(
            children: [
              LoginTabPage(),
              RegistrationTabPage(),
          ],
          ),

        ),
      )
        );
  }
}
