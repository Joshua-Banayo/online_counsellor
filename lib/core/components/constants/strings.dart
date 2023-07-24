import 'package:online_counsellor/generated/assets.dart';

const String emailReg =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

const regionList = [
  'Greater Accra',
  'Ashanti Region',
  'Western Region',
  'Eastern Region',
  'Central Region',
  'Volta Region',
  'Northern Region',
  'Upper East',
  'Upper West',
  'Bono Region',
  'Bono East',
  'Ahafo Region',
  'Oti Region',
  'Savannah Region',
  'North East',
];

const counsellorTypeList = [
  'psychologist',
  'Marriage Counsellor',
  'Students\' Counsellor',
  'Career Counsellor',
  'Family Counsellor',
  'Addiction Counsellor',
  'Mental Health Counsellor',
  'Grief Counsellor',
  'Rehabilitation Counsellor',
  'Guidance Counsellor',
  'Child Counsellor',
];

const List<Map<String, dynamic>> reviews = [
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  },
  {
    "name": "John Doe",
    "review":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nisi eget nunc ultricies aliquet. Sed vitae nisi eget nunc ultricies aliquet.",
    "rating": 4.5
  }
];

const counsellorTypeWithIcon = [
  {"name": 'psychologist', "icon": Assets.imagesPsychologist},
  {"name": 'Marriage Counsellor', "icon": Assets.imagesMarriage},
  {"name": 'Students\' Counsellor', "icon": Assets.imagesStudent},
  {"name": 'Career Counsellor', "icon": Assets.imagesCareer},
  {"name": 'Family Counsellor', "icon": Assets.imagesFamily},
  {"name": 'Addiction Counsellor', "icon": Assets.imagesAddiction},
  {"name": 'Mental Health Counsellor', "icon": Assets.imagesMentalHealth},
  {"name": 'Grief Counsellor', "icon": Assets.imagesGrief},
  {"name": 'Rehabilitation Counsellor', "icon": Assets.imagesRehabilitation},
  {"name": 'Guidance Counsellor', "icon": Assets.imagesGuidance},
  {"name": 'Child Counsellor', "icon": Assets.imagesChild},
];

const counsellingTopicCategory = [
  'Marriage',
  'Relationship',
  'Family',
  'Career',
  'Addiction',
  'Mental Health',
  'Grief',
  'Rehabilitation',
  'Guidance',
  'Child',
];
