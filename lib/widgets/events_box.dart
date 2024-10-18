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
      return Center(
        child: Container(
          height: 150, // Same height as the EventCard (adjust as needed)
          width: double.infinity, // Make it take the full width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFB94D).withOpacity(0.6), // Start color
                Colors.white, // End color
              ],
              begin: Alignment.centerLeft, // Start the gradient from the left
              end: Alignment.centerRight, // End the gradient on the right
            ),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ), // Same border as the EventCard
            borderRadius:
                BorderRadius.circular(8), // Match the card's border radius
          ),
          child: Center(
            child: Text(
              "No events available.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Customize the color as needed
              ),
            ),
          ),
        ),
      );
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
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height *
                    .6, // Adjust the height as needed
                decoration: BoxDecoration(
                  // color: const Color.fromARGB(255, 235, 225, 140),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        event.title != null
                            ? Text(
                                event.title!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Adjust the text color
                                ),
                              )
                            : Text(
                                'No title available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue, // Adjust the text color
                                ),
                              ),
                        SizedBox(height: 16),
                        event.image != null
                            ? Image.network(
                                event.image!,
                                width: 350, // Adjust the image width
                                height: 220, // Adjust the image height
                                fit: BoxFit.fill, // Adjust the image fit
                              )
                            : Container(), // Show the image if it's not null
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            event.date != null
                                ? Text(
                                    'Date: ${event.date}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight
                                            .bold // Adjust the text color
                                        ),
                                  )
                                : Text(
                                    'No date available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Colors.grey, // Adjust the text color
                                    ),
                                  ),
                            SizedBox(width: 18),
                            event.eventTime != null
                                ? Text(
                                    'Time: ${event.eventTime}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    'No time available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Colors.grey, // Adjust the text color
                                    ),
                                  ),
                          ],
                        ),
                        SizedBox(height: 13),
                        event.place != null
                            ? Text(
                                'Location: ${event.place}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'No location available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey, // Adjust the text color
                                ),
                              ),
                        SizedBox(height: 18),
                        event.description != null
                            ? Text(
                                event.description!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black, // Adjust the text color
                                ),
                              )
                            : Text(
                                'No description available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey, // Adjust the text color
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey, width: 2), // Add colored border
            borderRadius: BorderRadius.circular(8),
          ),
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
                      event.image ??
                          'https://via.placeholder.com/150', // Placeholder if image is null
                      fit: BoxFit.cover,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                            'https://via.placeholder.com/150'); // Show placeholder on error
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
        ));
  }
}
