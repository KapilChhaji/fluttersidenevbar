import 'package:alieample2/preferencesService.dart';
import 'package:alieample2/slidnevbar.dart';
import 'package:alieample2/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _preferencesService = PrefrencesServices();
  bool _passwordVisible = false;
 bool  loginuser=false;

  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    //checkLogin();
    _populateFiled();


  }

  void initstate() {
    super.initState();
    _passwordVisible = false;
  }

  void _populateFiled() async {
    final settings = await _preferencesService.getSettings();
    settings.isChecked == true
        ? setState(() {
            emailController.text = settings.email;
            passController.text = settings.password;
            isChecked = settings.isChecked;
          })
        : null;
  }
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
        body: Container(
        decoration: const BoxDecoration(
        image : DecorationImage(image: AssetImage("assetts/download.jpeg"),
    fit: BoxFit.cover),
    ),
          child: ListView(children: <Widget>[
      Column(children: [
          const Text('Sign in',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Your Email',
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: passController,
              obscureText: !_passwordVisible,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Type Your Password',
                suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toggle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              const Text("Remember Me"),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton.icon(
                  onPressed: () {
                    login();
                    _saveSettings();

                    //emailController.clear();
                    // passController.clear();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text("Login")),
            ],
          ),
      ])
    ]),
        )));
  }

  Future<void> login() async {
    if (passController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(Uri.parse("https://reqres.in/api/login"),
          body: ({
            'email': emailController.text,
            'password': passController.text
          }));
      if (response.statusCode == 200) {
        pageRoute('token');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid User"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fill All Text Filed"),
      ));
    }
  }

  void _saveSettings() async {
    final newSettings = Settings(
      email: emailController.text,
      password: passController.text,
      isChecked: isChecked,
    );
    print(newSettings);
    _preferencesService.saveSettings(newSettings);
  }
  void pageRoute(String token) async{
    SharedPreferences pref1=await SharedPreferences.getInstance();
    await pref1.setString('login', token);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return  const Sidenev();
        },
      ),
          (raute) => false,
    );


  }

  // Future<bool>_onBack(BuildContext context) async{
  //   bool? exitApp = await showDialog(context: context,
  //       builder: (BuildContext context){
  //     return AlertDialog(
  //       title: const Text("Really ??"),
  //       content: const Text("Do You want to closs the app"),
  //       actions: [
  //         TextButton(onPressed: (){
  //           Navigator.of(context).pop(false);
  //         },
  //             child: const Text("No")),
  //         TextButton(onPressed: (){
  //           Navigator.of(context).pop(true);
  //         },
  //             child: const Text("Yes"))
  //       ],
  //     );
  //       });
  //   return exitApp ?? false;
  // }
}
