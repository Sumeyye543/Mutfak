import "package:flutter/material.dart";
import 'package:mutfak/pages/home.dart';
import 'package:mutfak/view/list_food.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mutfak/model/yemek.dart';
import 'package:mutfak/service/db_utils.dart';

DbUtils utils = DbUtils();

class Data extends StatefulWidget {
  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  TextEditingController yemekIDController = TextEditingController();
  TextEditingController yemekAdController = TextEditingController();
  TextEditingController yemektarihiController = TextEditingController();

  Future<Database> database;

  List<Food> yemekList = [];

  _onPressedUpdate() async {
    final yemek = Food(
      id: int.parse(yemekIDController.text),
      name: yemekAdController.text,
      date: int.parse(yemektarihiController.text),
    );
    utils.updateFood(yemek);
    yemekList = await utils.foods();
    //print(dogList);
    getData();
  }

  _onPressedAdd() async {
    final yemek = Food(
      id: int.parse(yemekIDController.text),
      name: yemekAdController.text,
      date: int.parse(yemektarihiController.text),
    );
    utils.insertFood(yemek);
    yemekList = await utils.foods();
    getData();
  }

  _deleteFoodTable() {
    utils.deleteTable();
    yemekList = [];
    getData();
  }

  void getData() async {
    await utils.foods().then((result) => {
          setState(() {
            yemekList = result;
          })
        });
    print(yemekList);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mutfağım',
      home: Scaffold(
        appBar: AppBar(title: Text('Mutfağım')),
        backgroundColor: Colors.red,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: yemekIDController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: 'Yemek ID'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: yemekAdController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Yaptığım Yemeğin İsmi'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: yemektarihiController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Yemeği Yaptığım Tarih'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedAdd, child: Text("Yemek Ekle")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _onPressedUpdate,
                    child: Text("Yemek Güncelleme")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: _deleteFoodTable, child: Text("Yemek Silme")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ListFoods()),
                      );
                    },
                    child: Text("Yemeklerin Listesi")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () {
                      getData();
                    },
                    child: Text("Listeyi Yenile")),
              ),
              Text(yemekList.length.toString()),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: yemekList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(yemekList[index].name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
