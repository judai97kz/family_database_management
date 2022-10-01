import 'dart:ffi';
import 'dart:math';

import 'package:family_database_management/View/Danh_Muc_Screen.dart';
import 'package:family_database_management/models/san_pham.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Danh_Muc_Screen.dart' as dm;

final List<String> danh_muc = [];
List<String> check = [];
final a = [];

class Danh_Muc_Screen extends StatefulWidget {
  const Danh_Muc_Screen({Key? key}) : super(key: key);

  @override
  State<Danh_Muc_Screen> createState() => _Danh_Muc_ScreenState();
}

class _Danh_Muc_ScreenState extends State<Danh_Muc_Screen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    danh_muc.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref("Database/DanhMuc");
    ref.onChildAdded.listen((event) {
     setState(() {
       danh_muc.add(event.snapshot.key.toString());
       check = danh_muc.toSet().toList();
       print(danh_muc);
     });
    });
  }

  void get_data(int index){
    DatabaseReference ref = FirebaseDatabase.instance.ref("Database/DanhMuc/${check[index]}");
    ref.onChildAdded.listen((event) {
      String key = event.snapshot.key.toString();
      setState(() {
        ref.child(key).child("price").onValue.listen((dt1) {
          int data1 = int.parse(dt1.snapshot.value.toString());
          print("data1 : $data1");
          ref.child(key).child("amout").onValue.listen((dt2) {
            int data2 = int.parse(dt2.snapshot.value.toString());
            print("data2 : $data2");
            dm.sp1.add(new sanpham(name: key, price: data1, amout: data2));
          });
        });
      });
    });
  }

  TextEditingController? new_cate = TextEditingController();
  String? _new_cate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Danh Mục Sản Phẩm"),
          actions: [
            ElevatedButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context)=> AlertDialog(
                        actions: [
                          TextField(
                            controller: new_cate,
                            onChanged: (value){
                              setState(() {
                                _new_cate = value;
                              });
                            },
                          ),
                          ElevatedButton(onPressed: (){
                            FirebaseDatabase.instance.ref("Database/DanhMuc/$_new_cate").child(" /price").set(1);
                            FirebaseDatabase.instance.ref("Database/DanhMuc/$_new_cate").child(" /amout").set(1);
                            Navigator.of(context).pop();
                          }, child: Text("Thêm"))
                        ],
                      )
                  );
                },
                child: Icon(Icons.add))
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: check.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                        childAspectRatio: 7/2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (context,index){
                      return SizedBox(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                              side: BorderSide(
                                  width: 1
                              )
                          ),
                          color: Colors.yellow,
                          child: ListTile(
                            title: Center(child: Text(check[index]),),
                            onTap: (){
                              print(check[index]);
                              dm.sp1.clear();
                              setState(() {
                                get_data(index);
                              });

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DM_SP(name: check[index])));
                            },
                            onLongPress: (){
                              setState(() {
                                String key_value=check[index];
                                FirebaseDatabase.instance.ref("Database/DanhMuc/$key_value").remove();
                                check.remove(key_value);
                                danh_muc.remove(key_value);
                                dm.sp1.clear();
                              });
                            },
                          ),
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        )
    );
  }
}
