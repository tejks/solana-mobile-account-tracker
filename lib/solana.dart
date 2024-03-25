import 'package:solana/solana.dart';

class Solana {
  final String rpcUrl;
  final String wsUrl;
  final SolanaClient client;

  Solana({required this.rpcUrl, required this.wsUrl})
      : client = SolanaClient(
          rpcUrl: Uri.parse(rpcUrl),
          websocketUrl: Uri.parse(wsUrl),
        );

  getClient() {
    return client;
  }
}
