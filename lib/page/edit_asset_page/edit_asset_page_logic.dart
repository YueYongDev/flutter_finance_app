import 'package:flutter/cupertino.dart';
import 'package:flutter_finance_app/entity/assets.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/repository/database_helper.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AssetController extends GetxController {
  final dbHelper = DatabaseHelper();
  var assets = <Asset>[].obs;
  final nameController = TextEditingController();
  final noteController = TextEditingController();
  final amountController = TextEditingController();
  String selectedAccount = "Select Account";
  String selectedCurrency = "CNY";
  CountSummaryType selectedCountType = CountSummaryType.SummaryAccount;
  String selectedCountTypeString = 'Summart Account';
  IconData selectedCurrencyIcon = CupertinoIcons.money_yen;

  String tag = "None";
  String note = "";
  String countInfo = "Summary Account";

  @override
  void onInit() {
    super.onInit();

    fetchAssets();
  }

  void fetchAssets() async {
    List<Asset> retrievedAssets = await dbHelper
        .getAssets()
        .then((result) => result.map((map) => Asset.fromMap(map)).toList());
    assets.assignAll(retrievedAssets);
  }

  Future<void> addAsset() async {
    var uuid = const Uuid();
    var newAsset = Asset(
      id: uuid.v4(),
      name: nameController.text,
      amount: double.parse(amountController.text),
      currency: selectedCurrency,
      tag: tag,
      note: note,
      accountId: selectedAccount, // Modify to get actual account ID
      countInfo: countInfo,
    );
    await dbHelper.insertAsset(newAsset.toMap());
    fetchAssets();
    Get.back(); // Close the dialog or page
  }
}
