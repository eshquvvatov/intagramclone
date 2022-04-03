import 'package:flutter/material.dart';
import 'package:intagramclone/service/utils.dart';

Widget InputText(
    {required TextEditingController controller,
      required String text,
      required ErrorFields fields,required showError,
      String? password
    }) {
  return TextField(
    style: const TextStyle(color: Colors.white),
    controller: controller,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        hintStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        hintText: text,
        contentPadding: const EdgeInsets.only(left: 10),
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          color: Colors.white70,
        ),
        errorText: showError?null:Validation.ErrorText(fields: fields, text: controller.text,password: password)    ),
  );
}