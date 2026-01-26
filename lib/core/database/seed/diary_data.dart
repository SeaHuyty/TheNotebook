import 'package:flutter/material.dart';
import 'package:the_notebook/core/models/diary.dart';
import 'package:the_notebook/core/models/diary_image.dart';
import 'package:the_notebook/core/models/tag.dart';
import 'package:the_notebook/core/models/task.dart';

final sampleDiaries = [
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 11, 15),
    time: TimeOfDay(hour: 14, minute: 30),
    title: 'Starting My Diary Journey',
    tags: [TagModel(name: 'programming'), TagModel(name: 'development')],
    content:
        'Started working on my diary app today. Excited to see where this journey takes me!',
    images: [DiaryImageModel(imagePath: '/images/image-1.png', isLandscape: false)],
    tasks: [
      TaskModel(
        title: "Complete project proposal",
        isCompleted: false,
        subtasks: [
          TaskModel(title: "Write introduction", isCompleted: false),
          TaskModel(title: "Make diagrams", isCompleted: false),
          TaskModel(title: "Review with team", isCompleted: false),
        ],
      ),
    ],
  ),

  // November 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 11, 8),
    time: TimeOfDay(hour: 9, minute: 15),
    title: 'Thanksgiving Prep',
    tags: [TagModel(name: 'gratitude'), TagModel(name: 'family')],
    content:
        'Thanksgiving preparations begin. Grateful for all the wonderful people in my life.',
    images: null,
    tasks: [
      TaskModel(
        title: "Complete project proposal",
        isCompleted: false,
        subtasks: [
          TaskModel(title: "Write introduction", isCompleted: false),
          TaskModel(title: "Make diagrams", isCompleted: false),
          TaskModel(title: "Review with team", isCompleted: false),
        ],
      ),
    ],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 11, 3),
    time: TimeOfDay(hour: 16, minute: 45),
    title: 'Autumn Walk',
    tags: [TagModel(name: 'nature'), TagModel(name: 'autumn')],
    content:
        'Fall colors are at their peak. Took a long walk to capture the beautiful scenery.',
    images: [DiaryImageModel(imagePath: '/images/image-2.png', isLandscape: false)],
  ),

  // October 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 10, 28),
    time: TimeOfDay(hour: 20, minute: 30),
    title: 'Halloween Party Night',
    tags: [TagModel(name: 'party'), TagModel(name: 'celebration')],
    content:
        'Halloween party was amazing! My costume was a hit and I got so much candy.',
    images: [DiaryImageModel(imagePath: '/images/image-3.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 10, 5),
    time: TimeOfDay(hour: 11, minute: 20),
    title: 'Beautiful October Day',
    tags: [TagModel(name: 'autumn'), TagModel(name: 'nature')],
    content:
        'October starts with beautiful autumn colors everywhere. Nature is incredible.',
    images: [DiaryImageModel(imagePath: '/images/image-4.png', isLandscape: false)],
  ),

  // September 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 9, 24),
    time: TimeOfDay(hour: 13, minute: 15),
    title: 'Beach Day with Friends',
    tags: [TagModel(name: 'beach'), TagModel(name: 'friends'), TagModel(name: 'summer')],
    content:
        'Beach day with friends! The weather was perfect and we played volleyball all day.',
    images: [DiaryImageModel(imagePath: '/images/image-5.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 9, 3),
    time: TimeOfDay(hour: 17, minute: 0),
    title: 'Labor Day Barbecue',
    tags: [TagModel(name: 'community'), TagModel(name: 'food')],
    content:
        'Labor Day barbecue with neighbors. Amazing how food brings people together.',
    images: [DiaryImageModel(imagePath: '/images/image-6.png', isLandscape: false)],
  ),

  // August 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 8, 20),
    time: TimeOfDay(hour: 10, minute: 45),
    title: 'Epic Road Trip',
    tags: [TagModel(name: 'travel'), TagModel(name: 'adventure')],
    content:
        'Summer vacation road trip! Visited three states and made incredible memories.',
    images: [DiaryImageModel(imagePath: '/images/image-7.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 8, 1),
    time: TimeOfDay(hour: 12, minute: 0),
    title: 'Family Reunion',
    tags: [TagModel(name: 'family'), TagModel(name: 'reunion')],
    content:
        'August begins with a family reunion. Cousins I haven\'t seen in years!',
    images: [DiaryImageModel(imagePath: '/images/image-8.png', isLandscape: false)],
  ),

  // July 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 7, 25),
    time: TimeOfDay(hour: 21, minute: 30),
    title: 'Mountain Camping Trip',
    tags: [TagModel(name: 'camping'), TagModel(name: 'adventure'), TagModel(name: 'nature')],
    content:
        'Camping trip in the mountains. Sleeping under the stars was magical.',
    images: [DiaryImageModel(imagePath: '/images/image-9.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 7, 4),
    time: TimeOfDay(hour: 20, minute: 15),
    title: 'Independence Day',
    tags: [TagModel(name: 'celebration'), TagModel(name: 'friends')],
    content:
        'Independence Day celebration with fireworks and good friends. Perfect evening!',
    images: [DiaryImageModel(imagePath: '/images/image-10.png', isLandscape: false)],
  ),

  // June 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 6, 28),
    time: TimeOfDay(hour: 14, minute: 0),
    title: 'Course Graduation',
    tags: [TagModel(name: 'achievement'), TagModel(name: 'education')],
    content: 'Graduated from my online course! Hard work finally paid off.',
    images: [DiaryImageModel(imagePath: '/images/image-11.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 6, 8),
    time: TimeOfDay(hour: 16, minute: 10),
    title: 'Garden Success',
    tags: [TagModel(name: 'gardening'), TagModel(name: 'nature')],
    content:
        'Garden is blooming beautifully. My first attempt at growing vegetables succeeded!',
    images: [DiaryImageModel(imagePath: '/images/image-12.png', isLandscape: false)],
  ),

  // May 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 5, 30),
    time: TimeOfDay(hour: 11, minute: 45),
    title: 'Lake Getaway',
    tags: [TagModel(name: 'weekend'), TagModel(name: 'relaxation')],
    content:
        'Memorial Day weekend getaway to the lake. Peaceful and refreshing.',
    images: [DiaryImageModel(imagePath: '/images/image-13.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 5, 10),
    time: TimeOfDay(hour: 18, minute: 45),
    title: "Mom's Birthday",
    tags: [
      TagModel(name: 'birthday'),
      TagModel(name: 'family'),
      TagModel(name: 'celebration')
    ],
    content:
        'Mom\'s birthday celebration. Made her favorite cake from scratch.',
    images: [DiaryImageModel(imagePath: '/images/image-1.png', isLandscape: false)],
  ),

  // April 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 4, 25),
    time: TimeOfDay(hour: 13, minute: 20),
    title: 'Cherry Blossoms',
    tags: [TagModel(name: 'spring'), TagModel(name: 'nature')],
    content:
        'Cherry blossoms are in full bloom. Spring has officially arrived!',
    images: [DiaryImageModel(imagePath: '/images/image-2.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 4, 5),
    time: TimeOfDay(hour: 11, minute: 0),
    title: 'Easter Brunch',
    tags: [TagModel(name: 'celebration'), TagModel(name: 'family')],
    content:
        'Easter brunch with family. Traditional recipes and new memories made.',
    images: [DiaryImageModel(imagePath: '/images/image-3.png', isLandscape: false)],
  ),

  // March 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 3, 28),
    time: TimeOfDay(hour: 9, minute: 30),
    title: 'Spring Break Coast Trip',
    tags: [TagModel(name: 'travel'), TagModel(name: 'beach')],
    content:
        'Spring break trip to the coast. Ocean waves and sea breeze were therapeutic.',
    images: [DiaryImageModel(imagePath: '/images/image-4.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 3, 8),
    time: TimeOfDay(hour: 14, minute: 15),
    title: "Women's Day",
    tags: [TagModel(name: 'inspiration'), TagModel(name: 'celebration')],
    content:
        'International Women\'s Day. Celebrated amazing women who inspire me daily.',
    images: [DiaryImageModel(imagePath: '/images/image-5.png', isLandscape: false)],
  ),

  // February 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 2, 14),
    time: TimeOfDay(hour: 19, minute: 30),
    title: "Valentine's Day Dinner",
    tags: [TagModel(name: 'love'), TagModel(name: 'celebration')],
    content:
        'Valentine\'s Day dinner with my partner. Simple moments are the most precious.',
    images: [DiaryImageModel(imagePath: '/images/image-6.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 2, 5),
    time: TimeOfDay(hour: 10, minute: 30),
    title: 'Snow Day Fun',
    tags: [TagModel(name: 'winter'), TagModel(name: 'fun')],
    content: 'Snow day! Built a snowman and had hot cocoa by the fireplace.',
    images: [DiaryImageModel(imagePath: '/images/image-7.png', isLandscape: false)],
  ),

  // January 2025
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 1, 15),
    time: TimeOfDay(hour: 6, minute: 30),
    title: 'Fitness Journey Begins',
    tags: [TagModel(name: 'fitness'), TagModel(name: 'health'), TagModel(name: 'goals')],
    content:
        'Started my fitness journey today. Small steps toward a healthier lifestyle.',
    images: [DiaryImageModel(imagePath: '/images/image-8.png', isLandscape: false)],
  ),
  DiaryModel(
    notebookId: 1,
    date: DateTime(2025, 1, 1),
    time: TimeOfDay(hour: 0, minute: 0),
    title: 'New Year 2025',
    tags: [TagModel(name: 'newyear'), TagModel(name: 'goals'), TagModel(name: 'celebration')],
    content:
        'New Year, new possibilities! Set meaningful resolutions for 2025.',
    images: [DiaryImageModel(imagePath: '/images/image-9.png', isLandscape: false)],
  ),
];
