import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:solana/solana.dart';

part 'solana_client_state.dart';

class SolanaClientCubit extends Cubit<SolanaClientState> {
  SolanaClientCubit() : super(SolanaClientInitial());

  void connect() async {
    emit(SolanaClientLoading());

    try {
      SolanaClient client = SolanaClient(
        rpcUrl: Uri.parse(''),
        websocketUrl: Uri.parse(''),
      );

      emit(SolanaClientLoaded(client));
    } catch (e) {
      emit(SolanaClientError(e.toString()));
    }
  }
}
