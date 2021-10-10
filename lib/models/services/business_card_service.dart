import 'dart:io';
import 'package:business_card_quest_application/global/global_data.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/utils/business_card_util.dart';
import 'package:business_card_quest_application/utils/common_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:business_card_quest_application/global/constants.dart';

class BusinessCardService {
  static final BusinessCardService instance = BusinessCardService._private();
  static Database? _db;

  static const String _createBusinessCardsTableSQL =
      'CREATE TABLE ${DataBaseTableTitles.businessCards} ('
      '${DataBaseColumnTitles.id} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
      '${DataBaseColumnTitles.uuid} TEXT NOT NULL UNIQUE DEFAULT \'\','
      '${DataBaseColumnTitles.name} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.companyName} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.branchName} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.departmentName} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.positionName} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.qualification} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.postalCode} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.address} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.phoneNumber} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.mailAddress} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.websiteUrl} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.freeMessage} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.creatureCode} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.creaturePower} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.creatureToughness} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.creatureLevel} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.isOwn} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.isFavorite} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.isDeleted} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.createdAt} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.modifiedAt} TEXT NOT NULL DEFAULT \'\')';

  static const String _createSchemaMigrationsTableSQL =
      'CREATE TABLE ${DataBaseTableTitles.schemaMigrations} ('
      '${DataBaseColumnTitles.version} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.createdAt} TEXT NOT NULL DEFAULT \'\')';

  static String get _createCreatureCollectionsTableSQL =>
      'CREATE TABLE ${DataBaseTableTitles.creatureCollections} ('
      '${DataBaseColumnTitles.creatureCode} INTEGER NOT NULL PRIMARY KEY,'
      '${DataBaseColumnTitles.isActivated} INTEGER NOT NULL DEFAULT 0,'
      '${DataBaseColumnTitles.createdAt} TEXT NOT NULL DEFAULT \'\','
      '${DataBaseColumnTitles.modifiedAt} TEXT NOT NULL DEFAULT \'\')';

  static String get _insertInitialVersionSQL =>
      'INSERT INTO ${DataBaseTableTitles.schemaMigrations} (${DataBaseColumnTitles.version}, ${DataBaseColumnTitles.createdAt}) VALUES (${Versions.dbVersion}, \'${CommonUtil.dateTimeToString(CommonUtil.getUtcNow())}\');';

  static String get _insertCreatureCollectionsSQL =>
      _getInsertCreatureCollectionsSQL();

  BusinessCardService._private();

  Future<void> _createTables(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(_createBusinessCardsTableSQL);
    batch.execute(_createCreatureCollectionsTableSQL);
    batch.execute(_createSchemaMigrationsTableSQL);
    batch.execute(_insertCreatureCollectionsSQL);
    batch.execute(_insertInitialVersionSQL);
    await batch.commit();
  }

  Future<Database?> _initDatabase() async {
    if (_db == null) {
      try {
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String dbPath = join(documentsDirectory.path, FileNames.businessCardDB);
        _db = await openDatabase(dbPath,
            version: 1,
            onCreate: _createTables,
            password: Passwords.databasePassword);
        return _db;
      } catch (e) {
        // TODO:ログ
        return null;
      }
    }
    return _db;
  }

  Future<void> _closeDatabase() async {
    if (_db != null) {
      try {
        await _db?.close();
      } catch (e) {
        // TODO:ログ
      } finally {
        _db = null;
      }
    }
  }

