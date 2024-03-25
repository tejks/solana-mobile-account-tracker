String shortPubkey(String pubkey) {
  return "${pubkey.substring(0, 4)}...${pubkey.substring(pubkey.length - 4)}";
}
