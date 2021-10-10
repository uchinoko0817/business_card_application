import 'package:business_card_quest_application/global/constants.dart';
import 'package:business_card_quest_application/models/entities/business_card.dart';
import 'package:business_card_quest_application/models/entities/creature.dart';
import 'package:business_card_quest_application/view_models/gallery_page_view_model.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatelessWidget {
  GalleryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ギャラリー'),
      ),
      body: FutureBuilder(
        future: context.read<GalleryPageViewModel>().initScreenData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          final int countAll =
              50; //context.read<GalleryPageViewModel>().countAll;
          final int countCollected = 49;
          // context.read<GalleryPageViewModel>().countCollected;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
                child: SizedBox(
                    height: 100,
                    width: 100,
                    child: const CircularProgressIndicator()));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.extent(
                maxCrossAxisExtent:
                    MediaQuery.of(context).size.shortestSide / 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.5,
                children: _buildCreatureList(context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildCreatureList(BuildContext context) {
    final BusinessCard? myCard =
        ModalRoute.of(context)?.settings.arguments as BusinessCard?;
    final List<Creature> creatures =
        context.read<GalleryPageViewModel>().creatures;
    final List<bool> collectionFlags =
        context.read<GalleryPageViewModel>().collectionFlags;

    final Widget Function(Widget child) putBannerFunc = (child) {
      return Banner(
        location: BannerLocation.topEnd,
        message: 'あなた',
        color: Colors.green,
        child: child,
      );
    };

    return List.generate(creatures.length, (i) {
      final Creature creature = creatures[i];
      final bool isCollected = collectionFlags[i];
      final Widget card = Card(
        color: isCollected ? Colors.white : Colors.black54,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Visibility(
                  visible: isCollected,
                  maintainSize: false,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow[800]!),
                        color: Colors.yellow[500],
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(creature.rarity, (i) {
                        return Icon(
                          Icons.star,
                          color: Colors.yellow[800],
                          size: 12,
                        );
                      }),
                    ),
                  )),
              const SizedBox(height: 5),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCollected ? Colors.blueGrey : Colors.black54,
                    ),
                    child: Image.asset(isCollected
                        ? creature.imageFilePath
                        : '${AssetsPaths.common}${AssetsNames.question}')),
              ),
              const SizedBox(height: 5),
              FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(isCollected ? creature.name : '???'))
            ],
          ),
        ),
      );
      return myCard?.creatureCode == creature.code ? putBannerFunc(card) : card;
    });
  }
}
