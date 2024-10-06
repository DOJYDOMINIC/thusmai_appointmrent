import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_common/get_reset.dart';

import '../constant/constant.dart';

class BlogImageCarousel extends StatelessWidget {
  final List<dynamic> blogsList;
  final String titleName;
  final Color backgroundColor;
  final int second;

  BlogImageCarousel(
      {super.key,
      required this.blogsList,
      required this.titleName,
      required this.backgroundColor, required this.second});

  // Method to show the bottom sheet with blog details
  void _showBlogDetails(BuildContext context, dynamic blog) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBlogImage(blog.image),
                SizedBox(height: 16.h),
                Text(
                  blog.title ?? 'No Event Name',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                if (blog.eventTime != null && blog.eventTime.isNotEmpty)
                  Text(
                    '${blog.date ?? 'N/A'} (${blog.eventTime})',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                SizedBox(height: 8.h),
                if (blog.description != null && blog.description.isNotEmpty)
                  Text(
                    blog.description!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build the blog image
  Widget _buildBlogImage(String? imageUrl) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: imageUrl != null
            ? DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(imageUrl),
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                "No Image Available",
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }

  // Helper method to build each carousel item
  Widget _buildCarouselItem(BuildContext context, dynamic blog, int index,) {
    return GestureDetector(
      onTap: () => _showBlogDetails(context, blog),
      child: Padding(
        padding: EdgeInsets.all( 8.sp),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: BorderRadius.circular(8),
            image: blog.image != null
                ? DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(blog.image),
                  )
                : null,
          ),
          child: blog.image == null
              ? Center(
                  child: Text(
                    "No Image Available",
                    textAlign: TextAlign.center,
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.sp,vertical: 10.sp),
        child: Container(
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(children: [
              Padding(
                padding:  EdgeInsets.all(8.sp),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(titleName,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              CarouselSlider.builder(
                itemCount: blogsList.length,
                itemBuilder: (context, index, _) {
                  return _buildCarouselItem(context, blogsList[index], index);
                },
                options: CarouselOptions(
                  aspectRatio: 1.2,
                  viewportFraction: 1,
                  enableInfiniteScroll: blogsList.length > 1,
                  autoPlay: blogsList.length > 1,
                  autoPlayInterval: Duration(milliseconds: second),
                  scrollDirection: Axis.vertical,
                ),
              ),
            ])),
      ),
    );
  }

  // Helper widget to display when there are no blogs
  Widget _buildNoBlogsWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBlogDetails(context, null),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.sp),
        child: Container(
          height: 100.h,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.white,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Colors.amber.shade100,
                Colors.amber.shade50,
                Colors.amber.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              "No Data",
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
        ),
      ),
    );
  }
}
