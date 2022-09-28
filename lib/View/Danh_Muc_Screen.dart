import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'San_pham.dart';

final List<String> san_pham = [];
List<String> check_sp = [];

class DM_SP extends StatefulWidget {
  var name="";
  DM_SP({Key? key,required this.name}) : super(key: key);
  
  @override
  State<DM_SP> createState() => _DM_SPState();
}

class _DM_SPState extends State<DM_SP> {
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    san_pham.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}");
    ref.onChildAdded.listen((event) {
      setState(() {
        print("fkjhskghkj ${widget.name}");
        san_pham.add(event.snapshot.key.toString());
        print(event.snapshot.key.toString());
        check_sp = san_pham.toSet().toList();

      });
    });
  }

  TextEditingController? new_cate = TextEditingController();
  final ten_sp= TextEditingController();
  final gia_sp = TextEditingController();
  final soluong_sp = TextEditingController();
  String? _new_sp;
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
                             FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}/$_name/price").set(_price);
                             FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}/$_name/amout").set(_amout);
                             Navigator.of(context).pop();
                           });
                          }, child: Text("Thêm"))
                        ],
                      )
                  );
                },
                child: Icon(Icons.add))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(

                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: check_sp.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 4/3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemBuilder: (context,index){
                        return Container(
                            child: Card(
                              color: Colors.yellow,
                              child: ListTile(
                                title: San_pham(namedm: widget.name, namesp: check_sp[index]),
                                onTap: (){
                                  print("Danh muc ${check_sp[index]}");
                                },
                                onLongPress: (){
                                  setState(() {
                                    FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}/${check_sp[index]}").remove();
                                    check_sp.remove(check_sp[index]);
                                    if(check_sp.length==0){
                                      FirebaseDatabase.instance.ref("Database/DanhMuc/${widget.name}").set(1);
                                    }
                                  });
                                },
                              ),
                            )
                        );
                      }
                  ),
                )
              ],
            ),
          ),
        )
    );

  }
}
