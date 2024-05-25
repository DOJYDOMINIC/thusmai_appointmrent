import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/videoplayer.dart';
import 'package:thusmai_appointmrent/pages/videos/videolist.dart';
import 'package:thusmai_appointmrent/pages/videos/videospage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widgets/additionnalwidget.dart';

class VideosPageOne extends StatefulWidget {
  const VideosPageOne({super.key});

  @override
  State<VideosPageOne> createState() => _VideosPageOneState();
}

class _VideosPageOneState extends State<VideosPageOne> {
  @override
  void initState() {
    super.initState();

    Provider.of<VideoPlayerState>(context,listen: false).playlistDetails();
    Provider.of<VideoPlayerState>(context,listen: false).videoPlaylist();
  }
  var meetingLink = "https://meet.google.com/ept-whtp-dgr";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: shadeFour),
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 8,),
                        Text("Zoom Meetings",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8,),
                        Text(
                          "Ready to find your inner peace? Your meditation session is about to begin! Join our Zoom meeting now for a tranquil journey:",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.calendar_month),
                            Text("Date :"),
                            Text("02/05/2024")
                          ],
                        ),
                    SizedBox(height: 8,),
                        Row(
                          children: [
                            Icon(Icons.alarm),
                            Text("Time :"),
                            Text("7:30 PM")
                          ],
                        ),
                        SizedBox(height: 8,),
                        Text(
                          "Join in developing mindfulness.I'll see you there!",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 8,),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 128.w,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStatePropertyAll(Colors.blue)),
                                onPressed: () {
                                  launchUrl(Uri.parse(meetingLink));
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Join",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      ]),
                ),
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16, left: 16),
                  child: Text(
                    "Video Playlist",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )),
            Expanded(
                child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      slidePageRoute(context, VideoList());
                      // Navigator.push(context,  MaterialPageRoute(builder: (context) => VideoList(),));
                      // launchUrl(Uri.parse("https://www.youtube.com/watch?v=AMe1769IDPY") );
                    },
                    child: Container(
                      height: 120.h,
                      decoration: BoxDecoration(
                        color: shadeFour,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 16.sp),
                            child: Container(
                              height: 100.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(guruji),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text("Heading of category"),
                                Row(
                                  children: [
                                    Icon(Icons.videocam),
                                    Text("(3) Videos"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )),
          ],
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
