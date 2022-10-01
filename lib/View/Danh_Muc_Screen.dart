import 'package:family_database_management/View/item_sp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/san_pham.dart';


var sp1 = [];

class DM_SP extends StatefulWidget {
  var name="";
  DM_SP({Key? key,required this.name}) : super(key: key);
  @override
  State<DM_SP> createState() => _DM_SPState();
}

class _DM_SPState extends State<DM_SP> {
  int data1=1,data2=1;
  int check_index=1;
  int check_i=1;
  final ten_sp= TextEditingController();
  final gia_sp = TextEditingController();
  final soluong_sp = TextEditingController();
  String? _name,_price,_amout;

  Widget Custom_Text(TextEditingController? controller,String Label ){
    return TextField(
      controller: controller,
      onChanged: (value){
        setState(() {
          _name = Label=="name"?value:_name;
          _price = Label=="price"?value:_price;
          _amout = Label=="amout"?value:_amout;
        });
      },
      decoration: InputDecoration(
        hintText: Label,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Danh Mục Sản Phẩm"),
          actions: [
            ElevatedButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context)=> AlertDialog(
                        actions: [
                          Custom_Text(ten_sp, "name"),
                          Custom_Text(gia_sp, "price"),
                          Custom_Text(soluong_sp, "amout"),
                          ElevatedButton(onPressed: (){
                            setState(() {
                              FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}").onChildAdded.listen((event) {
                                String the_key = event.snapshot.key.toString().trim();
                                if(_name!.trim()==the_key){
                                  check_i=1;
                                }
                                else{
                                  check_i++;
                                }
                                if(check_i==1){
                                  print("Trùng");
                                }else{
                                  FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}/$_name/price").set(_price);
                                  FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}/$_name/amout").set(_amout);
                                }
                              });
                            });
                            Navigator.pop(context, 'Thêm');
                          }, child: Text("Thêm"))
                        ],
                      )
                  );
                },
                child: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 5.0,bottom: 5.0),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    child: GridView(
                      children: [
                        for(int i=0;i<sp1.length;i++) if(sp1[i].name!=" ") CategoriesItem(namedm: widget.name, category: sp1[i],),
                      ],
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 3/2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 0.1),
                    ),
                  )
                ],
              ),
            ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          setState(() {

            sp1.sort((a,b)=> a.name.compareTo(b.name));
          });
        },),
    );

  }
}
