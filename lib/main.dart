import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/screens/home_screen.dart';
import 'package:solana_mobile_account_tracker/screens/splash_screen.dart';

import 'screens/start_add_account_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(LocalAccountAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AccountsCubit>(
          create: (context) => AccountsCubit(),
        ),
        BlocProvider<TokensCubit>(
          create: (context) => TokensCubit(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark(),
          home: const SplashScreen(),
          routes: Map<String, WidgetBuilder>.from({
            '/home': (context) => const HomeScreen(),
            '/start-add-account': (context) => const StartAddAccountScreen(),
          })),
    );
  }
}
