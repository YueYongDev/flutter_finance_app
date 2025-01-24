// ignore_for_file: constant_identifier_names

import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:get/get.dart';

enum OperationLogTypeEnum {
  // 添加账户
  ADD_ACCOUNT,
  // 修改账户
  UPDATE_ACCOUNT,
  // 删除账户
  DELETE_ACCOUNT,
  // 添加资产
  ADD_ASSET,
  // 修改资产
  UPDATE_ASSET,
  // 删除资产
  DELETE_ASSET,
  // 转移资产
  TRANSFER_ASSET;

  String get displayName {
    switch (this) {
      case ADD_ACCOUNT:
        return FinanceLocales.l_add_account.tr;
      case UPDATE_ACCOUNT:
        return FinanceLocales.l_update_account.tr;
      case DELETE_ACCOUNT:
        return FinanceLocales.l_delete_account.tr;
      case ADD_ASSET:
        return FinanceLocales.l_add_asset.tr;
      case UPDATE_ASSET:
        return FinanceLocales.l_update_asset.tr;
      case DELETE_ASSET:
        return FinanceLocales.l_delete_asset.tr;
      case TRANSFER_ASSET:
        return FinanceLocales.l_transfer_asset.tr;
    }
  }
}

enum OperationLogKeyEnum {
  // 名称
  NAME,
  // 金额
  AMOUNT;

  String get displayName {
    switch (this) {
      case NAME:
        return FinanceLocales.l_name_label.tr;
      case AMOUNT:
        return FinanceLocales.l_amount_label.tr;
    }
  }
}
