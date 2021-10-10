class Versions {
  static const int appMajorVersion = 1;
  static const int appMinorVersion = 0;
  static const int appPatchVersion = 0;
  static const int dbVersion = 1;
}

class Passwords {
  static const String databasePassword = 'uchinoko';
}

class AssetsPaths{
  static const String common = 'assets/images/common/';
}

class AssetsNames{
  static const String icLauncherRound = 'ic_launcher_round.png';
  static const String question = 'question.png';
  static const String idCard = 'id-card.png';
  static const String qr = 'qr.png';
  static const String qrCodeScan = 'qr-code-scan.png';
  static const String userList = 'user-list.png';
  static const String windowOfFourRoundedSquares = 'window-of-four-rounded-squares.png';
  static const String information = 'information.png';
  static const String emptyFolder = 'empty-folder.png';
}

class RouteNames {
  static const String homePage = '/';
  static const String detailPage = '/detail';
  static const String editPage = '/edit';
  static const String qrCodePage = '/qrCode';
  static const String scanPage = '/scan';
  static const String listPage = '/list';
  static const String galleryPage = '/gallery';
}

class DisplayItemTitles {
  static const String name = '氏名';
  static const String companyName = '会社名 / 法人名';
  static const String branchName = '営業所名';
  static const String departmentName = '部署名';
  static const String positionName = '役職 / 肩書';
  static const String qualification = '資格';
  static const String postalCode = '郵便番号';
  static const String address = '住所';
  static const String phoneNumber = '電話番号';
  static const String mailAddress = 'メールアドレス';
  static const String websiteUrl = 'WebサイトURL';
  static const String freeMessage = 'ひとことメッセージ';
}

class DisplayItemMaxLengths {
  static const int name = 20;
  static const int companyName = 20;
  static const int branchName = 20;
  static const int departmentName = 20;
  static const int positionName = 20;
  static const int qualification = 20;
  static const int postalCode = 8;
  static const int address = 80;
  static const int phoneNumber = 13;
  static const int mailAddress = 254;
  static const int websiteUrl = 256;
  static const int freeMessage = 200;
}

class DataBaseTableTitles {
  static const String businessCards = 'business_cards';
  static const String creatureCollections = 'creature_collections';
  static const String schemaMigrations = 'schema_migrations';
}

class DataBaseColumnTitles {
  static const String version = 'version';
  static const String id = 'id';
  static const String uuid = 'uuid';
  static const String name = 'name';
  static const String companyName = 'company_name';
  static const String branchName = 'branch_name';
  static const String departmentName = 'department_name';
  static const String positionName = 'position_name';
  static const String qualification = 'qualification';
  static const String postalCode = 'postal_code';
  static const String address = 'address';
  static const String phoneNumber = 'phone_number';
  static const String mailAddress = 'mail_address';
  static const String websiteUrl = 'website_url';
  static const String freeMessage = 'free_message';
  static const String creatureCode = 'creature_code';
  static const String creaturePower = 'creature_power';
  static const String creatureToughness = 'creature_toughness';
  static const String creatureLevel = 'creature_level';
  static const String isOwn = 'is_own';
  static const String isFavorite = 'is_favorite';
  static const String isDeleted = 'is_deleted';
  static const String isActivated = 'is_activated';
  static const String createdAt = 'created_at';
  static const String modifiedAt = 'modified_at';
}

class FileNames {
  static const String businessCardDB = 'business_card_db.db';
  static const String config = 'config.xml';
}

class XmlElementTitles {
  static const String config = 'config';
  static const String uuid = 'uuid';
}

class CreatureCodes {
  static const int centaur = 1;
  static const int kraken = 2;
  static const int dinosaur = 3;
  static const int treefolk = 4;
  static const int hand = 5;
  static const int echidna = 6;
  static const int robot = 7;
  static const int mushroom = 8;
  static const int harpy = 9;
  static const int phoenix = 10;
  static const int babyDragon = 11;
  static const int devil = 12;
  static const int troll = 13;
  static const int alien = 14;
  static const int minotaur = 15;
  static const int madremonte = 16;
  static const int satyr = 17;
  static const int karakasakozou = 18;
  static const int pirate = 19;
  static const int werewolf = 20;
  static const int scarecrow = 21;
  static const int valkyrie = 22;
  static const int curupira = 23;
  static const int nessie = 24;
  static const int darkTreefolk = 25;
  static const int cerberus = 26;
  static const int gryphon = 27;
  static const int mermaid = 28;
  static const int vampire = 29;
  static const int goblin = 30;
  static const int yeti = 31;
  static const int leprechaun = 32;
  static const int medusa = 33;
  static const int chimera = 34;
  static const int elf = 35;
  static const int hydra = 36;
  static const int cyclops = 37;
  static const int pegasus = 38;
  static const int narwhal = 39;
  static const int woodcutter = 40;
  static const int zombie = 41;
  static const int dragon = 42;
  static const int frankenstein = 43;
  static const int witch = 44;
  static const int fairy = 45;
  static const int genie = 46;
  static const int pinocchio = 47;
  static const int ghost = 48;
  static const int wizard = 49;
  static const int unicorn = 50;
}

class CreatureNames {
  static const String centaur = 'ケンタウロス';
  static const String kraken = 'クラーケン';
  static const String dinosaur = 'レックス';
  static const String treefolk = 'ツリーフォーク';
  static const String hand = '手のおばけ';
  static const String echidna = 'エキドナ';
  static const String robot = 'ロボット';
  static const String mushroom = 'マッシュルーム';
  static const String harpy = 'ハーピー';
  static const String phoenix = 'フェニックス';
  static const String babyDragon = 'ベビードラゴン';
  static const String devil = 'デビル';
  static const String troll = 'トロール';
  static const String alien = 'エイリアン';
  static const String minotaur = 'ミノタウロス';
  static const String madremonte = 'マドレモンテ';
  static const String satyr = 'サテュロス';
  static const String karakasakozou = 'からかさこぞう';
  static const String pirate = 'パイレーツ';
  static const String werewolf = 'ワーウルフ';
  static const String scarecrow = 'かかし';
  static const String valkyrie = 'ヴァルキリー';
  static const String curupira = 'クルピラ';
  static const String nessie = 'ネッシー';
  static const String darkTreefolk = 'ダークツリーフォーク';
  static const String cerberus = 'ケルベロス';
  static const String gryphon = 'グリフィン';
  static const String mermaid = 'マーメイド';
  static const String vampire = 'ヴァンパイア';
  static const String goblin = 'ゴブリン';
  static const String yeti = 'イエティ';
  static const String leprechaun = 'レプラノーム';
  static const String medusa = 'メデューサ';
  static const String chimera = 'キメラ';
  static const String elf = 'エルフ';
  static const String hydra = 'ヒドラ';
  static const String cyclops = 'サイクロプス';
  static const String pegasus = 'ペガサス';
  static const String narwhal = 'イッカク';
  static const String woodcutter = 'ウッドカッター';
  static const String zombie = 'ゾンビ';
  static const String dragon = 'ドラゴン';
  static const String frankenstein = 'フランケンシュタイン';
  static const String witch = 'ウィッチ';
  static const String fairy = 'フェアリー';
  static const String genie = 'ジーニー';
  static const String pinocchio = 'ピノキオ';
  static const String ghost = 'ゴースト';
  static const String wizard = 'ウィザード';
  static const String unicorn = 'ユニコーン';
}

class Messages{
  static const String required = '必須項目';
  static const String enterRequiredItem = 'この項目は必ず入力してください';
}
