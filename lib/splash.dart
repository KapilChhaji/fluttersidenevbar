import 'dart:async';
import 'package:alieample2/slidnevbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyStatefulWidget.dart';
class Splash extends StatefulWidget {
   Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _Splash();
}


class _Splash extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=> checkLogin()
    );
  }
  void checkLogin()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
     String? val = pref.getString("login");
    if( val!=null) {
     Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
         builder: (BuildContext context) {
            return const Sidenev();

              //title: '',             );
           },
         ),
             (raute) => false,
       );
   }
    else{
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return const MyStatefulWidget();
          },
        ),
            (raute) => false,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image : DecorationImage(image: AssetImage("assetts/new.gif"),
              fit: BoxFit.cover),
        ),
      //  child: Image.asset("assetts/exodus.gif" ,height: 1000,width: 700,)
    );
  }
}
// Expanded(
// child: ListView.builder(
//
// itemCount: 12,
// itemBuilder: (context, index) {
// final user = users[index];
// final firstName = user['first_name'];
// final lastName = user['last_name'];
// final email = user['email'];
// final imageurl = user['avatar'];
// // final user1 = users1[index];
// // final firstName1 = user1['first_name'];
// // final lastName1 = user1['last_name'];
// // final email1 = user1['email'];
// // final imageurl1 = user1['avatar'];
// for (int i = 0; i <= 12; i++) {
// if (i < users.length) {
// users=users+users1;
// return Container(
// height: 400,
// child: ListTile(
//
// //leading: Text("${index+1}"),
// leading: ClipRRect(
// borderRadius: BorderRadius.circular(100),
//
// child: Image.network(imageurl)),
// //child: Text('${index+1}')),
// title: Text(firstName + " " + lastName),
// subtitle: Text(email),
// ),
// );
// } else {
//
// // return Container(
// //   height: 400,
// //   child: ListTile(
// //
// //     //leading: Text("${index+1}"),
// //     leading: ClipRRect(
// //         borderRadius: BorderRadius.circular(100),
// //
// //         child: Image.network(imageurl1)),
// //     //child: Text('${index+1}')),
// //     title: Text(firstName1 + " " + lastName1),
// //     subtitle: Text(email1),
// //   ),
// // );
// }
// }
// }
// ),
// ),
