import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/MoneyGaveScreen.dart';
import 'package:account_book/screens/MoneyGotScreen.dart';
import 'package:account_book/screens/customertransactions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';


import '../Constant/TextStyles/Textstyles.dart';

class Edit_Entry extends StatefulWidget {
  final Contact? contact;
  final p_image;
  final name;
  final amount;
  final type;
  final mobile_no;
  final entry_id;
  final u_id;
  final des;
  Edit_Entry(
      {Key? key,
      this.contact,
      this.p_image,
      this.name,
      this.amount,
      this.type,
      this.mobile_no,
      this.entry_id,
      this.u_id,
      this.des})
      : super(key: key);

  @override
  State<Edit_Entry> createState() => _Edit_EntryState();
}

class _Edit_EntryState extends State<Edit_Entry> {
  @override
  void initState() {
    print("entry_id" + widget.entry_id.toString());
    print(widget.u_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Entry Details",
          style: TextStyles.mb18,
        )
      ])),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            widget.contact == null
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey,
                                    child: widget.p_image == " "
                                        ? Text(widget.name!
                                            .split('')
                                            .first
                                            .toString())
                                        : Container(
                                            width: 100,
                                            height: 110,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blueGrey,
                                                ),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    widget.p_image,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                          ),
                                  )
                                : CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blueGrey,
                                    child: widget.p_image == " "
                                        ? Text(widget.contact!.displayName
                                            .split('')
                                            .first
                                            .toString())
                                        : Container(
                                            width: 100,
                                            height: 110,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blueGrey,
                                                ),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    widget.p_image,
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(100))),
                                          ),
                                  ),
                            SizedBox(width: 10),
                            widget.contact == null
                                ? Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      widget.name.toString(),
                                      style: TextStyles.mb14,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Text(
                                    widget.contact!.displayName.toString(),
                                    style: TextStyles.mb14,
                                  ),
                          ],
                        ),
                        widget.type == '0'
                            ? Text(
                                '\u{20B9}' + widget.amount.toString(),
                                style: TextStyles.withColor(
                                    TextStyles.mb14, Colors.red),
                              )
                            : Text(
                                '\u{20B9}' + widget.amount.toString(),
                                style: TextStyles.withColor(
                                    TextStyles.mb14, Colors.green),
                              ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                widget.type == '0'
                                    ? nextScreen(
                                        context,
                                        MoneyGaveScreen(
                                            p_image: widget.p_image,
                                            u_id: widget.u_id,
                                            des: widget.des,
                                            mobile_no: widget.mobile_no,
                                            name: widget.name,
                                            amount: widget.amount,
                                            entry_id: widget.entry_id))
                                    : nextScreen(
                                        context,
                                        MoneyGotScreen(
                                          p_image: widget.p_image,
                                          u_id: widget.u_id,
                                          des: widget.des,
                                          mobile_no: widget.mobile_no,
                                          name: widget.name,
                                          amount: widget.amount,
                                          entry_id: widget.entry_id,
                                          token: "",
                                        ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit),
                                  Text(
                                    "Edit Entry",
                                    style: TextStyles.withColor(
                                        TextStyles.mb14, Colors.black),
                                  )
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                print('hii');
                                showAlertDialog();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Delete Entry",
                                    style: TextStyles.withColor(
                                        TextStyles.mb14, Colors.black),
                                  )
                                ],
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showAlertDialog() {
    // set up the button
    Widget okButton = TextButton(
      child: Text("yes"),
      onPressed: () {
        final user = FirebaseFirestore.instance.collection('Entry');
        user
            .doc(widget.entry_id)
            .delete()
            .then((value) => nextScreen(
                context,
                Customertransaction(
                  p_image: widget.p_image == " " ? " " : widget.p_image,
                  name: widget.name,
                  id: widget.u_id,
                )))
            .catchError((error) => print("Failed to update user: $error"));
      },
    );
    Widget cancelButton = TextButton(
      child: Text("no"),
      onPressed: () {
        backScreen(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure want to delete Entry"),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
