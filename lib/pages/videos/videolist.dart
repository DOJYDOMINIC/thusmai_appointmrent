import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constant/constant.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/videoplayer_controller.dart';

class VideoList extends StatefulWidget {
  const VideoList({super.key});

  @override
  State<VideoList> createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
  }

  @override
  Widget build(BuildContext context) {
    List data = Provider.of<VideoPlayerStateController>(context).videoPlayList;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        } else {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: shadeTwo,
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
            "Video List",
            style: TextStyle(color: shadeOne),
          ),
          // centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              String getYoutubeThumbnail(String videoLink) {
                if (videoLink.isEmpty) {
                  return noImage;
                }
                final uri = Uri.parse(videoLink);
                final videoId = uri.queryParameters['v']?.trim() ??
                    uri.pathSegments.last.trim();
                return 'https://img.youtube.com/vi/$videoId/0.jpg';
              }

              return GestureDetector(
                onTap: () {
                  launchURL(Uri.parse(data[index].videoLink ?? ''));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: videoBox,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 192.h,
                            width: 336.w, // Adjust the height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(getYoutubeThumbnail(
                                    data[index].videoLink.toString())),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].videoHeading ?? '',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}
