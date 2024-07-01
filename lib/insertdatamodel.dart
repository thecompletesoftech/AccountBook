import 'package:account_book/Constant/navigaotors/Navagate_Next.dart';
import 'package:account_book/screens/customertransactions.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Insetdatamodel with ChangeNotifier {
  double? total_amount_gave = 0.0;
  double? total_amount_got = 0.0;
  List data = [];
  List got_data = [];
  double? t_amt = 0;
  var businessname = 'My business';

  insertdata(
      Collector_id,
      name,
      status_collector,
      mobile_no,
      des,
      date,
      deletestatus,
      amount,
      image,
      type,
      d_status,
      p_image,
      address,
      cnxt,
      token) async {
    final users = FirebaseFirestore.instance.collection('customer_record');
    // final document_id =
    //     FirebaseFirestore.instance.collection('customer_record').doc().id;

    users.add({
      'id': "",
      'name': name.toString(),
      'mobile_no': mobile_no.toString(),
      'description': des,
      'date': date,
      'deleted': deletestatus,
      'p_image': p_image,
      "address": address,
      "last_updated_date": date,
      "password": "123456",
      "token": " ",
      "youllgetamount": " "
    }).then((value) {
      upadtedocId(value.id, "customer_record");
      insertentry(Collector_id, name, status_collector, des, amount, date,
          image, type, value.id, d_status, cnxt, mobile_no, p_image, token);
    }).catchError((error) => print("Failed to add user: $error"));
    notifyListeners();
  }

  add_collectors(name, b_name, mobile_no, password, gender, cnxt, token) {
    CollectionReference collector =
        FirebaseFirestore.instance.collection('admin');
    collector.add({
      'name': name,
      'business_name': b_name,
      'mobile_no': mobile_no,
      'password': password,
      'gender': gender,
      'date': DateFormat('yyyy-dd-MM').format(DateTime.now()),
      'role': 'collector',
      'address': " ",
      'p_image': null,
      'token': token
    }).then((value) {
      print("collector added" + value.id);

      // _textMe(number, 'we got money from you $amount from xyz business');
      // backScreen(cnxt);
    }).catchError((error) => print("Failed to add user: $error"));

    notifyListeners();
  }

  insertentry(collector_id, name, status_collector, dese, amount, date, image,
      type, id, d_status, cnxt, number, p_image, token) async {
    CollectionReference entry = FirebaseFirestore.instance.collection('Entry');
    entry.add({
      'collector_id': collector_id,
      'user_id': id,
      'name': name,
      'status': status_collector,
      'description': dese,
      "amount": amount,
      'date': date,
      'deleted_status': d_status,
      'bill_image': image,
      "type": type
    }).then((value) {
      nextScreen(
          cnxt,
          Customertransaction(
            p_image: p_image == ' ' ? " " : p_image,
            name: name,
            id: id,
            token: token,
          ));
      print("inserted entry");
    }).catchError((error) => print("Failed to add user: $error"));

    final users = FirebaseFirestore.instance.collection('customer_record');
    users
        .doc(id)
        .update({
          'last_updated_date':
              DateFormat('yyy-MM-dd HH:mm').format(DateTime.now())
        })
        .then((value) => print("last date updated"))
        .catchError((error) => print("Failed to update user: $error"));

    notifyListeners();
  }

  Future<double> gettotal_amount_gave() async {
    var finaldata_gave = [];
    data.clear();
    double total_amount_gave = 0;

    return await FirebaseFirestore.instance
        .collection('Entry')
        .where('deleted_status', isEqualTo: "0")
        .where('type', isEqualTo: "0")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = value.data();
        finaldata_gave.add(fetchdata);
      }
      print("final gave data" + finaldata_gave.toString());

      for (int i = 0; i < finaldata_gave.length; i++) {
        total_amount_gave =
            double.parse(finaldata_gave[i]['amount']) + total_amount_gave!;

        print('total gave' + total_amount_gave.toString());
      }
      print('total gave' + total_amount_gave.toString());
      return total_amount_gave;
      // notifyListeners();
    });
  }

  Future<double> netamount() async{
    return await gettotal_amount_gave() - await gettotal_amount_got();
  }

  gettotal_amount_gaveByuserid(userid) async {
    var finaldata_gave = [];
    data.clear();
    finaldata_gave.clear();
    double total_amount_gave = 0;

    await FirebaseFirestore.instance
        .collection('Entry')
        .where('user_id', isEqualTo: userid.toString())
        .where('type', isEqualTo: "0")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = value.data();
        finaldata_gave.add(fetchdata);
      }
      print("final gave data" + finaldata_gave.length.toString());

      for (int i = 0; i < finaldata_gave.length; i++) {
        total_amount_gave =
            double.parse(finaldata_gave[i]['amount']) + total_amount_gave;

        print('total gave' + total_amount_gave.toString());
      }
    });
    return total_amount_gave;
  }

  Future<double> gettotal_amount_got() async {
    var finaldata_Got = [];
    got_data.clear();
    finaldata_Got.clear();
    double total_amount_got = 0;

    return await FirebaseFirestore.instance
        .collection('Entry')
        .where('deleted_status', isEqualTo: "0")
        .where('type', isEqualTo: "1")
        .where('status', isEqualTo: "1")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = value.data();

        finaldata_Got.add(fetchdata);
      }
      print("final got data" + finaldata_Got.length.toString());

      for (int i = 0; i < finaldata_Got.length; i++) {
        total_amount_got =
            double.parse(finaldata_Got[i]['amount']) + total_amount_got;
      }
      print('total got' + total_amount_got.toString());
      return total_amount_got;
      // notifyListeners();
    });
  }

  gettotal_amount_gotbyuserid(userid) async {
    var finaldata_Got = [];

    got_data.clear();

    double total_amount_got = 0;

    await FirebaseFirestore.instance
        .collection('Entry')
        .where('user_id', isEqualTo: userid.toString())
        .where('type', isEqualTo: "1")
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        Map<String, dynamic> fetchdata = value.data();

        finaldata_Got.add(fetchdata);
      }
      print("final got data" + finaldata_Got.toString());

      for (int i = 0; i < finaldata_Got.length; i++) {
        total_amount_got =
            double.parse(finaldata_Got[i]['amount']) + total_amount_got;
      }
      print('total got' + total_amount_got.toString());
      notifyListeners();
    });
    return total_amount_got;
  }

  get_total_Userwillget(userid) async {
    double gavetotal = await gettotal_amount_gaveByuserid(userid);
    print("youwillget==" + gavetotal.toString());
    double gottotal = await gettotal_amount_gotbyuserid(userid);
    print("youwillget-----" + gottotal.toString());
    var finalget = gavetotal - gottotal;
    print("finalget******" + finalget.toString());
    return gavetotal - gottotal;
  }

  upadtedeltestatus(id, status, table_name) async {
    final users = FirebaseFirestore.instance.collection(table_name);
    users
        .doc(id)
        .update({'deleted': status})
        .then((value) => print("customer deleted"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  upadtedocId(id, table_name) async {
    final users = FirebaseFirestore.instance.collection(table_name);
    users
        .doc(id)
        .update({'id': id})
        .then((value) => print("doc updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  upadtedeltestatus_entry(id, status, table_name) {
    FirebaseFirestore.instance
        .collection(table_name)
        .where('user_id', isEqualTo: id)
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        final users = FirebaseFirestore.instance.collection(table_name);
        users
            .doc(value.id)
            .update({'deleted_status': status})
            .then((value) =>
                print("all enrty deleted of particular user Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      }
    });

    // FirebaseDatabase.instance
    //     .reference()
    //     .child("$table_name")
    //     .orderByChild("user_id")
    //     .equalTo(id)
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   print(snapshot.toString());
    //   var value = snapshot.value;
    //   if (value != null) {
    //     for (var value in snapshot.value.keys) {
    //       var vlRef = FirebaseDatabase.instance
    //           .reference()
    //           .child("$table_name/${value}");

    //       vlRef.update({"deleted_status": status}).then((_) {});
    //     }
    //   }
    // });
  }

  deleterecord(id) {
    CollectionReference users_delete =
        FirebaseFirestore.instance.collection('customer_record');

    users_delete
        .doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));

    FirebaseFirestore.instance
        .collection('Entry')
        .where('user_id', isEqualTo: id)
        .get()
        .then((QueryDocumentSnapshot) {
      for (var value in QueryDocumentSnapshot.docs) {
        CollectionReference users_delete_all =
            FirebaseFirestore.instance.collection('Entry');
        users_delete_all
            .doc(value.id)
            .delete()
            .then((value) => print("User Deleted"))
            .catchError((error) => print("Failed to delete user: $error"));
      }
    });

    // FirebaseDatabase.instance
    //     .reference()
    //     .child("Entry")
    //     .orderByChild("user_id")
    //     .equalTo(id)
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   print(snapshot.toString());
    //   var value = snapshot.value;
    //   if (value != null) {
    //     for (var value in snapshot.value.keys) {
    //       var vlRef =
    //           FirebaseDatabase.instance.reference().child("Entry/${value}");
    //       vlRef.remove();
    //     }
    //   }
    // });
  }

  get t_amout_gave {
    return total_amount_gave;
  }

  get t_amout_got {
    return total_amount_got;
  }

  get total {
    return total_amount_gave!.toInt() - total_amount_got!.toInt();
  }

  setusinessname(set_business) {
    businessname = set_business;
    notifyListeners();
    return businessname;
  }

  get business_name {
    return business_name;
  }

  clearamount() {
    total_amount_gave = 0;
    total_amount_got = 0;
  }

  updatecustomertable({collectionname, id, jsondata}) {
    try {
      FirebaseFirestore.instance
          .collection(collectionname)
          .doc(id)
          .update(jsondata);
    } catch (e) {
      print(e.toString());
    }
  }
}
