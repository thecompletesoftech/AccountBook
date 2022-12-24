import 'package:flutter/material.dart';
import '../../Constant/Strings/Strings.dart';
import '../../Constant/TextStyles/Textstyles.dart';
import '../Constant/Colors/Colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Container(
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 12,
            color: Color.fromRGBO(0, 0, 0, 0.16),
          )
        ], color: MyColors.primarycolor),
        child: Container(
          padding: EdgeInsets.only(left: 10),
          height: size.height*0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'image/logo_bar.png',
                height: 35,
                width: 35,
              ),
              SizedBox(
                width: 13,
              ),
              Text(
                'My Business',
                style: TextStyle(fontSize: 16,color:Colors.white),
              ),
              SizedBox(
                width: 14,
              ),
              Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
