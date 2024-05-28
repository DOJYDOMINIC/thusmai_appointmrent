import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/videoplayer_controller.dart';
import 'package:thusmai_appointmrent/pages/videos/videolist.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/zoommeeting_controller.dart';
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
    Provider.of<VideoPlayerStateController>(context, listen: false).playlistDetails();
    Provider.of<ZoomMeetingController>(context,listen: false).zoomClass();

  }

  var meetingLink = "https://meet.google.com/ept-whtp-dgr";

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<VideoPlayerStateController>(context).playList;
   var zoomDetails =  Provider.of<ZoomMeetingController>(context,listen: false).ZoomClassModelData;
    String formattedDate = DateFormat('dd/MM/yy').format(zoomDetails.zoomdate??DateTime.now());

    // Example DateTime, you can use DateTime.now() for the current time
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: shadeFour),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text("Zoom Meetings",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        zoomVideoDescription,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_month),
                          Text("Date :"),
                          Text("${formattedDate}")
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Icon(Icons.alarm),
                          Text("Time :"),
                          Text("${zoomDetails.zoomStartTime}")
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        zoomVideoDescription2,
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 128.w,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blue)),
                              onPressed: () {
                             var formattedDate =  DateTime.now().toString();
                             String formattedTime = DateFormat('hh:mm a').format(DateTime.now()).toString(); // Format as AM/PM
                                Provider.of<ZoomMeetingController>(context,listen: false).zoomPost(formattedDate, formattedTime);
                                launchUrl(Uri.parse(zoomDetails.zoomLink??""));
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
              child: data.playlists?.length != null? ListView.builder(
            itemCount: data.playlists?.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () {
                    Provider.of<VideoPlayerStateController>(context, listen: false).videoPlaylistDetails(
                        "${data.playlists?[index].playListHeading.toString()}");
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
                                    image: NetworkImage(
                                        "${data.playlists![index].playListImage}"),
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
                              Text(
                                  "${data.playlists?[index].playListHeading}"),
                              Row(
                                children: [
                                  Icon(Icons.videocam),
                                  Text(
                                      "(${data.playlists?[index].videoHeadingCount.toString()}) Videos"),
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
          ): Center(child: CircularProgressIndicator())),
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
