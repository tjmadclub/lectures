import 'package:flutter/material.dart';

// A simple Image Gallery App
// you don't need to copy exactly but it's fine if you do
// try to explore further -- use the Flutter docs
// try exploring animations, inputs or backend

void main() {
  runApp(ImageGalleryApp());
}

class ImageGalleryApp extends StatelessWidget {
  ImageGalleryApp({ super.key });

  // urls for image -- since they're external we will be using Image.network() or Image(image: NetworkImage())
  final List<String> imageUrls = [
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-18-10/assets/gallery-image-1.png",
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-18-10/assets/gallery-image-2.png",
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-18-10/assets/gallery-image-3.png"
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Gallery'),
        ),
        body: ImageGallery(imageUrls: imageUrls),
      ),
    );
  }
}

class ImageGallery extends StatefulWidget {
  final List<String> imageUrls;

  const ImageGallery({super.key, required this.imageUrls});

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int currentIndex = 0;

  void showNextImage() {
    setState(() {
      currentIndex++;
      if (currentIndex > widget.imageUrls.length) {
        currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network(
          widget.imageUrls[currentIndex],
          height: 300, // Adjust the height as needed
        ),
        SizedBox(height: 20), // space between the buttons and image
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: showNextImage,
              child: Text('Next Image')
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext ctx) => ImageDetails(image: widget.imageUrls[currentIndex], index: currentIndex)
                    )
                  );
                },
                child: Text("View Image Details")
            )
          ]
        ),
      ],
    );
  }
}

class ImageDetails extends StatefulWidget {
  final List<String> imageText = [
    "This image is great. I don't know why it's in the gallery, but it's great.",
    "This is a painting made by Van Gogh. It's very cool.",
    "This painting sucks. I actually do not know why it's in the gallery."
  ];

  final String image;
  final int index;

  ImageDetails({ super.key, required this.image, required this.index });

  @override
  State<ImageDetails> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Details")
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(widget.image),
          Text(widget.imageText[widget.index])
        ]
      )
    );
  }
}