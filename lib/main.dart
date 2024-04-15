import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solana_mobile_account_tracker/cubit/accounts_cubit.dart';
import 'package:solana_mobile_account_tracker/cubit/tokens_cubit.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';
import 'package:solana_mobile_account_tracker/screens/splash_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(LocalAccountAdapter());
  var localAccounts = await Hive.openBox<LocalAccount>('local_accounts');
  await localAccounts.deleteAll(localAccounts.keys);

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
        theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
        home: const SplashScreen(),
      ),
    );
  }
}
