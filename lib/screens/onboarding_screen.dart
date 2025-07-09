import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/configs/colors.dart';
import 'package:notes_app/helpers/onboarding_status_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  bool onLastPage = false;
  CarouselSliderController carouselController = CarouselSliderController();

  List<String> titles = ['Archive Notes', 'Personalize Theme', 'Hold & Tap'];

  List<String> subTtitles = [
    'Make it easy to group notes by archive/unarchive',
    'Customize the theme to your personality',
    'Hold the note to get more options',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CarouselSlider(
                      items: [
                        Container(
                          width:
                              constraints.maxWidth < 600
                                  ? double.infinity
                                  : 600,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.archive,
                                color: primaryColor,
                                size: 100,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 100,
                                width: 2,
                                color: greyColor,
                              ),
                              Icon(
                                Icons.unarchive,
                                color: primaryColor,
                                size: 100,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width:
                              constraints.maxWidth < 600
                                  ? double.infinity
                                  : 600,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dark_mode,
                                color: blackColor,
                                size: 100,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 100,
                                width: 2,
                                color: greyColor,
                              ),
                              Icon(
                                Icons.light_mode,
                                color: yellowColor,
                                size: 100,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width:
                              constraints.maxWidth < 600
                                  ? double.infinity
                                  : 600,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: primaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      size: 24,
                                      color: whiteColor,
                                    ),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Icon(
                                          Icons.archive,
                                          size: 24,
                                          color: whiteColor,
                                        ),
                                        Icon(
                                          Icons.delete,
                                          size: 24,
                                          color: whiteColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              CardDummy(
                                title: 'Learn Dart',
                                description: 'Next material about async-await',
                                datetime: DateTime.now(),
                                color: whiteColor,
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                children: [
                                  CardDummy(
                                    title: 'Learn Flutter',
                                    description:
                                        'Next material about state management',
                                    datetime: DateTime.now().subtract(
                                      Duration(minutes: 5),
                                    ),
                                    color: primaryColor.withAlpha(50),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.touch_app,
                                      color: whiteColor,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: constraints.maxHeight,
                        viewportFraction: 1,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                            if (currentIndex == 2) {
                              setState(() {
                                onLastPage = true;
                              });
                            } else {
                              setState(() {
                                onLastPage = false;
                              });
                            }
                          });
                        },
                      ),
                      carouselController: carouselController,
                    );
                  },
                ),
              ),
              Text(
                titles[currentIndex],
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                subTtitles[currentIndex],
                style: TextStyle(color: blackColor, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        carouselController.animateToPage(2);
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          color: onLastPage ? greyColor : secondaryColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == 0 ? primaryColor : greyColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == 1 ? primaryColor : greyColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentIndex == 2 ? primaryColor : greyColor,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        if (onLastPage) {
                          await saveOnboardingStatus();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        } else {
                          carouselController.nextPage();
                        }
                      },
                      child: Text(
                        onLastPage ? 'Finish' : 'Next',
                        style: TextStyle(fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDummy extends StatelessWidget {
  final String title;
  final String description;
  final DateTime datetime;
  final Color color;
  const CardDummy({
    super.key,
    required this.title,
    required this.description,
    required this.datetime,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: greyColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: Theme.of(context).textTheme.labelLarge,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              DateFormat.yMEd().add_jms().format(datetime),
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.copyWith(color: greyColor),
            ),
          ),
        ],
      ),
    );
  }
}
