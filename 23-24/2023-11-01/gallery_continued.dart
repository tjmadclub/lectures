import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// This is a very small change to the gallery app
// instead of hardcoding a list of text for the details
// we hardcode a list of urls that link to text for the 
// details -- what a great improvement .. . .. . . 
// ^ ik doesn't make sense but this is just to show the
// http package, how networking works, and future
// and late in flutter

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
  final List<String> detailUrls = [
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-01-11/assets/detail1.txt",
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-01-11/assets/detail2.txt",
    "https://raw.githubusercontent.com/tjmadclub/lectures/main/23-24/2023-01-11/assets/detail3.txt"
  ];

  final String image;
  final int index;

  ImageDetails({ super.key, required this.image, required this.index });

  @override
  State<ImageDetails> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetails> {
  late Future<String> text;
  
  @override
  void initState() {
    super.initState();
    text = retrieveText(widget.detailUrls, widget.index);
  }
  
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
          FutureBuilder<String>(
            future: text,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          )
        ]
      )
    );
  }
}

Future<String> retrieveText(List<String> detailUrls, int index) async {
  final resp = await http.get(Uri.parse(detailUrls[index]));
  
  if (resp.statusCode == 200) {
    return resp.body;
  } else {
    throw Exception("failed to load text for some reason!!!");
  }
}