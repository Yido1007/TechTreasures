// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/core/localizations.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

import '../../core/storage.dart';
import '../../models/payment_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentCard> cards = [];
  String cardNo = "";
  TextEditingController cardHolder = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController cardExpYear = TextEditingController();
  TextEditingController cardExpMonth = TextEditingController();
  TextEditingController cardTitle = TextEditingController();
  bool remember = false;
  String type = "";
  loadCards() async {
    final storage = Storage();
    var cards = await storage.loadCards();
    setState(() {
      this.cards = cards;
    });
  }

  saveCard() async {
    final PaymentCard newCard = PaymentCard(
      title: cardTitle.text,
      cardHolder: cardHolder.text,
      cardNo: cardNo,
      cvv: cvv.text,
      expMonth: int.parse(cardExpMonth.text),
      expYear: int.parse(cardExpYear.text),
    );

    List<PaymentCard> newCardList = [];

    newCardList.addAll(cards);

    newCardList.add(newCard);

    if (remember) {
      final storage = Storage();
      await storage.saveCards(newCardList);
    }

    setState(() {
      cards = newCardList;
    });

    context.pop();

    setState(() {
      remember = false;
      cardNo = "";
      cardHolder.text = "";
      cardExpMonth.text = "";
      cardExpYear.text = "";
      cvv.text = "";
    });
  }

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  showAddCard() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              elevation: 0,
              title: Text(
                AppLocalizations.of(context).getTranslate("add_card"),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).getTranslate("card_title"),
                      labelText: AppLocalizations.of(context).getTranslate("card_title"),
                      alignLabelWithHint: true,
                    ),
                    controller: cardTitle,
                  ),
                  const Gap(10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).getTranslate("name_surname"),
                      labelText: AppLocalizations.of(context).getTranslate("name_surname"),
                    ),
                    controller: cardHolder,
                  ),
                  const Gap(10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).getTranslate("card_no"),
                      labelText: AppLocalizations.of(context).getTranslate("card_no"),
                    ),
                    onChanged: (value) {
                      setState(() {
                        cardNo = value;
                      });
                      if (value.startsWith("4")) {
                        setState(() {
                          type = "visa";
                        });
                      } else if (value.startsWith("5")) {
                        setState(() {
                          type = "master";
                        });
                      } else if (value.startsWith("9") ||
                          value.startsWith("6") ||
                          value.startsWith("3")) {
                        setState(() {
                          type = "troy";
                        });
                      } else {
                        type = "";
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    maxLength: 16,
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Cvv",
                            labelText: "Cvv",
                          ),
                          obscureText: true,
                          controller: cvv,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 3,
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).getTranslate("card_month"),
                            labelText: AppLocalizations.of(context).getTranslate("card_month"),
                          ),
                          controller: cardExpMonth,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).getTranslate("card_year"),
                            labelText: AppLocalizations.of(context).getTranslate("card_year"),
                          ),
                          controller: cardExpYear,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          maxLength: 2,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  SwitchListTile(
                    title: const Text("Karti Kaydet"),
                    value: remember,
                    onChanged: (value) => setState(
                      () {
                        remember = value;
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                if (type.isNotEmpty)
                  Image.asset(
                    "assets/icons/${type}_card.png",
                    height: 40,
                  ),
                OutlinedButton(
                  onPressed: saveCard,
                  child: Text(AppLocalizations.of(context).getTranslate("card_confirm")),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getTranslate("payment")),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Tooltip(
              message: AppLocalizations.of(context).getTranslate("add_card"),
              child: IconButton(
                onPressed: showAddCard,
                icon: const Icon(Icons.credit_card_outlined),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Tooltip(
              message: AppLocalizations.of(context).getTranslate("card_confirm"),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        AppLocalizations.of(context).getTranslate("thanks"),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).getTranslate("successfully"),
                          ),
                          const Gap(15),
                          Center(
                            child: ElevatedButton(
                                onPressed: () {
                                  GoRouter.of(context).go("/home");
                                },
                                child: Text(AppLocalizations.of(context).getTranslate("go_back"))),
                          )
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_box_outlined),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: cards.isEmpty
              ? Center(
                  child: Text(
                  AppLocalizations.of(context).getTranslate("no_card"),
                ))
              : ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) => AspectRatio(
                    aspectRatio: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            right: 10,
                            child: cards[index].cardNo.startsWith("4")
                                ? Image.asset("assets/icons/visa_card.png", height: 60)
                                : cards[index].cardNo.startsWith("5")
                                    ? Image.asset("assets/icons/master_card.png", height: 60)
                                    : const SizedBox(),
                          ),
                          Positioned(
                              top: 20,
                              left: 20,
                              child: Text(
                                cards[index].title,
                                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                              )),
                          Positioned(
                              left: 20,
                              top: 50,
                              child: Text(
                                cards[index].cardNo,
                                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                              )),
                          Positioned(
                              left: 20,
                              bottom: 20,
                              child: Text(
                                cards[index].cardHolder,
                                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                              )),
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: Text(
                              "${cards[index].expMonth}/${cards[index].expYear}",
                              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
