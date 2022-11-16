import 'package:find_track_app/auth/bloc/auth_bloc.dart';
import 'package:find_track_app/providers/songs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
        image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage(
                'assets/back3.gif'))),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Image.asset(
              "assets/musical-note.png",
              height: 120,
            ),
           SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left:20.0),
              child: Text(
                "Utiliza un red social",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize:18)
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0, right:8.0),
              child: MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.google),
                    SizedBox(width:10),
                    Text("Iniciar con Google"),
                  ],
                ),
                color: Color.fromARGB(255, 253, 2, 232),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}