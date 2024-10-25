import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this to use rootBundle
import 'node.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

late Box<Node> box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure hive widgets are initialised
  await Hive.initFlutter();   //HIVE SETUP
  Hive.registerAdapter(NodeAdapter()); //registers the Adapter
  box = await Hive.openBox<Node>('decisionMap');

  String csv = 'assets/decision_map.csv'; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);
  //print(fileData);

  List<String> rows = fileData.split("\n");
  for (int i = 0; i < rows.length; i++)  {
    //selects an item from row and places
    String row = rows[i];
    List<String> itemInRow = row.split(",");
    int item1 = int.parse(itemInRow[0]);
    int item2 = int.parse(itemInRow[1]);
    String item3 = itemInRow[2];
    Node node = Node(item1,item2,item3);
    //decisionMap.add(node);
    int key = int.parse(itemInRow[0]);
    box.put(key,node); //The put() method receives two values: a key and a value. When we want to navigate using the ID as the key makes it easier to fetch the data.

  }

  runApp (
    const MaterialApp(
      home: MyFlutterApp(),
    ),
  );
}

class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp>{
  //String dynamic_text = "";
  late int iD;
  late int nextID;
  String description = "";

  @override
  void initState() {
    super.initState();
    //PLACE CODE HERE TO INITALISE SERVER OBJECTS
    //dynamic_text = "WELCOME";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Node? current = box.get(1);
        if(current != null ){
        //Node current = decisionMap.first;
        iD = current.iD;
        nextID = current.nextID;
        description = current.description;}
      });
      //PLACE CODE HERE YOU WANT TO EXECUTE IMMEDIATELY AFTER
      //THE UI IS BUILT
    });
  }

  void buttonHandler() {
    setState(() {
      //dynamic_text  = "button clicked";
      Node? nextNode = box.get(nextID);
        if (nextNode != null){
          iD = nextNode.iD;
          nextID = nextNode.nextID;
          description = nextNode.description;
          //break;
        }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xff9d3ec5),
      body: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Align(
                alignment: const Alignment(0.0, 0.0),
                child: MaterialButton(
                  onPressed: () {buttonHandler() ;},
                  color: const Color(0xff3a21d9),
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  textColor: const Color(0xFF000000),
                  height: 40,
                  minWidth: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(0.0, -0.7),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 34,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

