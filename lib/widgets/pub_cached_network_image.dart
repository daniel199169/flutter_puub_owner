import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PubCachedNetworkImage extends StatelessWidget {
  final String imageURL;
  PubCachedNetworkImage({this.imageURL});
  @override
  Widget build(BuildContext context) {
    print('imageURL '+imageURL);
    return CachedNetworkImage(
      
      imageUrl: imageURL,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        print('error ==>'+error.toString());
        return Image.network(
          'https://i.pinimg.com/originals/ed/24/38/ed24383468450c426e7f825bf5071e73.jpg',
          fit: BoxFit.fill,
        );
      },
    );
  }
}
