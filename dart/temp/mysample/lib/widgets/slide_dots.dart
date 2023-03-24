import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  Function func;
  bool isActive;
  int ind;
  SlideDots(this.isActive,this.func,this.ind);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func(ind);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: isActive ? 12 : 8,
        width: isActive ? 12 : 8,
        decoration: BoxDecoration(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }
}
