import 'package:family_database_management/models/san_pham.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Danh_Muc_Screen.dart' as dm;

class CategoriesItem extends StatefulWidget {
  sanpham category;
  String namedm;
  CategoriesItem({required this.namedm,required this.category});

  @override
  State<CategoriesItem> createState() => _CategoriesItemState();
}

class _CategoriesItemState extends State<CategoriesItem> {
  String _eprice="",_eamout="";
  final editpricectrl = new TextEditingController();
  final editamoutctrl = new TextEditingController();

  Widget Custom_Text(TextEditingController? controller,String Label ){
    return TextField(
      controller: controller,
      onChanged: (a){
        setState(() {
          _eamout= Label=="amout"?a:_eamout;
          _eprice= Label=="price"?a:_eprice;
        });
      },
      decoration: InputDecoration(
        hintText: Label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: InkWell(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tên sản phẩm:\n ${this.widget.category.name}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white,),textAlign: TextAlign.center,),
              Text("Đơn giá: ${this.widget.category.price}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
              Text("Số lượng: ${this.widget.category.amout}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
              Text("------------------",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
              Text("Tiền vốn: ${(this.widget.category.amout)*(this.widget.category.price)}",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white)),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.deepOrange,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 1)
          ),
        ),
        splashColor: Colors.deepPurple,
        onTap: (){
          showDialog(
              context: context,
              builder: (context)=> AlertDialog(
                title: Text("Sửa thông tin đơn giá/số lượng của sản phẩm"),
                content: Text("Tên sản phẩm : ${this.widget.category.name}\nĐơn giá: ${this.widget.category.price} - Số lượng: ${this.widget.category.amout}"),
                actions: [
                  Text("Đơn giá : "),
                  Custom_Text(editpricectrl, "price"),
                  Text("Số lượng : "),
                  Custom_Text(editamoutctrl, "amout"),
                  ElevatedButton(onPressed: (){
                    setState(() {
                       if(_eprice!="" && _eamout!=""){
                         widget.category.price = int.parse(_eprice);
                         widget.category.amout = int.parse(_eamout);
                         FirebaseDatabase.instance.ref("Database/DanhMuc/${this.widget.namedm}/${this.widget.category.name}/price").set(_eprice);
                         FirebaseDatabase.instance.ref("Database/DanhMuc/${this.widget.namedm}/${this.widget.category.name}/amout").set(_eamout);
                         Navigator.of(context).pop();
                         editamoutctrl.clear();
                         editpricectrl.clear();
                       }
                    });
                  }, child: Text("Sửa")),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }, child: Text("Hủy"))
                ],
              )
          );
        },
        onLongPress: (){
          showDialog(
              context: context,
              builder: (context)=> AlertDialog(
                title: Text("Cảnh Báo!"),
                content: Text("Bạn có muốn xóa sản phẩm này?\nSản phẩm này sẽ không thể hồi phục sau khi xóa!"),
                actions: [
                  ElevatedButton(onPressed: (){
                    setState(() {
                      FirebaseDatabase.instance.ref("Database/DanhMuc/${this.widget.namedm}/${this.widget.category.name}").remove();
                      dm.sp1.remove(widget.category);
                      Navigator.of(context).pop();
                    });
                  }, child: Text("Xóa")),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  }, child: Text("Hủy"))
                ],
              )
          );
        },
      ),
    );;
  }
}



