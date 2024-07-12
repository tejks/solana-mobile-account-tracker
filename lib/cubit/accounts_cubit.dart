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

      final List<LocalAccount> accounts = [];
      final localAccountsList = localAccounts
          .toMap()
          .values
          .map((e) => SingleAccount(e.address, e.name))
          .toList();
      accounts.addAll(localAccountsList);

      if (accounts.length > 1) {
        accounts.add(AllAccounts(accounts));
      }

      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }

  void addAccount(LocalAccount account) async {
    emit(AccountsLoading());

    try {
      var localAccounts = await Hive.openBox<LocalAccount>('local_accounts');
      localAccounts.put(account.name, account);

      final List<LocalAccount> accounts = [];
      final localAccountsList = localAccounts
          .toMap()
          .values
          .map((e) => SingleAccount(e.address, e.name))
          .toList();
      accounts.addAll(localAccountsList);

      if (accounts.length > 1) {
        accounts.add(AllAccounts(accounts));
      }

      emit(AccountsLoaded(accounts));
    } catch (e) {
      emit(AccountsError(e.toString()));
    }
  }
}