  Future<int> insert(BusinessCard businessCard) async {
    int result = 0;

    final Database? db = await _initDatabase();
    if (db == null) {
      return result;
    }

    try {
      result = await db.insert(DataBaseTableTitles.businessCards,
          BusinessCardUtil.getMapFromBusinessCard(businessCard));
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result;
  }

  Future<int> update(BusinessCard businessCard) async {
    int result = -1;

    final Database? db = await _initDatabase();
    if (db == null) {
      return result;
    }

    try {
      result = await db.update(DataBaseTableTitles.businessCards,
          BusinessCardUtil.getMapFromBusinessCard(businessCard),
          where: '${DataBaseColumnTitles.id} = ?', whereArgs: [businessCard.id]);
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result;
  }

  Future<bool> delete(int id) async {
    int result = 0;

    final Database? db = await _initDatabase();
    if (db == null) {
      return false;
    }

    try {
      result = await db.delete(DataBaseTableTitles.businessCards,
          where: '${DataBaseColumnTitles.id} = ?', whereArgs: [id]);
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result > 0;
  }

  Future<bool> readBusinessCards(List<BusinessCard> list,
      {String? uuid, bool? isOwn}) async {
    bool result = false;

    final Database? db = await _initDatabase();
    if (db == null) {
      return false;
    }

    String? where = '';
    List<dynamic>? whereArgs = [];
    if (uuid != null) {
      where = '${DataBaseColumnTitles.uuid} = ?';
      whereArgs.add(uuid);
    }
    if (isOwn != null) {
      if (where.isNotEmpty) {
        where += ' AND ';
      }
      where += '${DataBaseColumnTitles.isOwn} = ?';
      whereArgs.add(CommonUtil.boolToInt(isOwn));
    }

    try {
      List<Map<String, dynamic>> tmpList = await db.query(
          DataBaseTableTitles.businessCards,
          where: where,
          whereArgs: whereArgs,
          orderBy: '${DataBaseColumnTitles.id} ASC');
      list.addAll(List.generate(tmpList.length,
          (i) => BusinessCardUtil.getBusinessCardFromMap(tmpList[i])));
      result = true;
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result;
  }

  Future<bool> readAllCreatureCodes(List<int> list) async {
    bool result = false;

    final Database? db = await _initDatabase();
    if (db == null) {
      return false;
    }

    try {
      List<Map<String, dynamic>> tmpList = await db.query(
          DataBaseTableTitles.creatureCollections,
          distinct: true,
          columns: [DataBaseColumnTitles.creatureCode],
          where: '${DataBaseColumnTitles.isActivated} = ?',
          whereArgs: [CommonUtil.boolToInt(true)],
          orderBy: '${DataBaseColumnTitles.creatureCode} ASC');
      list.addAll(List.generate(
          tmpList.length, (i) => tmpList[i][DataBaseColumnTitles.creatureCode]));
      result = true;
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result;
  }

  Future<int> activateCreature(int creatureCode) async {
    int result = -1;

    final Database? db = await _initDatabase();
    if (db == null) {
      return result;
    }

    final Map<String, dynamic> values = {
      '${DataBaseColumnTitles.isActivated}': CommonUtil.boolToInt(true),
      '${DataBaseColumnTitles.modifiedAt}':
          CommonUtil.dateTimeToString(CommonUtil.getUtcNow())
    };

    try {
      result = await db.update(DataBaseTableTitles.creatureCollections, values,
          where:
              '${DataBaseColumnTitles.creatureCode} = ? AND ${DataBaseColumnTitles.isActivated} = ?',
          whereArgs: [creatureCode, CommonUtil.boolToInt(false)]);
    } catch (e) {
      // TODO:ログ
    } finally {
      await _closeDatabase();
    }

    return result;
  }

  static String _getInsertCreatureCollectionsSQL() {
    final String nowUtcStr =
        CommonUtil.dateTimeToString(CommonUtil.getUtcNow());
    final StringBuffer buffer = StringBuffer();
    buffer.write(
        'INSERT INTO ${DataBaseTableTitles.creatureCollections} (${DataBaseColumnTitles.creatureCode}, ${DataBaseColumnTitles.isActivated}, ${DataBaseColumnTitles.createdAt}, ${DataBaseColumnTitles.modifiedAt}) VALUES ');
    bool isAdd = false;
    GlobalData.creatureMap.values.forEach((creature) {
      if (isAdd) {
        buffer.write(', ');
      }
      buffer.write('(${creature.code}, 0, \'$nowUtcStr\', \'$nowUtcStr\')');
      isAdd = true;
    });
    buffer.write(';');
    return buffer.toString();
  }
}
