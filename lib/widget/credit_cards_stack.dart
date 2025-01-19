import 'package:flutter/material.dart';
import 'package:flutter_finance_app/constant/account_card_constants.dart';
import 'package:flutter_finance_app/util/account_card_utils.dart';

class CreditCardsStack extends StatefulWidget {
  const CreditCardsStack({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.onCardTap,
    this.initialActiveCard = 0,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ValueChanged<int>? onCardTap;
  final int initialActiveCard;

  @override
  State<CreditCardsStack> createState() => _CreditCardsStackState();
}

class _CreditCardsStackState extends State<CreditCardsStack>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> curvedAnimation;
  late final Animation<Offset> throwAnimation;
  late final Tween<Offset> throwAnimationTween;
  late int activeIndex;
  Offset dragOffset = Offset.zero;
  Duration dragDuration = Duration.zero;

  double get scaleDifference => widget.itemCount > 1
      ? (AccountCardConstants.maxCardScale -
              AccountCardConstants.minCardScale) /
          (widget.itemCount - 1)
      : 0;

  Future<void> _handleDismiss() async {
    throwAnimationTween.end = getThrowOffsetFromDragLocation(
      dragOffset,
      AccountCardConstants.minThrowDistance,
    );
    await animationController.forward();
    setState(() {
      activeIndex++;
    });
    animationController.reset();
  }

  void _onPanStart(DragStartDetails details) {
    if (dragDuration > Duration.zero) {
      dragDuration = Duration.zero;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (dragOffset.dx.abs() > AccountCardConstants.dragThreshold.dx ||
        dragOffset.dy.abs() > AccountCardConstants.dragThreshold.dy) {
      _handleDismiss().then((value) {
        setState(() {
          dragOffset = Offset.zero;
        });
      });
    } else {
      dragDuration = AccountCardConstants.dragSnapDuration;
      setState(() {
        dragOffset = Offset.zero;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialActiveCard;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    throwAnimationTween = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(AccountCardConstants.minThrowDistance,
          AccountCardConstants.minThrowDistance),
    );
    throwAnimation = throwAnimationTween.animate(curvedAnimation);
  }

  @override
  void didUpdateWidget(covariant CreditCardsStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialActiveCard != oldWidget.initialActiveCard) {
      setState(() {
        activeIndex = widget.initialActiveCard;
      });
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return const Center(
        child: Text(
          'No cards available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: List.generate(
            widget.itemCount + 1,
            (stackIndexWithPlaceholder) {
              final index = stackIndexWithPlaceholder - 1;
              final modIndex = getModIndexFromActiveIndex(
                index,
                activeIndex,
                widget.itemCount,
              );

              final child = widget.itemBuilder(context, modIndex);

              if (stackIndexWithPlaceholder == 0) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: Transform.scale(
                    scale: AccountCardConstants.minCardScale,
                    alignment: Alignment.topCenter,
                    child: HeroMode(
                      enabled: false,
                      child: child,
                    ),
                  ),
                );
              }

              if (index == widget.itemCount - 1) {
                return AnimatedPositioned(
                  duration: dragDuration,
                  left: dragOffset.dx,
                  bottom: -dragOffset.dy,
                  child: Transform.translate(
                    offset: throwAnimation.value,
                    child: GestureDetector(
                      onPanStart: _onPanStart,
                      onPanUpdate: _onPanUpdate,
                      onPanEnd: _onPanEnd,
                      onTap: dragOffset == Offset.zero
                          ? () => widget.onCardTap?.call(modIndex)
                          : null,
                      behavior: HitTestBehavior.opaque,
                      child: Opacity(
                        opacity: 1 - curvedAnimation.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              }

              final scaleByIndex = AccountCardConstants.minCardScale +
                  ((AccountCardConstants.maxCardScale -
                              AccountCardConstants.minCardScale) /
                          (widget.itemCount - 1)) *
                      index;

              final bottomOffsetByIndex = -AccountCardConstants.cardsOffset *
                  (widget.itemCount - 1 - index);

              return Positioned(
                left: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    bottomOffsetByIndex +
                        AccountCardConstants.cardsOffset *
                            curvedAnimation.value,
                  ),
                  child: Transform.scale(
                    scale:
                        scaleByIndex + scaleDifference * curvedAnimation.value,
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
