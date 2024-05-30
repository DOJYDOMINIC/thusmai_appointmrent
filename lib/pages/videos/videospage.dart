// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// class Video {
//   final String videoId;
//   final String title;
//   final bool autoPlay;
//   final bool loop;
//
//   Video({required this.videoId, required this.title, this.autoPlay = false, this.loop = false});
// }
//
// class VideosPage extends StatefulWidget {
//   const VideosPage({super.key});
//
//   @override
//   State<VideosPage> createState() => _VideosPageState();
// }
//
// class _VideosPageState extends State<VideosPage> {
//   late List<YoutubePlayerController> _controllers;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideoControllers();
//   }
//
//   void _initializeVideoControllers() {
//     // Example list of videos
//     List<Video> videos = [
//       Video(videoId: 'aH96tw8fXfk', title: 'Morning Video', autoPlay: true, loop: false),
//       Video(videoId: 'kvRq5sJsuHY', title: 'Evening Video'),
//       // Add more videos as needed
//     ];
//
//     _controllers = videos.map((video) {
//       YoutubePlayerController controller = YoutubePlayerController(
//         initialVideoId: video.videoId,
//         flags: YoutubePlayerFlags(
//           mute: false,
//           autoPlay: false,
//           disableDragSeek: false,
//           loop: false, // Don't set loop to true to handle replay manually
//           isLive: false,
//           forceHD: false,
//           enableCaption: false,
//         ),
//       );
//
//       // Add listener to pause the video when it ends
//       controller.addListener(() {
//         if (controller.value.playerState == PlayerState.ended) {
//           controller.pause();
//         }
//       });
//
//       return controller;
//     }).toList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ListView.builder(
//         itemCount: _controllers.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15.0),
//               child: YoutubePlayer(
//                 controller: _controllers[index],
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.blueAccent,
//                 progressColors: ProgressBarColors(
//                   playedColor: Colors.amber,
//                   handleColor: Colors.amberAccent,
//                 ),
//                 onReady: () {
//                   print("Video ${_controllers[index].initialVideoId} is ready");
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
