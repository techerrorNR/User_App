import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/NotYetReceivedParcels/not_yet_received_parcels_screen.dart';
import 'package:users_app/authScreens/auth_screen.dart';
import 'package:users_app/history/history_screen.dart';
import 'package:users_app/ordersScreens/orders_screen.dart';
import 'package:users_app/sellersScreens/home_screen.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String? photoUrl;
  late String? name;

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  void loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      photoUrl = prefs.getString("photoUrl");
      name = prefs.getString("name");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      child: ListView(
        children:[
          //Header
          Container(
            padding:const EdgeInsets.only(top: 26,bottom:12),
            child:  Column(
              children: [
                // User   Profile
                SizedBox(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      photoUrl ?? "", // Use ?? "" to handle null case
                    ),
                  ),
                ),
                SizedBox(height:12,),


                Text(
                  name ?? "", // Use ?? "" to handle null case
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:12,),
              ],
            ),
          ),
          //Body
          Container(
            padding: const EdgeInsets.only(top:1),
            child:Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // Home
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.orange),
                  title: const Text(
                    "HOME",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // My Order
                ListTile(
                  leading: const Icon(Icons.shopping_cart_rounded, color: Colors.orange),
                  title: const Text(
                    "My Order",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> OrdersScreen()));

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // Not yet received Order
                ListTile(
                  leading: const Icon(Icons.picture_in_picture_alt_rounded, color: Colors.orange),
                  title: const Text(
                    "Not yet received Order",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetReceivedParcelsScreen()));


                  },
                ),
                //
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // History
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.orange),
                  title: const Text(
                    "History",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));

                  },
                ),

                // Other list tiles...
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // Search
                ListTile(
                  leading: const Icon(Icons.search, color: Colors.orange),
                  title: const Text(
                    "Search",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {

                  },
                ),
                //
                const Divider(
                  height: 10,
                  color: Colors.indigoAccent,
                  thickness: 5,
                ),
                // My Order
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.orange),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.orange),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));

                  },
                ),
                //

              ],
            ),
          )
        ],
      ),

    );
  }
}
