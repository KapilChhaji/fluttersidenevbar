// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'MyStatefulWidget.dart';
//
// class Welcome extends StatefulWidget {
//   const Welcome({Key? key, required String title}) : super(key: key);
//
//   @override
//   State<Welcome> createState() => _Welcome();
// }
//
// class _Welcome extends State<Welcome> {
//   List<dynamic> users = [];
//   List<dynamic> users1 = [];
//   String token = "";
//   final scollController = ScrollController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCard();
//     fetchUsers();
//   }
//
//   Future<void> getCard() async {
//     SharedPreferences pref1 = await SharedPreferences.getInstance();
//     setState(() {
//       token = pref1.getString("login")!;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () => _onBack(context),
//         child: Scaffold(
//             body: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start, children: [
//               //const SizedBox(height: 45,width: 30,),
//               const Text("list of Users"),
//               Padding(
//                 padding: const EdgeInsets.only(top: 30, left: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "list of Users",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     OutlinedButton.icon(
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                         ),
//                         onPressed: () async {
//                           SharedPreferences pref1 =
//                           await SharedPreferences.getInstance();
//                           await pref1.remove("login");
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (BuildContext context) {
//                                 return const MyStatefulWidget();
//                               },
//                             ),
//                                 (raute) => false,
//                           );
//                         },
//                         icon: const Icon(Icons.exit_to_app),
//                         label: const Text("Logout")),
//                   ],
//                 ),
//               ),
//               NotificationListener<ScrollEndNotification>(
//                 onNotification: (scrollEnd) {
//                   final metrics = scrollEnd.metrics;
//                   if (metrics.atEdge) {
//                     bool isTop = metrics.pixels == 0;
//                     if (isTop) {
//                       print('At the top');
//                     } else {
//                       print(users1.last);
//                       users1+=users;
//                       print(users.length);
//                     }
//                   }
//                   return true;
//                 },
//                 child: Expanded(
//                     child: ListView.builder(
//                         itemCount: users1.length,
//                         itemBuilder: (context, index) {
//                           final user1 = users1[index];
//                           final firstName1 = user1['first_name'];
//                           final lastName1 = user1['last_name'];
//                           final email1 = user1['email'];
//                           final imageurl1 = user1['avatar'];
//
// // final user1 = users1[index];
// // final firstName1 = user1['first_name'];
// // final lastName1 = user1['last_name'];
// // final email1 = user1['email'];
// // final imageurl1 = user1['avatar'];
// //for (int i = 0; i <= 12; i++) {
// //   if (i < users.length) {
// //   users=users+users1;
//                           return Container(
//                             height: 400,
//                             child: ListTile(
// //leading: Text("${index+1}"),
//                               leading: ClipRRect(
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: Image.network(imageurl1)),
// //child: Text('${index+1}')),
//                               title: Text(firstName1 + " " + lastName1),
//                               subtitle: Text(email1),
//                             ),
//                           );
//
//                           //    }
//                         })),
//               ),
//             ]
//             )
//         )
//
//
//     );
//   }
//
//   Future<void> fetchUsers() async {
//     print("fetchUsers called");
//     const url1 = "https://reqres.in/api/users?page=1";
//     final uri1 = Uri.parse(url1);
//     final response = await http.get(uri1);
//
//     final body = response.body;
//     final json = jsonDecode(body);
//     setState(() {
//       users = json['data'];
//     });
//     const url2 = "https://reqres.in/api/users?page=2";
//     final uri2 = Uri.parse(url2);
//     final response1 = await http.get(uri2);
//
//     final body1 = response1.body;
//     final json1 = jsonDecode(body1);
//     setState(() {
//       users1 = json1['data'];
//       // if (scollController.position.didEndScroll) {
//       // print("new list is start");
//
//       // users1 = users1 + users;
//       // }
//     });
//
//     print("fatchUsers Complete");
//   }
//
//   Future<bool> _onBack(BuildContext context) async {
//     bool? exitApp = await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text("Really ??"),
//             content: const Text("Do You want to closs the app"),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(false);
//                   },
//                   child: const Text("No")),
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(true);
//                   },
//                   child: const Text("Yes"))
//             ],
//           );
//         });
//     return exitApp ?? false;
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MyStatefulWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // We will fetch data from this Rest api
  String token = "";
  final _baseUrl = 'https://reqres.in/api/users';

  // At the beginning, we fetch the first 20 posts
  int _page = 1;

  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 20;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    getCard();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(   decoration: const BoxDecoration(
        image : DecorationImage(image: AssetImage("assetts/download.jpeg"),
            fit: BoxFit.cover),
      ),

        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              // const Text("list of Users"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "list of Users",
                    style: TextStyle(fontSize: 20),
                  ),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
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
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text("Logout")),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Scaffold(
                  body: _isFirstLoadRunning
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: _posts.length,
                                itemBuilder: (_, index) => Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  child: SizedBox(
                                    height: 200,
                                    child: ListTile(
                                      leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.network(
                                              _posts[index]['avatar'])),
                                      title: Text(_posts[index]['first_name'] +" "+
                                          _posts[index]['last_name']),
                                      subtitle: Text(_posts[index]['email']),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // when the _loadMore function is running
                            if (_isLoadMoreRunning == true)
                              const Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 40),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),

                            // When nothing else to load
                            if (_hasNextPage == false)
                              Container(
                                padding: const EdgeInsets.only(top: 30, bottom: 40),
                                color: Colors.amber,
                                child: const Center(
                                  child:
                                      Text('You have fetched all of the content'),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<bool> _onBack(BuildContext context) async {
  //   bool? exitApp = await showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text("Really ??"),
  //           content: const Text("Do You want to closs the app"),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //                 child: const Text("No")),
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(true);
  //                 },
  //                 child: const Text("Yes"))
  //           ],
  //         );
  //       });
  //   return exitApp ?? false;
  // }
  Future<void> getCard() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    setState(() {
      token = pref1.getString("login")!;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Inc// rease _page by 1
      try {
        final uri1 = Uri.parse("$_baseUrl?page=$_page&_limit=$_limit");
        final response = await http.get(uri1);

        final body = response.body;
        final json = jsonDecode(body);

        final List fetchedPosts = json["data"];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final uri1 = Uri.parse("$_baseUrl?page=$_page&_limit=$_limit");
      final response = await http.get(uri1);

      final body = response.body;
      final json = jsonDecode(body);
      setState(() {
        _posts = json['data'];
      });
    } catch (err) {
      if (kDebugMode) {
        print('Something wenut wrong');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }
}
