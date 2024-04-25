// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../bloc/client/client_cubit.dart';
import '../../core/localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String locationResult = "";
  String notificationResult = "";
  controlPer() async {
    var status = await Permission.location.status;
    switch (status) {
      case (PermissionStatus.granted):
        setState(() {
          locationResult = "Yetkilendirilmiş";
        });
        break;
      case (PermissionStatus.denied):
        setState(() {
          locationResult = "Engellendi";
        });
        break;
      case (PermissionStatus.restricted):
        setState(() {
          locationResult = "Kısıtlanmış";
        });
        break;
      case PermissionStatus.limited:
        setState(() {
          locationResult = "Sınırlı";
        });
        break;
      case PermissionStatus.permanentlyDenied:
        setState(() {
          locationResult = "Tamamen Reddedildi";
        });
        break;
      case PermissionStatus.provisional:
        setState(() {
          locationResult = "Geçiçi";
        });
        break;
    }
    await Permission.notification.onDeniedCallback(() {
      setState(() {
        locationResult = "Reddedildi";
      });
      // Your code
    }).onGrantedCallback(() {
      setState(() {
        notificationResult = "Yetkilendirildi";
      });
      // Your code
    }).onPermanentlyDeniedCallback(() {
      setState(() {
        notificationResult = "Tamamen Reddedildi";
      });
      // Your code
    }).onRestrictedCallback(() {
      setState(() {
        locationResult = "Kısıtlanmış";
      });
      // Your code
    }).onLimitedCallback(() {
      setState(() {
        locationResult = "Sınırlı";
      });
      // Your code
    }).onProvisionalCallback(() {
      // Your code
      setState(() {
        locationResult = "Geçiçi";
      });
    }).request();
  }

  late ClientCubit clientCubit;
  @override
  void initState() {
    super.initState();
    clientCubit = context.read<ClientCubit>();
    controlPer();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).getTranslate("notifications"),
          ),
          centerTitle: true,
        ),
        body: SizedBox.expand(
          child: ListView(
            children: [
              ExpansionTile(
                title: Text(
                  AppLocalizations.of(context)
                      .getTranslate("location_permissions"),
                ),
                children: [
                  const Gap(15),
                  Text(locationResult),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final status = await Permission.location.request();
                      },
                      child: Text(AppLocalizations.of(context)
                          .getTranslate("give_permission")),
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  AppLocalizations.of(context)
                      .getTranslate("notification_permissions"),
                ),
                children: [
                  const Gap(15),
                  Text(notificationResult),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final status = await Permission.notification.request();
                      },
                      child: Text(
                        AppLocalizations.of(context)
                            .getTranslate("give_permission"),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
