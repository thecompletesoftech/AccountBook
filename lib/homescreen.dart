// import 'package:account_book/custom_icons_icons.dart';
// import 'package:account_book/screens/homescreen.dart';
// import 'package:account_book/screens/moneyscreen.dart';
// import 'package:account_book/screens/morescreeen.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int selectedIndex = 0;
//   final screens = [
//     HomeScreen(),
//     MoneyScreen(),
//     MoreScreen(),
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           child: InkWell(
//             onTap: () {},
//             splashColor: Colors.black,
//             child: InkWell(
//               onTap: () {
//                 debugPrint('clicked!');
//               },
//               child: AppBar(
//                 elevation: 0,
//                 backgroundColor: Colors.blue[800],
//                 // hides leading widget
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Image.asset(
//                       'image/logo_bar.png',
//                       height: 35,
//                       width: 35,
//                     ),
//                     SizedBox(
//                       width: 13,
//                     ),
//                     Text(
//                       'My Business',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(
//                       width: 14,
//                     ),
//                     Icon(
//                       Icons.edit,
//                       size: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           preferredSize: Size.fromHeight(55.0))

//       // child: Row(
//       //   mainAxisAlignment: MainAxisAlignment.start,
//       //   children: [
//       //     Image.asset(
//       //         'image/logo_bar.png',
//       //       height: 35,
//       //       width: 35,
//       //     ),
//       //     SizedBox(width: 13,),
//       //
//       //     Text('My Business',style: TextStyle(fontSize: 16),),
//       //
//       //     SizedBox(width: 14,),
//       //
//       //     Icon(Icons.edit,size: 20,),
//       //
//       //
//       //   ],
//       // ),
//       ,
//       body: IndexedStack(
//         index: selectedIndex,
//         children: screens,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home_outlined,
//                 size: 28,
//               ),
//               label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(CustomIcons.rupee), label: 'Money'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.widgets_outlined), label: 'More'),
//         ],
//         currentIndex: selectedIndex,
//         selectedItemColor: Colors.blue[800],
//         onTap: (index) => setState(() => selectedIndex = index),
//       ),
//     );
//   }
// }
