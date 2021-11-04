library galleryimage;

import 'package:flutter/material.dart';

import './gallery_Item_model.dart';
import './gallery_Item_thumbnail.dart';
import './gallery_image_view_wrapper.dart';
import './util.dart';

// class GalleryImage extends StatefulWidget {
//   final List<String> imageUrls;
//   final String? titleGallery;

//   const GalleryImage({required this.imageUrls, this.titleGallery});
//   @override
//   _GalleryImageState createState() => _GalleryImageState();
// }

// class name extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class GalleryImage extends StatelessWidget {
  final List<GalleryItemModel> galleryItems;
  final String? titleGallery;
  final Function? onDelete;

  GalleryImage({
    Key? key,
    required this.galleryItems,
    this.titleGallery,
    this.onDelete,
  }) : super(key: key);

  // @override
  // void initState() {
  //   buildItemsList(widget.imageUrls);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: galleryItems.isEmpty
            ? getEmptyWidget()
            : GridView.builder(
                primary: false,
                itemCount: galleryItems.length,
                padding: EdgeInsets.all(0),
                semanticChildCount: 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 5,
                ),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    // if have less than 4 image w build GalleryItemThumbnail
                    // if have mor than 4 build image number 3 with number for other images
                    // child: galleryItems.length > 3 && index == 2
                    //     ? buildImageNumbers(index, context)
                    //     : GalleryItemThumbnail(
                    //         galleryItem: galleryItems[index],
                    //         onTap: () {
                    //           openImageFullScreen(index, context);
                    //         },
                    //       ),
                    child: buildDeleteButton(
                      GalleryItemThumbnail(
                        galleryItem: galleryItems[index],
                        onTap: () {
                          openImageFullScreen(index, context);
                        },
                      ),
                      index,
                      context,
                    ),
                  );
                }));
  }

  Widget buildDeleteButton(Widget child, int index, BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      // fit: StackFit.,
      children: <Widget>[
        child,
        Container(
          color: Colors.black.withOpacity(.7),
          child: IconButton(
            icon: Icon(Icons.delete_forever_outlined, color: Colors.white),
            onPressed: () {
              onDelete?.call();
            },
          ),
        ),
      ],
    );
  }

// build image with number for other images
  Widget buildImageNumbers(int index, BuildContext context) {
    return GestureDetector(
      onTap: () {
        openImageFullScreen(index, context);
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        fit: StackFit.expand,
        children: <Widget>[
          GalleryItemThumbnail(
            galleryItem: galleryItems[index],
          ),
          Container(
            color: Colors.black.withOpacity(.7),
            child: Center(
              child: Text(
                "+${galleryItems.length - index}",
                style: TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

// to open gallery image in full screen
  void openImageFullScreen(final int indexOfImage, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryImageViewWrapper(
          titleGallery: titleGallery,
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: indexOfImage,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

// clear and build list
  buildItemsList(List<String> items) {
    galleryItems.clear();
    items.forEach((item) {
      galleryItems.add(
        GalleryItemModel(id: item, imageUrl: item),
      );
    });
  }
}
