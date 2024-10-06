import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';

import '../models/overview_carosalslider.dart';

class EventCarousel extends StatelessWidget {
  final List<EventData> eventList;

  EventCarousel({Key? key, required this.eventList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if the eventList is empty
    if (eventList.isEmpty) {
      return Center(child: Text("No events available.")); // Placeholder when there are no events
    }

    return CarouselSlider.builder(
      itemCount: eventList.length,
      itemBuilder: (context, index, realIndex) {
        final event = eventList[index]; // Accessing event safely
        return EventCard(event: event);
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2,
        viewportFraction: 1,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final EventData event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Card(
        color: shadeOne,
        elevation: 5,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Left side image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  event.image ?? 'https://via.placeholder.com/150', // Placeholder if image is null
                  fit: BoxFit.cover,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network('https://via.placeholder.com/150'); // Show placeholder on error
                  },
                ),
              ),
            ),
            // Right side event details
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.title ?? 'Event Name',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14),
                        SizedBox(width: 4),
                        Text(event.date ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14),
                        SizedBox(width: 4),
                        Text(event.eventTime ?? ''),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14),
                        SizedBox(width: 4),
                        Container(
                          width: 100,
                          child: Text(
                            event.place ?? '',
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
