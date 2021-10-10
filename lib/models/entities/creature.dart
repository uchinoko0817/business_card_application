class Creature {
  int code;
  String name;
  int tier;
  int rarity;
  double statsBias;
  String imageFile;
  String get imageFilePath => 'assets/images/creatures/$imageFile';

  Creature(
      {this.code = 0,
      this.name = '',
      this.tier = 0,
      this.rarity = 0,
      this.statsBias = 1,
      this.imageFile = ''});

  Creature clone() {
    return Creature(
        code: code,
        name: name,
        tier: tier,
        rarity: rarity,
        statsBias: statsBias,
        imageFile: imageFile);
  }
}
