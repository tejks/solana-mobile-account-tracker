import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:solana_mobile_account_tracker/models/local_account.dart';

part 'accounts_state.dart';

class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit() : super(AccountsInitial());

  void loadAccounts() async {
    emit(AccountsLoading());

    try {
      var localAccounts = await Hive.openBox<LocalAccount>('local_accounts');

      await localAccounts.put(
        "HYe3FzPcyjaJ6G1E2UydSoP7VEkQkLTL33hcpKbK51Q4",
        SingleAccount(
          "HYe3FzPcyjaJ6G1E2UydSoP7VEkQkLTL33hcpKbK51Q4",
          "Wallet 1",
        ),
      );

      await localAccounts.put(
        "E9UpkDwtNMz2cauZ7DEggvb2cTs7GsJXKrcq4MiTZeeY",
        SingleAccount(
          "E9UpkDwtNMz2cauZ7DEggvb2cTs7GsJXKrcq4MiTZeeY",
          "Wallet 2",
        ),
      );

      final accounts = localAccounts.toMap().values.toList();
      accounts.add(AllAccounts(accounts));

      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }

  void addAccount(LocalAccount account) async {
    emit(AccountsLoading());

    try {
      var localAccounts = await Hive.openBox<LocalAccount>('local_accounts');
      localAccounts.put(account.address, account);

      final accounts = localAccounts.toMap().values.toList();

      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }
}
