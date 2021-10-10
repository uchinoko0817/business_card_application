import 'dart:convert';
import 'dart:io';
import 'package:business_card_quest_application/models/entities/config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';
import 'package:business_card_quest_application/global/constants.dart';

class ConfigService {
  static final ConfigService instance = ConfigService._private();

  ConfigService._private();

  Future<bool> checkExistConfig() async {
    try {
      String documentDirectory = await _getDocumentDirectory();
      File configFile = File('$documentDirectory/${FileNames.config}');
      if (configFile.existsSync()) {
        //TODO:ログ
        return true;
      }
    } catch (e) {
      // TODO:ログ
    }
    return false;
  }

  Future<Config?> readConfig() async {
    String xmlString = '';
    try {
      String documentDirectory = await _getDocumentDirectory();
      File configFile = File('$documentDirectory/${FileNames.config}');
      xmlString = configFile.readAsStringSync(encoding: utf8);
    } catch (e) {
      // TODO:ログ
      return null;
    }

    try {
      Config tmpConfig = Config();
      XmlDocument document = XmlDocument.parse(xmlString);
      Iterable<XmlElement> elements =
          document.findAllElements(XmlElementTitles.uuid);
      if (elements.isNotEmpty) {
        tmpConfig.ownUuid = elements.first.text;
      }
      //TODO:ログ
      return tmpConfig;
    } catch (e) {
      //TODO:ログ
      return null;
    }
  }

  Future<bool> writeConfig(Config configNotEnc) async {
    String xmlStr = '';
    try {
      XmlBuilder builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element(XmlElementTitles.config, nest: () {
        configNotEnc.toMap().forEach((key, value) {
          builder.element(key, nest: () {
            builder.text(value);
          });
        });
      });
      xmlStr = builder.buildDocument().toXmlString(pretty: true);
    } catch (e) {
      //TODO:ログ
      return false;
    }

    try {
      String documentDirectory = await _getDocumentDirectory();
      File configFile = File('$documentDirectory/${FileNames.config}');
      configFile.writeAsStringSync(xmlStr, encoding: utf8);
      //TODO:ログ
      return true;
    } catch (e) {
      //TODO:ログ
      return false;
    }
  }

  Future<String> _getDocumentDirectory() async {
    Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
