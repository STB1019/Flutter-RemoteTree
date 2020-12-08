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
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            )));
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Color(0xFFE5D1FE),
      body: Card(
          elevation: 8,
          color: Color(0xFFB989FF),
          margin: EdgeInsets.all(10.0),
          child: Column(
            children: [
              title,
              Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.network(
                      imgLink,
                      key: ValueKey(imgLink),
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
