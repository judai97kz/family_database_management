import 'dart:ffi';
import 'dart:math';

import 'package:family_database_management/View/Danh_Muc_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

final List<String> danh_muc = [];
List<String> check = [];
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
                            FirebaseDatabase.instance.ref("Database/DanhMuc/$_new_cate").set(1);
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
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DM_SP(name: check[index])));
                            },
                            onLongPress: (){
                              setState(() {
                                FirebaseDatabase.instance.ref("Database/DanhMuc/${check[index]}").remove();
                                check.remove(check[index]);
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
