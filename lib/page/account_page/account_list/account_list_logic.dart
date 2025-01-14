import 'package:flutter_finance_app/entity/account.dart';
import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:get/get.dart';

class AccountListLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountPageState accountPageState = Get.find<AccountPageLogic>().state;

  List<Account> accounts = [];

  @override
  void onInit() async {
    super.onInit();
    accounts = accountPageState.accounts;
    print(accountPageState.accounts);
    update();
  }
}
