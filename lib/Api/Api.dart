import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

var dio = new Dio();

class Api {
  Future<Map<String, dynamic>> apicall_post(apiname, params, context) async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("url=" + apiname);
        print("send data to server=" + jsonEncode(params));

        var response = await dio.post(
          apiname,
          data: params,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAAisltrJU:APA91bFbJjKTcjgbDGdE3z182e5zagjkSgPf37dVDAyUUF7FmUNok-TzpDWqPZHIgxapTT78t28TU8VS7tQjE-qepXBUco3rz-fHVrooJxnzPgrSnu4Vo75Ty_NpFrhoCl_Rywh-uThO"
            },
          ),
        );

        return response.data;
      } else {
        final snackBar = SnackBar(
          content: const Text('Check Your Internet ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print("error=" + err.toString());
    }
    return {"status": "n", "message": "Registered failed", "data": {}};
  }

  Future<Map<String, dynamic>> apicall_get(apiname, context) async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("url=" + apiname);
        var response = await dio.get(apiname);
        print(response.data);
        return response.data;
      } else {
        final snackBar = SnackBar(
          content: const Text('Check Your Internet ! '),
          action: SnackBarAction(
            label: 'ok',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      print("error=" + err.toString());
    }
    return {"status": "n", "message": "Registered failed", "data": {}};
  }
}
