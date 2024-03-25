part of 'solana_client_cubit.dart';

@immutable
sealed class SolanaClientState {}

final class SolanaClientInitial extends SolanaClientState {}

final class SolanaClientLoading extends SolanaClientState {}

final class SolanaClientLoaded extends SolanaClientState {
  final SolanaClient client;

  SolanaClientLoaded(this.client);
}

final class SolanaClientError extends SolanaClientState {
  final String message;

  SolanaClientError(this.message);
}
