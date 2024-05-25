import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/constant.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive design

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Heading of Category",
          style: TextStyle(color: shadeOne),
        ),
        // centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: .75
              ),
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                     launchUrl(Uri.parse("https://www.youtube.com/watch?v=VNSxTanl3YU"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        width: 64.w,
                        decoration: BoxDecoration(
                          color: shadeFour,
                          // borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(guruji),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Video Heading ipsum dolor sit",
                              style: TextStyle(fontSize: 10),overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 6),
                            Text(
                              "08 May 2018",
                              style: TextStyle(fontSize: 8),overflow: TextOverflow.ellipsis,

                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
  launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}