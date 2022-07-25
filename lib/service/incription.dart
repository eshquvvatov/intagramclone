
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypton/crypton.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';
class Symmetric{


  /// bu asosiy key encription qilishda ham decrypt qilishda ham
  static String keystr ="qwertyuiopasdfgh";

  ///kelgan date ni encription qiladigan funcksiya
  static encrypt(date){
    final key = Key.fromUtf8(keystr);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(date,iv:iv).base64;
  }
  
  static decrypt(date){
    final key = Key.fromUtf8(keystr);
    final iv =IV.fromLength(16);
    final encrypter =Encrypter(AES(key));
    return encrypter.decrypt64(date,iv: iv);
  }





}

// class Assemetric{
//    static Future<RSAPublicKey?> _publicKey()async{
//      var key=await parseKeyFromFile<RSAPublicKey>("D:Flutter_Projects");
//      return key;
//    }
//    static  Future<RSAPrivateKey> _privateKey()async{
//      var key=await parseKeyFromFile<RSAPrivateKey>('D:Flutter_Projects');
//      return key;
//    }
//
//    static  encrypt(String text)async{
//     final  encrypter = Encrypter(RSA(publicKey:await _publicKey(), privateKey:await _privateKey()));
//      return  encrypter.encrypt(text);
//    }
//
//    static  decrypt(Encrypted text)async{
//      final  encrypter = Encrypter(RSA(publicKey:await _publicKey(), privateKey:await _privateKey()));
//      return  encrypter.decrypt(text);
//    }
//
//
// }

class Assemetric2{
 static RSAKeypair rsaKeypair = RSAKeypair.fromRandom();

 static encrypt(String message){
  var signature = rsaKeypair.publicKey.encrypt(message);
  var signature1 = utf8.encode(message);
 return signature;

}
static decrypt(String message){
  String verified = rsaKeypair.privateKey.decrypt(message);
   return verified;
}

}

