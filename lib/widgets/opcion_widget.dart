import 'package:flutter/material.dart';

class OpcionWidget extends StatefulWidget {
  String texto;
  int estado;
  bool isCorrect;
  Color textColor;
  Color bgColor;
  OpcionWidget(
      {this.texto,
      this.estado = 1,
      this.isCorrect = false,
      this.textColor = Colors.white,
      this.bgColor = Colors.transparent});

  @override
  _OpcionWidgetState createState() => _OpcionWidgetState();
}

class _OpcionWidgetState extends State<OpcionWidget> {
  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsets.only(bottom: alto * 0.02),
        decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              width: 3.0,
              color: Color(0xFF21486A),
            )),
        child: ListTile(
          title: Text(
            widget.texto,
            style: TextStyle(color: widget.textColor, fontSize: alto * 0.03),
          ),
          trailing: getIcon(widget.estado),
        ),
      ),
    );
  }

  getIcon(int estado) {
    if (estado == 1) {
      return CircleAvatar(
        backgroundColor: Color(0xFF21486A),
        radius: 15.0,
        child: CircleAvatar(
          backgroundColor: Color(0xFF252C4A),
          radius: 12.0,
        ),
      );
    }
    if (estado == 2) {
      return CircleAvatar(
        backgroundColor: Colors.green,
        radius: 15.0,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 20.0,
        ),
      );
    }
    if (estado == 3) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: 15.0,
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 20.0,
        ),
      );
    }
  }
}
