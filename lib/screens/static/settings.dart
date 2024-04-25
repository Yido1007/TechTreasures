import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/core/localizations.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

import '../../bloc/client/client_cubit.dart';
import '../../widgets/settingsitem.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          title: Text(
            AppLocalizations.of(context).getTranslate("settings"),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Gap(20),
                    SettingsItem(
                      icon: Icons.person_outline,
                      text:
                          AppLocalizations.of(context).getTranslate("account"),
                      onTap: () => GoRouter.of(context).push("/profile"),
                    ),
                    SettingsItem(
                      icon: Icons.notifications_outlined,
                      text: AppLocalizations.of(context)
                          .getTranslate("notifications"),
                      onTap: () => GoRouter.of(context).push("/notification"),
                    ),
                    SettingsItem(
                      icon: Icons.language_outlined,
                      text:
                          AppLocalizations.of(context).getTranslate("language"),
                      onTap: () => GoRouter.of(context).push("/language"),
                    ),
                    SwitchListTile(
                      value: clientCubit.state.darkMode,
                      onChanged: (value) {
                        clientCubit.changeDarkMode(darkMode: value);
                      },
                      secondary: clientCubit.state.darkMode
                          ? const Icon(Icons.sunny)
                          : const Icon(Icons.nightlight),
                      title: Text(AppLocalizations.of(context)
                          .getTranslate("dark_mode")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomMenu(),
      );
    });
  }
}
