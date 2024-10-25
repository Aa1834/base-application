import 'package:hive/hive.dart';
part 'node.g.dart';

@HiveType(typeId: 0)
class Node{

  @HiveField(0)
  int iD;

  @HiveField(1)
  int nextID;

  @HiveField(2)
  String description;

  Node(this.iD, this.nextID, this.description);


}