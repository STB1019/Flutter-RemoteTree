import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_tree/Model/Section.dart';

class ImageSectionPage extends StatefulWidget {
  final ImageSection _section;
  ImageSectionPage(this._section);
  @override
  _ImageSectionPageState createState() => _ImageSectionPageState();
}

class _ImageSectionPageState extends State<ImageSectionPage> {
  @override
  void dispose() {
    super.dispose();
    imageCache.clear();
  }

  @override
  Widget build(BuildContext context) {
    var section = widget._section;
    String imgLink = section.imagelink;
    var title = Padding(
        padding: EdgeInsets.all(12),
        child: Text(section.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            )));
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Center(
        child: Card(
            elevation: 4,
            margin: EdgeInsets.all(30),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  title,
                  Divider(),
                  CachedNetworkImage(
                    imageUrl: imgLink,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress,backgroundColor: Colors.white,),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
