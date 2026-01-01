import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

final sampleDiaries = <Diary>[
  Diary(
    date: DateTime(2025, 11, 15),
    content:
        'Started working on my diary app today. Excited to see where this journey takes me!',
    image: DiaryImage(imagePath: '/images/image-1.png', isLandscape: false),
    tasks: [
      Task(
        title: "Complete project proposal",
        subtasks: [
          Task(title: "Write introduction"),
          Task(title: "Make diagrams"),
          Task(title: "Review with team"),
        ],
      ),
    ],
  ),

  // November 2025
  Diary(
    date: DateTime(2025, 11, 8),
    content:
        'Thanksgiving preparations begin. Grateful for all the wonderful people in my life.',
    image: null,
    tasks: [
      Task(
        title: "Complete project proposal",
        subtasks: [
          Task(title: "Write introduction"),
          Task(title: "Make diagrams"),
          Task(title: "Review with team"),
        ],
      ),
    ],
  ),
  Diary(
    date: DateTime(2025, 11, 3),
    content:
        'Fall colors are at their peak. Took a long walk to capture the beautiful scenery.',
    image: DiaryImage(imagePath: '/images/image-2.png', isLandscape: false),
  ),

  // October 2025
  Diary(
    date: DateTime(2025, 10, 28),
    content:
        'Halloween party was amazing! My costume was a hit and I got so much candy.',
    image: DiaryImage(imagePath: '/images/image-3.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 10, 15),
    content:
        'Went to the farmers market and bought fresh vegetables. Planning to eat healthier.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 10, 5),
    content:
        'October starts with beautiful autumn colors everywhere. Nature is incredible.',
    image: DiaryImage(imagePath: '/images/image-4.png', isLandscape: false),
  ),

  // September 2025
  Diary(
    date: DateTime(2025, 9, 24),
    content:
        'Beach day with friends! The weather was perfect and we played volleyball all day.',
    image: DiaryImage(imagePath: '/images/image-5.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 9, 12),
    content:
        'Back to school season. Enrolled in a photography class, excited to learn!',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 9, 3),
    content:
        'Labor Day barbecue with neighbors. Amazing how food brings people together.',
    image: DiaryImage(imagePath: '/images/image-6.png', isLandscape: false),
  ),

  // August 2025
  Diary(
    date: DateTime(2025, 8, 20),
    content:
        'Summer vacation road trip! Visited three states and made incredible memories.',
    image: DiaryImage(imagePath: '/images/image-7.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 8, 10),
    content:
        'Hot summer day spent at the pool. Sometimes simple pleasures are the best.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 8, 1),
    content:
        'August begins with a family reunion. Cousins I haven\'t seen in years!',
    image: DiaryImage(imagePath: '/images/image-8.png', isLandscape: false),
  ),

  // July 2025
  Diary(
    date: DateTime(2025, 7, 25),
    content:
        'Camping trip in the mountains. Sleeping under the stars was magical.',
    image: DiaryImage(imagePath: '/images/image-9.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 7, 15),
    content:
        'Mid-year reflection: So much growth and learning in just seven months.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 7, 4),
    content:
        'Independence Day celebration with fireworks and good friends. Perfect evening!',
    image: DiaryImage(imagePath: '/images/image-10.png', isLandscape: false),
  ),

  // June 2025
  Diary(
    date: DateTime(2025, 6, 28),
    content: 'Graduated from my online course! Hard work finally paid off.',
    image: DiaryImage(imagePath: '/images/image-11.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 6, 18),
    content:
        'First day of summer! Made a bucket list of things to do before fall.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 6, 8),
    content:
        'Garden is blooming beautifully. My first attempt at growing vegetables succeeded!',
    image: DiaryImage(imagePath: '/images/image-12.png', isLandscape: false),
  ),

  // May 2025
  Diary(
    date: DateTime(2025, 5, 30),
    content:
        'Memorial Day weekend getaway to the lake. Peaceful and refreshing.',
    image: DiaryImage(imagePath: '/images/image-13.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 5, 20),
    content: 'Spring cleaning done! House feels fresh and organized again.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 5, 10),
    content:
        'Mom\'s birthday celebration. Made her favorite cake from scratch.',
    image: DiaryImage(imagePath: '/images/image-1.png', isLandscape: false),
  ),

  // April 2025
  Diary(
    date: DateTime(2025, 4, 25),
    content:
        'Cherry blossoms are in full bloom. Spring has officially arrived!',
    image: DiaryImage(imagePath: '/images/image-2.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 4, 15),
    content:
        'Started a new hobby: painting. My first landscape attempt wasn\'t terrible!',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 4, 5),
    content:
        'Easter brunch with family. Traditional recipes and new memories made.',
    image: DiaryImage(imagePath: '/images/image-3.png', isLandscape: false),
  ),

  // March 2025
  Diary(
    date: DateTime(2025, 3, 28),
    content:
        'Spring break trip to the coast. Ocean waves and sea breeze were therapeutic.',
    image: DiaryImage(imagePath: '/images/image-4.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 3, 17),
    content:
        'St. Patrick\'s Day celebration! Wore green and enjoyed Irish music downtown.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 3, 8),
    content:
        'International Women\'s Day. Celebrated amazing women who inspire me daily.',
    image: DiaryImage(imagePath: '/images/image-5.png', isLandscape: false),
  ),

  // February 2025
  Diary(
    date: DateTime(2025, 2, 22),
    content:
        'Winter is slowly ending. First signs of spring are appearing in the garden.',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 2, 14),
    content:
        'Valentine\'s Day dinner with my partner. Simple moments are the most precious.',
    image: DiaryImage(imagePath: '/images/image-6.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 2, 5),
    content: 'Snow day! Built a snowman and had hot cocoa by the fireplace.',
    image: DiaryImage(imagePath: '/images/image-7.png', isLandscape: false),
  ),

  // January 2025
  Diary(
    date: DateTime(2025, 1, 25),
    content:
        'One month into the year and already seeing progress on my goals. Feeling optimistic!',
    image: null,
  ),
  Diary(
    date: DateTime(2025, 1, 15),
    content:
        'Started my fitness journey today. Small steps toward a healthier lifestyle.',
    image: DiaryImage(imagePath: '/images/image-8.png', isLandscape: false),
  ),
  Diary(
    date: DateTime(2025, 1, 1),
    content:
        'New Year, new possibilities! Set meaningful resolutions for 2025.',
    image: DiaryImage(imagePath: '/images/image-9.png', isLandscape: false),
  ),
  Diary(
    date: DateTime.now(),
    content: 'What are your thoughts?',
    image: null,
  ),
];
