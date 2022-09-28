import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class San_pham extends StatefulWidget {
  var namedm;
  var namesp;
  San_pham({Key? key,required this.namedm,required this.namesp}) : super(key: key);

  @override
  State<San_pham> createState() => _San_phamState();
}

class _San_phamState extends State<San_pham> {
  String price="",amout="";
  var sum=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.namedm}/${widget.namesp}/price").onValue.listen((event) {
      setState(() {
        price = event.snapshot.value.toString();
        print(int.parse(price));
      });
    });
    FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.namedm}/${widget.namesp}/amout").onValue.listen((event) {
      setState(() {
        amout = event.snapshot.value.toString();
        print(amout);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Tên sản phẩm :\n ${widget.namesp}",textAlign: TextAlign.center,),
          Text("- Giá : $price"),
          Text("- Số lượng : $amout"),
          Text("------------------"),
          Text("Tổng : ${int.parse(price)*int.parse(amout)}" )
        ],
      ),
    );
  }
}
