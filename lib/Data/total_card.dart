import 'package:flutter/material.dart';
import 'package:poc/Data/Asset.dart';
import 'package:poc/structure/stack_type_general.dart';

class TotalCards {
  final List<Widget> _totalCards = [
    StackTypeGeneral(Assets.card_background_one, GlobalKey()),
    StackTypeGeneral(Assets.card_background_two, GlobalKey()),
    StackTypeGeneral(Assets.card_background_third, GlobalKey()),
    StackTypeGeneral(Assets.card_background_one, GlobalKey()),
    StackTypeGeneral(Assets.card_background_third, GlobalKey()),
    StackTypeGeneral(Assets.card_background_two, GlobalKey()),
  ];

  List<Widget> getTotalCards() {
    return _totalCards;
  }
}
