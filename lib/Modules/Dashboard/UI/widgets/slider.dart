// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:dots_indicator/dots_indicator.dart';

// import 'package:flutter/material.dart';

// class SliderWidget extends StatefulWidget {
//   const SliderWidget({Key? key}) : super(key: key);

//   @override
//   State<SliderWidget> createState() => _SliderWidgetState();
// }

// class _SliderWidgetState extends State<SliderWidget> {
//   final CarouselController _controller = CarouselController();
//   int _currentIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               children: [
//                 SizedBox(
//                   width: 356,
//                   child: Center(
//                     child: CarouselSlider(
//                       items: [
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xffFFFFFF),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30.0, vertical: 35),
//                             child: Column(
//                               children: [
//                                 const Text(
//                                   'Hey, Mahreen',
//                                   style: TextStyle(
//                                       color: const Color(0xff00A3FF),
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Text(
//                                   'It’s great to have you with us! To help us optimize your experience tell us how you plan to use Xpiree',
//                                   style: TextStyle(
//                                       color: const Color(0xff475467),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(
//                                   height: 40,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     _controller.nextPage();
//                                   },
//                                   child: Container(
//                                     height: 44,
//                                     width: 228,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: const Color(0xffD0D5DD),
//                                       ),
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         'Personal',
//                                         style: TextStyle(
//                                             color: Color(0xffA7A8BB),
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   height: 13,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     _controller.nextPage();
//                                   },
//                                   child: Container(
//                                     height: 44,
//                                     width: 228,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: const Color(0xffD0D5DD),
//                                       ),
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         'Work',
//                                         style: TextStyle(
//                                             color: Color(0xffA7A8BB),
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xffFFFFFF),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30.0, vertical: 15),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/undraw_Reviewed_docs_re_9lmr 1.png',
//                                   scale: 4,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Text(
//                                   'Use Xpiree to keep track of your critical paper-work',
//                                   style: TextStyle(
//                                       color: const Color(0xff475467),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     _controller.nextPage();
//                                   },
//                                   child: Container(
//                                     height: 44,
//                                     width: 228,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: const Color(0xffD0D5DD),
//                                       ),
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(
//                                             color: Color(0xffA7A8BB),
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xffFFFFFF),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30.0, vertical: 15),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/undraw_Time_management_re_tk5w 1.png',
//                                   scale: 4,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Text(
//                                   'Get timely reminders on document expiration dates',
//                                   style: TextStyle(
//                                       color: const Color(0xff475467),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     _controller.nextPage();
//                                   },
//                                   child: Container(
//                                     height: 44,
//                                     width: 228,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(
//                                         width: 1,
//                                         color: const Color(0xffD0D5DD),
//                                       ),
//                                     ),
//                                     child: const Center(
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(
//                                             color: Color(0xffA7A8BB),
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: const Color(0xffFFFFFF),
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 30.0, vertical: 15),
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/image 10.png',
//                                   scale: 4,
//                                 ),
//                                 const SizedBox(
//                                   height: 20,
//                                 ),
//                                 const Text(
//                                   'Share and assign tasks to peer with a single tap',
//                                   style: TextStyle(
//                                       color: const Color(0xff475467),
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w500),
//                                   textAlign: TextAlign.center,
//                                 ),
// const SizedBox(
//   height: 20,
// ),
// InkWell(
//   onTap: () {
//     // _controller.nextPage();
//   },
//   child: Container(
//     height: 44,
//     width: 228,
//     decoration: BoxDecoration(
//       color: const Color(0xff00A3FF),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: const Center(
//       child: Text(
//         'Let’s get started',
//         style: TextStyle(
//             color: Color(0xffFFFFFF),
//             fontSize: 14,
//             fontWeight: FontWeight.w600),
//         textAlign: TextAlign.center,
//       ),
//     ),
//   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                       carouselController: _controller,
//                       options: CarouselOptions(
//                         height: 340,
//                         scrollPhysics: NeverScrollableScrollPhysics(),
//                         autoPlay: false,
//                         enlargeCenterPage: true,
//                         viewportFraction: 1,
//                         aspectRatio: 4.8,
//                         initialPage: 0,
//                         enableInfiniteScroll: true,
//                         onPageChanged: (index, reason) {
//                           setState(() {
//                             _currentIndex = index;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: 20,
//                   right: 20,
//                   child: DotsIndicator(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     dotsCount: 4,
//                     position: _currentIndex,
//                     onTap: (position) {},
//                     decorator: DotsDecorator(
//                       color: Color(0xffD9D9D9),
//                       activeColor: Color(0xff4FC3F7),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:Xpiree/Modules/Dashboard/UI/dashboard.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({Key? key}) : super(key: key);

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 356,
                  child: Center(
                    child: CarouselSlider(
                      items: [
                        buildSliderItem(
                          title: 'Hey, Mahreen',
                          description:
                              'It’s great to have you with us! To help us optimize your experience tell us how you plan to use Xpiree',
                          buttons: ['Personal', 'Work'],
                          onTap: () {
                            _controller.nextPage();
                          },
                        ),
                        buildSliderImageItem(
                          imagePath:
                              'assets/images/undraw_Reviewed_docs_re_9lmr 1.png',
                          description:
                              'Use Xpiree to keep track of your critical paper-work',
                          buttonText: 'Next',
                          onTap: () {
                            _controller.nextPage();
                          },
                        ),
                        buildSliderImageItem(
                          imagePath:
                              'assets/images/undraw_Time_management_re_tk5w 1.png',
                          description:
                              'Get timely reminders on document expiration dates',
                          buttonText: 'Next',
                          onTap: () {
                            _controller.nextPage();
                          },
                        ),
                        buildSliderImageItem(
                          imagePath: 'assets/images/image 10.png',
                          description:
                              'Share and assign tasks to peers with a single tap',
                          buttonText: 'Let’s get started',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard(
                                        indexTab: 0,
                                      )),
                            );
                          },
                          isFinal: true,
                        ),
                      ],
                      carouselController: _controller,
                      options: CarouselOptions(
                        height: 340,
                        scrollPhysics: NeverScrollableScrollPhysics(),
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 1,
                        aspectRatio: 4.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 20,
                  child: DotsIndicator(
                    mainAxisAlignment: MainAxisAlignment.center,
                    dotsCount: 4,
                    position: _currentIndex.toInt(),
                    decorator: const DotsDecorator(
                      color: Color(0xffD9D9D9),
                      activeColor: Color(0xff4FC3F7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSliderItem(
      {required String title,
      required String description,
      required List<String> buttons,
      required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 35),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xff00A3FF),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xff475467),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            for (var button in buttons)
              InkWell(
                onTap: onTap,
                child: Container(
                  height: 44,
                  width: 228,
                  margin: const EdgeInsets.only(bottom: 13),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffD0D5DD),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      button,
                      style: const TextStyle(
                        color: Color(0xffA7A8BB),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSliderImageItem({
    required String imagePath,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    bool isFinal = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15),
        child: Column(
          children: [
            Image.asset(imagePath, scale: 4),
            const SizedBox(height: 20),
            Text(
              description,
              style: const TextStyle(
                color: Color(0xff475467),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: onTap,
              child: Container(
                height: 44,
                width: 228,
                decoration: BoxDecoration(
                  color: isFinal ? const Color(0xff00A3FF) : null,
                  borderRadius: BorderRadius.circular(8),
                  border: isFinal
                      ? null
                      : Border.all(
                          width: 1,
                          color: const Color(0xffD0D5DD),
                        ),
                ),
                child: Center(
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: isFinal
                          ? const Color(0xffFFFFFF)
                          : const Color(0xffA7A8BB),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
