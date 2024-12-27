import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/enum/count_summary_type.dart';
import 'package:flutter_finance_app/navigation_bar.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:flutter_finance_app/widget/accout_select_modal.dart';
import 'package:flutter_finance_app/widget/asset_note_modal.dart';
import 'package:flutter_finance_app/widget/prefix_widget.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';

class EditAssetPage extends StatelessWidget {
  final AssetController controller = Get.put(AssetController());

  final List<String> accounts = [
    'Account 1',
    'Account 2',
    'Account 3',
    'Account 3',
    'Account 3',
    'Account 3',
    'Account 3',
    'Account 3',
    'Account 3',
    // Add more accounts as needed
  ];

  EditAssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Asset Details",
            style: TextStyle(color: CupertinoColors.label, fontSize: 18)),
      ),
      body: GetBuilder<AssetController>(
        builder: (controller) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAccountSection(context),
                _buildAssetDetailsSection(context),
                _buildAdditionalInformationSection(context),
                const SizedBox(height: 16.0),
                _buildAddAssetButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return CupertinoFormSection(
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 0),
          borderRadius: BorderRadius.circular(18),
          color: Colors.white),
      children: [
        CupertinoFormRow(
          padding: const EdgeInsets.all(18),
          prefix: const PrefixWidget(
            icon: CupertinoIcons.rectangle_stack_badge_plus,
            title: 'Account',
            color: CupertinoColors.systemGreen,
          ),
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(controller.selectedAccount),
                const Icon(CupertinoIcons.forward)
              ],
            ),
            onTap: () async {
              dynamic value = await showCupertinoModalBottomSheet(
                expand: true,
                enableDrag: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => AccoutSelectModal(accounts: accounts),
              );
              if (value != null) {
                controller.selectedAccount = value;
                controller.update();
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildAssetDetailsSection(BuildContext context) {
    return CupertinoFormSection(
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 0),
          borderRadius: BorderRadius.circular(18),
          color: Colors.white),
      header: const Text('Assets Details'),
      children: [
        CupertinoFormRow(
          padding: const EdgeInsets.all(18),
          prefix: const PrefixWidget(
            icon: CupertinoIcons.tag,
            title: 'Assets Name',
            color: CupertinoColors.activeBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CupertinoTextField(
                  placeholder: "Asset name",
                  decoration: null,
                  maxLength: 18,
                  textAlign: TextAlign.right,
                  controller: controller.nameController,
                ),
              ),
            ],
          ),
        ),
        CupertinoFormRow(
          padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
          prefix: PrefixWidget(
            icon: controller.selectedCurrencyIcon,
            title: 'Asset Amount',
            color: CupertinoColors.systemRed,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CupertinoTextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  placeholder: "Asset Amount",
                  decoration: null,
                  textAlign: TextAlign.right,
                  maxLength: 10,
                  controller: controller.amountController,
                ),
              ),
              Text(controller.selectedCurrency,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              PullDownButton(
                itemBuilder: (context) {
                  var currencyList = [
                    {'CNY': CupertinoIcons.money_yen},
                    {'HKD': CupertinoIcons.money_dollar},
                    {'USD': CupertinoIcons.money_dollar},
                    {'EUR': CupertinoIcons.money_euro}
                  ];

                  return List.generate(currencyList.length, (i) {
                    var currency = currencyList[i].entries;
                    return PullDownMenuItem(
                      title: currency.first.key,
                      icon: currency.first.value,
                      onTap: () {
                        controller.selectedCurrency =
                            currency.first.key.toString();
                        controller.selectedCurrencyIcon = currency.first.value;
                        controller.update();
                        debugPrint("currency:${currency.first.key}");
                      },
                    );
                  });
                },
                buttonBuilder: (context, showMenu) => buildMenuButton(showMenu,
                    icon: CupertinoIcons.chevron_up_chevron_down),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInformationSection(BuildContext context) {
    return CupertinoFormSection(
      margin: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 0),
          borderRadius: BorderRadius.circular(18),
          color: Colors.white),
      header: const Text('Additional Information'),
      children: [
        CupertinoFormRow(
          padding: const EdgeInsets.all(18),
          prefix: const PrefixWidget(
            icon: CupertinoIcons.tag,
            title: 'Note',
            color: CupertinoColors.activeBlue,
          ),
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    controller.noteController.text.isEmpty
                        ? "None"
                        : controller.noteController.text,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(CupertinoIcons.forward)
              ],
            ),
            onTap: () async {
              dynamic value = await showCupertinoModalBottomSheet(
                expand: true,
                enableDrag: false,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => const AssetNoteModal(),
              );
              if (value != null) {
                controller.update();
              }
            },
          ),
        ),
        CupertinoFormRow(
          padding: const EdgeInsets.only(top: 18, bottom: 18, left: 18),
          prefix: const PrefixWidget(
            icon: CupertinoIcons.number,
            title: 'Count',
            color: CupertinoColors.systemRed,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(controller.selectedCountTypeString,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              PullDownButton(
                itemBuilder: (context) {
                  var currencyList = [
                    {CountSummaryType.SummaryAccount: 'Summart Account'},
                    {
                      CountSummaryType.OnlyCurrentAccount:
                          'Only Current Account'
                    },
                    {CountSummaryType.DoNotCount: 'Do Not Count'},
                  ];

                  return List.generate(currencyList.length, (i) {
                    var summaryType = currencyList[i].entries;
                    return PullDownMenuItem(
                      title: summaryType.first.value,
                      onTap: () {
                        controller.selectedCountType = summaryType.first.key;
                        controller.selectedCountTypeString =
                            summaryType.first.value;
                        controller.update();
                        debugPrint("currency:${summaryType.first.key}");
                      },
                    );
                  });
                },
                buttonBuilder: (context, showMenu) => buildMenuButton(showMenu,
                    icon: CupertinoIcons.chevron_up_chevron_down),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddAssetButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      width: double.infinity,
      child: CupertinoButton(
        color: CupertinoColors.activeBlue,
        child: const Text('Add Asset'),
        onPressed: () async {
          print("Add Asset");
        },
      ),
    );
  }
}
