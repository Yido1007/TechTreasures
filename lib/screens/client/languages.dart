import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techtreasure/core/localizations.dart';

import '../../bloc/client/client_cubit.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late ClientCubit clientCubit;
  @override
  void initState() {
    super.initState();
    clientCubit = context.read<ClientCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          // language screen title
          title: Text(
            AppLocalizations.of(context).getTranslate("language"),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // prints the current status
              Text(
                  "${AppLocalizations.of(context).getTranslate("language")}: ${clientCubit.state.language}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // to use Turkish
                  InkWell(
                    child: Image.asset(
                      "assets/icons/turkey.png",
                      width: 80,
                    ),
                    onTap: () {
                      clientCubit.state.language == "tr"
                          ? null
                          : (
                              {
                                clientCubit.changeLanguage(language: "tr"),
                              },
                            );
                    },
                  ),
                  // to use English
                  InkWell(
                    child: Image.asset(
                      "assets/icons/usa.png",
                      width: 80,
                    ),
                    onTap: () {
                      clientCubit.state.language == "en"
                          ? null
                          : (
                              {
                                clientCubit.changeLanguage(language: "en"),
                              },
                            );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
