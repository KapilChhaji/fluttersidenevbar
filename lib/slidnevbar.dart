import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alieample2/preferencesService.dart';
import 'package:alieample2/welcome.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'MyStatefulWidget.dart';

class Sidenev extends StatefulWidget {
  const Sidenev({Key? key}) : super(key: key);

  @override
  State<Sidenev> createState() => _Sidenev();
}

class _Sidenev extends State<Sidenev> {
 // final emailController = TextEditingController();
  //final passController = TextEditingController();

  void initstate() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(backgroundColor: Colors.black,
        title: const Text('Welcome User'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image : DecorationImage(image: AssetImage("assetts/images.jpeg"),
              fit: BoxFit.cover),
        ),
        child: const Center(
          child: Text('Welcome to HomePage',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  List<dynamic> users = [];
  List<dynamic> users1 = [];
  final _preferencesService = PrefrencesServices();
  @override
  void initState() {
    super.initState();
    getCard();
    fetchUsers();
    _populateFiled();
  }
  String email1="";
  String token = "";

  void _populateFiled() async {
    final settings = await _preferencesService.getSettings();
    setState(() {
      email1 = settings.email;
    });

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:23.0),
      child: Drawer(

         child: Container(
           decoration: const BoxDecoration(
             image : DecorationImage(image: AssetImage("assetts/download.jpeg"),
                 fit: BoxFit.cover),
           ),
           child: Column(
             children: [
               const SizedBox(
                 height: 10,

           ),
      for (var value in users)
        if(value['email']==email1)
            //Text(value['first_name']+value['last_name']),
      ListTile(
      //
                        leading:  ClipRRect(
                           borderRadius: BorderRadius.circular(100),
                          child:
                          Image.network(value['avatar'])),
                      title: Text(value['first_name'] + " " + value['last_name'])
                      //subtitle: Text(email1),
                   ),



           Expanded(
             child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Welcome'),
                  onTap: () => {
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.verified_user),
                  title: const Text('List Of User'),
                  onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomePage()));},
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: const Icon(Icons.border_color),
                  title: const Text('Feedback'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Logout'),

                  onTap: ()  async {
                    SharedPreferences pref1 =
                    await SharedPreferences.getInstance();
                    await pref1.remove("login");
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const MyStatefulWidget();
                        },
                      ),
                          (raute) => false,
                    );
                  },
                ),
              ],
        ),
           ),

      ],
      ),
         ),
      ),
    );
  }
  Future<void> getCard() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    setState(() {
      token = pref1.getString("login")!;
    });
  }
  Future<void> fetchUsers() async {
    print("fetchUsers called");
    const url1 = "https://reqres.in/api/users?page=1";
     final uri1 = Uri.parse(url1);
     final response = await http.get(uri1);
    final body = response.body;
     final json = jsonDecode(body);
     setState(() {
       users = json['data'];
     });
    const url2 = "https://reqres.in/api/users?page=2";
    final uri2 = Uri.parse(url2);
    final response1 = await http.get(uri2);

     final body1 = response1.body;
     final json1 = jsonDecode(body1);
    setState(() {
      users1 = json1['data'];
      users+=users1;
    });

     print("fetchUsers Complete");
  }

}
