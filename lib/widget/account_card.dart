import 'package:flutter/material.dart';
import 'package:flutter_finance_app/enum/font_family.dart';
import 'package:flutter_finance_app/model/data.dart';
import 'package:flutter_finance_app/constant/account_card_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double creditCardAspectRatio = 1.56;

class AccountCard extends StatelessWidget {
  const AccountCard({
    required this.data,
    super.key,
    this.width,
    this.isFront = false,
  }) : height = width != null ? width / creditCardAspectRatio : null;

  final AccountCardData data;
  final bool isFront;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: data.style.color,
        borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.5),
            blurRadius: 15,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(
            'assets/images/${isFront ? data.style.frontBg : data.style.backBg}',
          ),
          fit: BoxFit.cover,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: isFront ? _CreditCardFront(data) : _CreditCardBack(data),
    );
  }
}

class _CreditCardFront extends StatelessWidget {
  const _CreditCardFront(this.data);

  final AccountCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  data.name,
                  style: TextStyle(
                    color: data.style.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Image(
                  image: AssetImage('assets/icons/bank/${data.type.name}.png'),
                  width: 45,
                  fit: BoxFit.cover,
                  color: data.style.textColor,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(color: data.style.textColor),
                    ),
                    Text(
                      data.balance,
                      style: TextStyle(
                        color: data.style.textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      data.id,
                      style:
                          TextStyle(color: data.style.textColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Exp',
                    style: TextStyle(color: data.style.textColor, fontSize: 16),
                  ),
                  Text(
                    '01/28',
                    style: TextStyle(color: data.style.textColor, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreditCardBack extends StatelessWidget {
  const _CreditCardBack(this.data);

  final AccountCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: AssetImage('assets/icons/${data.type.name}.png'),
                width: 45,
                fit: BoxFit.cover,
                color: data.style.textColor,
              ),
              const SizedBox(width: 8),
              Text(
                data.name,
                style: TextStyle(
                  color: data.style.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.balance,
                  style: TextStyle(
                      color: data.style.textColor,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.oswaldSemiBold.name
                  ),
                ),
                Text(
                  data.number,
                  style: TextStyle(
                    color: data.style.textColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.oswaldSemiBold.name
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
