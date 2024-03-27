import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget item;
  final Function()? ontab;
  const CustomButton({super.key, required this.item, required this.ontab});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            padding: MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 19.w, vertical: 1.5.h)),
            backgroundColor: const MaterialStatePropertyAll(Color(0xFFeb5f00))),
        onPressed: ontab,
        child:item );
  }
}
