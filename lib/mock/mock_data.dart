import 'package:flutter_finance_app/enum/account_card_enums.dart';
import 'package:flutter_finance_app/model/data.dart';

const mockAccountCards = [
  AccountCardData(
    id: "0",
    name: 'Central Bank',
    type: CreditCardType.visa,
  ),
  AccountCardData(
    id: "1",
    name: 'Bank of Commerce',
    style: AccountCardStyle.secondary,
    type: CreditCardType.masterCard,
  ),
  AccountCardData(
    id: "2",
    name: 'Central Bank',
    style: AccountCardStyle.accent,
    type: CreditCardType.visa,
  ),
  AccountCardData(
    id: "3",
    name: 'Central Bank',
    style: AccountCardStyle.onBlack,
    type: CreditCardType.masterCard,
  ),
  AccountCardData(
    id: "4",
    name: 'Bank of Commerce',
    style: AccountCardStyle.onWhite,
    type: CreditCardType.visa,
  ),
];
