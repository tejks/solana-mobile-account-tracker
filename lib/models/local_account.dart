import 'package:hive/hive.dart';

part 'local_account.g.dart';

@HiveType(typeId: 0)
class LocalAccount extends HiveObject {
  @HiveField(0)
  final String address;

  @HiveField(1)
  final String name;

  LocalAccount(this.address, this.name);
}
