import 'dart:convert';
import 'package:http/http.dart';

class HttpService {
  static String BASE = 'fcm.googleapis.com';
  static String API_SEND = "/fcm/send";
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=AAAACJZZ2aY:APA91bFiTZS6QIPO6b2BUPIslHh5AQL_Nlpcj8RUF1O_GOJ6WjTNuJnMs1hbq96KMXHs1xPOvdN_q07ZoOv2WIonrLdsyREIzQJH1Fo15r5i_4K4okTqR-GnMVYnbF1bbMHjk5KifbEF'
  };

  static Future<String?> POST(String api,Map<String, dynamic> params) async {
    var uri = Uri.https(BASE, API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(params));
    if(response.statusCode == 200 || response.statusCode == 201) {
     print("Notification yuborildi");
     print(response.body);
      return response.body;

    }
    return null;
  }

  static Map<String, dynamic> paramCreate(String fcm_token, String username, String someoneName) {
    Map<String, dynamic> params = {};
    params.addAll({
      'notification': {
        'title': 'My Instagram: $someoneName',
        'body': '$username followed you!'
      },
      'registration_ids': [fcm_token],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return params;
  }
}