import 'package:flutter_finance_app/page/account_page/account_page_logic.dart';
import 'package:flutter_finance_app/page/account_page/account_page_state.dart';
import 'package:get/get.dart';

class AccountListLogic extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountPageState accountPageState = Get.find<AccountPageLogic>().state;
}
