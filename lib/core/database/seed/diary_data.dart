import 'package:flutter/material.dart';
import 'package:the_notebook/features/diary/domain/diary.dart';
import 'package:the_notebook/features/diary/domain/diary_image.dart';
import 'package:the_notebook/features/diary/domain/tag.dart';
import 'package:the_notebook/features/diary/domain/task.dart';

final sampleDiaries = [
  Diary(
    notebookId: 1,
    date: DateTime(2025, 11, 15),
    time: TimeOfDay(hour: 14, minute: 30),
    title: 'Starting My Diary Journey',
    tags: [Tag(name: 'programming'), Tag(name: 'development')],
    content:
        'Started working on my diary app today. Excited to see where this journey takes me!',
    image: DiaryImage(imagePath: '/images/image-1.png', isLandscape: false),
    tasks: [
      Task(
        title: "Complete project proposal",
        isCompleted: false,
        subtasks: [
          Task(title: "Write introduction", isCompleted: false),
          Task(title: "Make diagrams", isCompleted: false),
          Task(title: "Review with team", isCompleted: false),
        ],
      ),
    ],
  ),

  // November 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 11, 8),
    time: TimeOfDay(hour: 9, minute: 15),
    title: 'Thanksgiving Prep',
    tags: [Tag(name: 'gratitude'), Tag(name: 'family')],
    content:
        'Thanksgiving preparations begin. Grateful for all the wonderful people in my life.',
    image: null,
    tasks: [
      Task(
        title: "Complete project proposal",
        isCompleted: false,
        subtasks: [
          Task(title: "Write introduction", isCompleted: false),
          Task(title: "Make diagrams", isCompleted: false),
          Task(title: "Review with team", isCompleted: false),
        ],
      ),
    ],
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 11, 3),
    time: TimeOfDay(hour: 16, minute: 45),
    title: 'Autumn Walk',
    tags: [Tag(name: 'nature'), Tag(name: 'autumn')],
    content:
        'Fall colors are at their peak. Took a long walk to capture the beautiful scenery.',
    image: DiaryImage(imagePath: '/images/image-2.png', isLandscape: false),
  ),

  // October 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 10, 28),
    time: TimeOfDay(hour: 20, minute: 30),
    title: 'Halloween Party Night',
    tags: [Tag(name: 'party'), Tag(name: 'celebration')],
    content:
        'Halloween party was amazing! My costume was a hit and I got so much candy.',
    image: DiaryImage(imagePath: '/images/image-3.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 10, 15),
    time: TimeOfDay(hour: 8, minute: 0),
    title: 'Farmers Market Visit',
    tags: [Tag(name: 'health'), Tag(name: 'food')],
    content:
        'Went to the farmers market and bought fresh vegetables. Planning to eat healthier.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 10, 5),
    time: TimeOfDay(hour: 11, minute: 20),
    title: 'Beautiful October Day',
    tags: [Tag(name: 'autumn'), Tag(name: 'nature')],
    content:
        'October starts with beautiful autumn colors everywhere. Nature is incredible.',
    image: DiaryImage(imagePath: '/images/image-4.png', isLandscape: false),
  ),

  // September 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 9, 24),
    time: TimeOfDay(hour: 13, minute: 15),
    title: 'Beach Day with Friends',
    tags: [Tag(name: 'beach'), Tag(name: 'friends'), Tag(name: 'summer')],
    content:
        'Beach day with friends! The weather was perfect and we played volleyball all day.',
    image: DiaryImage(imagePath: '/images/image-5.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 9, 12),
    time: TimeOfDay(hour: 18, minute: 30),
    title: 'Photography Class Enrollment',
    tags: [Tag(name: 'education'), Tag(name: 'photography')],
    content:
        'Back to school season. Enrolled in a photography class, excited to learn!',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 9, 3),
    time: TimeOfDay(hour: 17, minute: 0),
    title: 'Labor Day Barbecue',
    tags: [Tag(name: 'community'), Tag(name: 'food')],
    content:
        'Labor Day barbecue with neighbors. Amazing how food brings people together.',
    image: DiaryImage(imagePath: '/images/image-6.png', isLandscape: false),
  ),

  // August 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 8, 20),
    time: TimeOfDay(hour: 10, minute: 45),
    title: 'Epic Road Trip',
    tags: [Tag(name: 'travel'), Tag(name: 'adventure')],
    content:
        'Summer vacation road trip! Visited three states and made incredible memories.',
    image: DiaryImage(imagePath: '/images/image-7.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 8, 10),
    time: TimeOfDay(hour: 15, minute: 20),
    title: 'Pool Day',
    tags: [Tag(name: 'relaxation'), Tag(name: 'summer')],
    content:
        'Hot summer day spent at the pool. Sometimes simple pleasures are the best.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 8, 1),
    time: TimeOfDay(hour: 12, minute: 0),
    title: 'Family Reunion',
    tags: [Tag(name: 'family'), Tag(name: 'reunion')],
    content:
        'August begins with a family reunion. Cousins I haven\'t seen in years!',
    image: DiaryImage(imagePath: '/images/image-8.png', isLandscape: false),
  ),

  // July 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 7, 25),
    time: TimeOfDay(hour: 21, minute: 30),
    title: 'Mountain Camping Trip',
    tags: [Tag(name: 'camping'), Tag(name: 'adventure'), Tag(name: 'nature')],
    content:
        'Camping trip in the mountains. Sleeping under the stars was magical.',
    image: DiaryImage(imagePath: '/images/image-9.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 7, 15),
    time: TimeOfDay(hour: 19, minute: 0),
    title: 'Mid-Year Reflection',
    tags: [Tag(name: 'reflection'), Tag(name: 'goals')],
    content:
        'Mid-year reflection: So much growth and learning in just seven months.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 7, 4),
    time: TimeOfDay(hour: 20, minute: 15),
    title: 'Independence Day',
    tags: [Tag(name: 'celebration'), Tag(name: 'friends')],
    content:
        'Independence Day celebration with fireworks and good friends. Perfect evening!',
    image: DiaryImage(imagePath: '/images/image-10.png', isLandscape: false),
  ),

  // June 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 6, 28),
    time: TimeOfDay(hour: 14, minute: 0),
    title: 'Course Graduation',
    tags: [Tag(name: 'achievement'), Tag(name: 'education')],
    content: 'Graduated from my online course! Hard work finally paid off.',
    image: DiaryImage(imagePath: '/images/image-11.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 6, 18),
    time: TimeOfDay(hour: 7, minute: 30),
    title: 'First Day of Summer',
    tags: [Tag(name: 'summer'), Tag(name: 'goals')],
    content:
        'First day of summer! Made a bucket list of things to do before fall.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 6, 8),
    time: TimeOfDay(hour: 16, minute: 10),
    title: 'Garden Success',
    tags: [Tag(name: 'gardening'), Tag(name: 'nature')],
    content:
        'Garden is blooming beautifully. My first attempt at growing vegetables succeeded!',
    image: DiaryImage(imagePath: '/images/image-12.png', isLandscape: false),
  ),

  // May 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 5, 30),
    time: TimeOfDay(hour: 11, minute: 45),
    title: 'Lake Getaway',
    tags: [Tag(name: 'weekend'), Tag(name: 'relaxation')],
    content:
        'Memorial Day weekend getaway to the lake. Peaceful and refreshing.',
    image: DiaryImage(imagePath: '/images/image-13.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 5, 20),
    time: TimeOfDay(hour: 10, minute: 0),
    title: 'Spring Cleaning Done',
    tags: [Tag(name: 'productivity'), Tag(name: 'organization')],
    content: 'Spring cleaning done! House feels fresh and organized again.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 5, 10),
    time: TimeOfDay(hour: 18, minute: 45),
    title: "Mom's Birthday",
    tags: [
      Tag(name: 'birthday'),
      Tag(name: 'family'),
      Tag(name: 'celebration')
    ],
    content:
        'Mom\'s birthday celebration. Made her favorite cake from scratch.',
    image: DiaryImage(imagePath: '/images/image-1.png', isLandscape: false),
  ),

  // April 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 4, 25),
    time: TimeOfDay(hour: 13, minute: 20),
    title: 'Cherry Blossoms',
    tags: [Tag(name: 'spring'), Tag(name: 'nature')],
    content:
        'Cherry blossoms are in full bloom. Spring has officially arrived!',
    image: DiaryImage(imagePath: '/images/image-2.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 4, 15),
    time: TimeOfDay(hour: 15, minute: 30),
    title: 'New Painting Hobby',
    tags: [Tag(name: 'art'), Tag(name: 'hobby')],
    content:
        'Started a new hobby: painting. My first landscape attempt wasn\'t terrible!',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 4, 5),
    time: TimeOfDay(hour: 11, minute: 0),
    title: 'Easter Brunch',
    tags: [Tag(name: 'celebration'), Tag(name: 'family')],
    content:
        'Easter brunch with family. Traditional recipes and new memories made.',
    image: DiaryImage(imagePath: '/images/image-3.png', isLandscape: false),
  ),

  // March 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 3, 28),
    time: TimeOfDay(hour: 9, minute: 30),
    title: 'Spring Break Coast Trip',
    tags: [Tag(name: 'travel'), Tag(name: 'beach')],
    content:
        'Spring break trip to the coast. Ocean waves and sea breeze were therapeutic.',
    image: DiaryImage(imagePath: '/images/image-4.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 3, 17),
    time: TimeOfDay(hour: 19, minute: 45),
    title: "St. Patrick's Day",
    tags: [Tag(name: 'music'), Tag(name: 'celebration')],
    content:
        'St. Patrick\'s Day celebration! Wore green and enjoyed Irish music downtown.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 3, 8),
    time: TimeOfDay(hour: 14, minute: 15),
    title: "Women's Day",
    tags: [Tag(name: 'inspiration'), Tag(name: 'celebration')],
    content:
        'International Women\'s Day. Celebrated amazing women who inspire me daily.',
    image: DiaryImage(imagePath: '/images/image-5.png', isLandscape: false),
  ),

  // February 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 2, 22),
    time: TimeOfDay(hour: 16, minute: 0),
    title: 'Signs of Spring',
    tags: [Tag(name: 'nature'), Tag(name: 'spring')],
    content:
        'Winter is slowly ending. First signs of spring are appearing in the garden.',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 2, 14),
    time: TimeOfDay(hour: 19, minute: 30),
    title: "Valentine's Day Dinner",
    tags: [Tag(name: 'love'), Tag(name: 'celebration')],
    content:
        'Valentine\'s Day dinner with my partner. Simple moments are the most precious.',
    image: DiaryImage(imagePath: '/images/image-6.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 2, 5),
    time: TimeOfDay(hour: 10, minute: 30),
    title: 'Snow Day Fun',
    tags: [Tag(name: 'winter'), Tag(name: 'fun')],
    content: 'Snow day! Built a snowman and had hot cocoa by the fireplace.',
    image: DiaryImage(imagePath: '/images/image-7.png', isLandscape: false),
  ),

  // January 2025
  Diary(
    notebookId: 1,
    date: DateTime(2025, 1, 25),
    time: TimeOfDay(hour: 20, minute: 0),
    title: 'Progress Check',
    tags: [Tag(name: 'goals'), Tag(name: 'reflection')],
    content:
        'One month into the year and already seeing progress on my goals. Feeling optimistic!',
    image: null,
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 1, 15),
    time: TimeOfDay(hour: 6, minute: 30),
    title: 'Fitness Journey Begins',
    tags: [Tag(name: 'fitness'), Tag(name: 'health'), Tag(name: 'goals')],
    content:
        'Started my fitness journey today. Small steps toward a healthier lifestyle.',
    image: DiaryImage(imagePath: '/images/image-8.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime(2025, 1, 1),
    time: TimeOfDay(hour: 0, minute: 0),
    title: 'New Year 2025',
    tags: [Tag(name: 'newyear'), Tag(name: 'goals'), Tag(name: 'celebration')],
    content:
        'New Year, new possibilities! Set meaningful resolutions for 2025.',
    image: DiaryImage(imagePath: '/images/image-9.png', isLandscape: false),
  ),
  Diary(
    notebookId: 1,
    date: DateTime.now(),
    time: TimeOfDay.now(),
    title: 'Quick Thought',
    content: 'What are your thoughts?',
    image: null,
  ),
];
