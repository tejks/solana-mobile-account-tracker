part of 'accounts_cubit.dart';

@immutable
sealed class AccountsState {}

final class AccountsInitial extends AccountsState {}

final class AccountsLoading extends AccountsState {}

final class AccountsLoaded extends AccountsState {
  final List<LocalAccount> accounts;

  AccountsLoaded(this.accounts);
}

final class AccountsError extends AccountsState {
  final String message;

  AccountsError(this.message);
}

final class SingleAccount extends LocalAccount {
  SingleAccount(super.address, super.name);
}

final class AllAccounts extends LocalAccount {
  List<LocalAccount> accounts;

  AllAccounts(this.accounts)
      : super('123231312312312312321313', '123123131231231231231331');
}
