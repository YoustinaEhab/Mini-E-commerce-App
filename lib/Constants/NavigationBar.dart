import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:support_ecommerce_project/Screens/Favourites.dart';
import 'package:support_ecommerce_project/Screens/Home.dart';
import 'package:support_ecommerce_project/Screens/Profile.dart';

class Navigation_Bar extends StatefulWidget {
  const Navigation_Bar({Key? key}) : super(key: key);

  @override
  State<Navigation_Bar> createState() => Navigation_BarState();
}

 class Navigation_BarState extends State<Navigation_Bar> {

  int index =0;
  final pages = [
    Home(),
    Favorites(),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: BottomNavigationBar(
                showUnselectedLabels: true,
                backgroundColor: Colors.white,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.indigo,
                currentIndex: index,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home_outlined,color: Colors.grey),label: "Home",activeIcon: Icon(Icons.home,color: Colors.indigo,)),
                  BottomNavigationBarItem(icon: Icon(Icons.favorite_border, color: Colors.grey),label: "Favorites",activeIcon: Icon(Icons.favorite,color: Colors.indigo,)),
                  BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, color: Colors.grey),label: "Profile",activeIcon: Icon(Icons.person,color: Colors.indigo,)),
                ],
                onTap: (index) {
                  setState(() {
                    this.index = index;
                  });
                }
            )
        ),
      ),
      body: pages[index],
    );
  }
}
