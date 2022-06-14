# 概要
Flutter学習のために作成した簡易的な名刺交換アプリケーションです。
ユーザは自身のプロフィールを登録することができ、QRコードの読取りを介してプロフィールをユーザ間で交換することができます。
また、名刺交換という固い印象のあるやり取りを楽しくするために、プロフィールにキャラクターをランダムで割り当てることで、カード収集的なゲーム要素を取り入れました。

# 使用ライブラリ等
- 状態管理：[provider](https://pub.dev/packages/provider)
- 暗号化対応SQLite：[sqflite_sqlcipher](https://pub.dev/packages/sqflite_sqlcipher)
- QRコード生成：[qr_flutter](https://pub.dev/packages/qr_flutter)
- QRコード読取り：[qr_code_scanner](https://pub.dev/packages/qr_code_scanner)
- アプリ権限リクエスト：[permission_handler](https://pub.dev/packages/permission_handler)
- 交換用電文の暗号化：[encrypt](https://pub.dev/packages/encrypt)
