import 'package:family_database_management/View/Danh_muc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('you have an error! ${snapshot.error.toString()}');
            return Text('Something went wrong');
          } else if (snapshot.hasData) {
            return MyHomePage();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? usercontrol = TextEditingController();
  TextEditingController? passcontrol = TextEditingController();
  String? _username,_password;
  Widget Custom_TextField(TextEditingController control,String label){
    return TextField(
        controller: control,
        onChanged: (value){
         setState(() {
           _username = label=="user"?value:_username;
           _password = label=="pass"?value:_password;
         });
        },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý hàng hóa"),backgroundColor: Colors.white),
      body: Column(
        children: [
          Custom_TextField(usercontrol!,"user"),
          Custom_TextField(passcontrol!,"pass"),
          ElevatedButton(onPressed: (){
            print(_username);
            Login_action();
          }, child: Text("Login"))
        ],
      ),
    );
  }

  void Login_action(){
    DatabaseReference checkUrl = FirebaseDatabase.instance.ref("Database/User");
    checkUrl.onChildAdded.listen((event) {
      print('aaaa   ${event.snapshot.key}');
      if(event.snapshot.key==_username){
        checkUrl.child("$_username").child("password").onValue.listen((newev) {
          String Checkpass = newev.snapshot.value.toString();
          if(Checkpass==_password){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Danh_Muc_Screen()));
          }
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not")));
      }
    });
  }
}
