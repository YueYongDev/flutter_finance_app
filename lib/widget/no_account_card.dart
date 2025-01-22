import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/intl/finance_intl_name.dart';
import 'package:flutter_finance_app/page/edit_account_page/edit_account_page.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NoAccountCard extends StatelessWidget {
  const NoAccountCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: ShapeDecoration(
        color: const Color(0xFFF7F6FA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg_ticket_card.png"),
                    fit: BoxFit.fill)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   width: 76,
                //   height: 24,
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   decoration: ShapeDecoration(
                //     color: const Color(0xFF29272E),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(4)),
                //   ),
                //   child: const Text(
                //     '07:00 PM',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 13,
                //       fontFamily: 'Inter',
                //       fontWeight: FontWeight.w500,
                //       height: 0,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  FinanceLocales.home_title_welcome.tr,
                  style: const TextStyle(
                    color: Color(0xFF29272E),
                    fontSize: 24,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                    letterSpacing: -0.96,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
                  style: TextStyle(
                    color: Color(0xFF615F68),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                    letterSpacing: -0.64,
                  ),
                ),
                const SizedBox(height: 8),
                // const Text(
                //   '2 hours 40 minutes',
                //   style: TextStyle(
                //     color: Color(0xFFA7A5AC),
                //     fontSize: 14,
                //     fontFamily: 'Inter',
                //     fontWeight: FontWeight.w400,
                //     height: 0,
                //     letterSpacing: -0.56,
                //   ),
                // ),
                // const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                color: index == 4
                                    ? const Color(0xFFE2DEE9)
                                    : const Color(0xFFF5BE2E),
                              )),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          expand: true,
                          context: context,
                          enableDrag: false,
                          builder: (context) => EditAccountPage(
                            account: null,
                          ),
                        );
                      },
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      borderRadius: BorderRadius.circular(4),
                      child: const Text(
                        'Add Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    // const Icon(
                    //   Icons.bookmark_border,
                    //   color: Colors.black,
                    //   size: 24,
                    // )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
