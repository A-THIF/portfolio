// 1. DATA MODELS
class ProjectItem {
  final String title;
  final String shortDescription;
  final String fullDescription;
  final String? githubLink;
  final String? linkedinLink;
  final String year;
  final String type;
  final List<String> tags;

  const ProjectItem({
    required this.title,
    required this.shortDescription,
    required this.fullDescription,
    required this.year,
    required this.type,
    required this.tags,
    this.githubLink,
    this.linkedinLink,
  });
}

class ExperienceItem {
  final String role;
  final String company;
  final String duration;
  final String description;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
  });
}

class SkillCategory {
  final String categoryName;
  final List<String> imageAssets;

  const SkillCategory({required this.categoryName, required this.imageAssets});
}

// 2. THE DATA STORE
class PortfolioData {
  // --- BIO SECTION ---
  static const String name = "MOHAMED ATHIF N";
  static const String tagline = "INSPIRE & INFLUENCE";
  static const String profileImage = "assets/images/profile.png";

  // 🔥 ADDED FOOTER YEAR
  static const String footerYear = "Last Update @ 2025";

  static const String aboutMe = """
Hi, I'm Mohamed Athif N — a passionate builder who loves turning ideas into reality.

I’m driven by curiosity, energized by building, and inspired when my work empowers others to learn, innovate, and push boundaries. My fascination with technology has always been two-sided.

On one side, I’m the builder—striving to turn ideas into reality. From crafting IoT prototypes like Peripheral Vision to developing Flutter games and AI-powered tools, I get a thrill from architecting systems, solving problems, and adding creative touches that make each project unique. Implementing what I learn in real life gives me a rush that fuels the next challenge.

On the other side, I’m the innovator with precision. I constantly explore new technologies—from Python, TensorFlow, and OpenCV to microcontrollers, Raspberry Pi, and embedded systems—ensuring that my creations are not just functional but robust, scalable, and thoughtfully engineered. I embrace constraints, iterate fast, and refine until it works flawlessly.
""";

  // --- SOCIAL LINKS ---
  static const String linkedin = "https://www.linkedin.com/in/n-mohamed-athif";
  static const String github = "https://github.com/A-THIF";
  static const String email = "mailto:nmohamedathif@gmail.com";

  // --- EXPERIENCE DATA ---
  static const List<ExperienceItem> experience = [
    ExperienceItem(
      company: "Core Idea Innovations",
      role: "Junior IoT Research & Innovation Engineer Intern",
      duration: "June 2025 – October 2025",
      description:
          "Contributed to the development of IoT prototypes, implemented embedded systems, and integrated hardware with software for real-time data collection and automation.",
    ),
    ExperienceItem(
      company: "Altruisty",
      role: "Frontend Development Intern",
      duration: "Dec 2024 – Feb 2025",
      description:
          "Built a virtual game for entrepreneurs to simulate real-world problems. Maintained web interfaces, responsive UIs, connected APIs, and ensured smooth user experiences.",
    ),
    ExperienceItem(
      company: "CodeSapiens",
      role: "Flutter Mentorship Program",
      duration: "Oct 2024 – Nov 2024",
      description:
          "Gained hands-on experience in building cross-platform mobile apps, learning best practices for Flutter development, state management, and authentication.",
    ),
    ExperienceItem(
      company: "Acmegrade",
      role: "Python and Machine Learning Intern",
      duration: "June 2024 – Aug 2024",
      description:
          "Worked on Python-based projects involving data analysis, machine learning model development, face recognition, and intelligent recommendation systems.",
    ),
  ];

  // --- SKILLS (IMAGES) ---
  static const List<SkillCategory> skills = [
    SkillCategory(
      categoryName: "Programming Languages",
      imageAssets: [
        'assets/skills/c.png',
        'assets/skills/python.png',
        'assets/skills/java.png',
        'assets/skills/dart.png',
        'assets/skills/sql.png',
        'assets/skills/javascript.png',
      ],
    ),
    SkillCategory(
      categoryName: "Backend / Frameworks",
      imageAssets: [
        'assets/skills/django.png',
        'assets/skills/flutter.png',
        'assets/skills/flask.png',
        'assets/skills/firebase.png',
        'assets/skills/supabase.png',
        'assets/skills/sql.png',
      ],
    ),
    SkillCategory(
      categoryName: "Data Science / ML",
      imageAssets: [
        'assets/skills/tensorflow.png',
        'assets/skills/pandas.png',
        'assets/skills/numpy.png',
        'assets/skills/opencv.png',
        'assets/skills/jupyter.png',
      ],
    ),
    SkillCategory(
      categoryName: "Tools / Version Control",
      imageAssets: [
        'assets/skills/vscode.png',
        'assets/skills/github.png',
        'assets/skills/git.png',
        'assets/skills/selenium.png',
        'assets/skills/hugging_face.png',
        'assets/skills/figma.png',
        'assets/skills/filezilla.png',
        'assets/skills/putty.png',
      ],
    ),
    SkillCategory(
      categoryName: "IoT / Hardware",
      imageAssets: [
        'assets/skills/arduino.png',
        'assets/skills/raspberrypi.png',
      ],
    ),
  ];

  // --- PROJECTS DATA ---
  static const List<ProjectItem> projects = [
    ProjectItem(
      title: "Retinoscopy Prototype",
      year: "2025",
      type: "IoT / AI",
      shortDescription: "Python, Flask, Raspberry Pi, Image Processing",
      fullDescription:
          "Developed a Flask application for a Raspberry Pi-based camera system with autofocus and image processing, used for medical vision assessments.",
      tags: ["Python", "Flask", "Raspberry Pi", "OpenCV"],
      githubLink: "https://github.com/A-THIF/retinoscopy-prototype",
    ),
    ProjectItem(
      title: "Conversational AI Agent",
      year: "2025",
      type: "AI",
      shortDescription: "Python, API Integration, Hugging Face, Terminal UI",
      fullDescription:
          "A lightweight conversational AI agent built using Hugging Face’s free Inference API. Users can interact with the agent via a terminal interface. Focused on exploring API integration, prompt engineering, and context retention.",
      tags: ["Python", "Hugging Face", "API", "AI"],
      githubLink: "https://github.com/A-THIF/Conversational-AI-Free-APIs",
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_github-a-thifconversational-ai-free-apis-activity-7307135743888433153-0esu",
    ),
    ProjectItem(
      title: "Peripheral Vision Training",
      year: "2025",
      type: "Web",
      shortDescription: "Python, Django, HTML, CSS, JavaScript",
      fullDescription:
          "A web-based application to test and train peripheral vision through interactive exercises, built with Django. Includes customizable speed and duration settings for Testing and Training modes.",
      tags: ["Django", "Python", "Web", "Frontend"],
      githubLink: "https://github.com/A-THIF/peripheral_vision",
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_hackathon-teamwork-machinelearning-activity-7314121014227976192-iD-w",
    ),
    ProjectItem(
      title: "Startup Crisis Game",
      year: "2025",
      type: "Web Game",
      shortDescription: "Django, Python, HTML, CSS, JS",
      fullDescription:
          "A web application game designed to simulate entrepreneurial challenges for startup teams. Helps users make strategic decisions in a gamified environment.",
      tags: ["Django", "Game Dev", "Web"],
      githubLink: "https://github.com/A-THIF/Startup_crisis",
    ),
    ProjectItem(
      title: "Tailor Todo",
      year: "2024",
      type: "App",
      shortDescription: "Flutter, Dart, Firebase, Supabase",
      fullDescription:
          "A Flutter To-Do app integrating Supabase for backend, Firebase for messaging, and local notifications for real-time task reminders.",
      tags: ["Flutter", "Supabase", "Firebase", "Dart"],
      githubLink: "https://github.com/A-THIF/tailor_todo",
    ),
    ProjectItem(
      title: "Basti Ki Pathshala App",
      year: "2024",
      type: "App",
      shortDescription: "Flutter, Dart, Forms, UI Design",
      fullDescription:
          "A cross-platform Flutter app allowing users to learn about the foundation and submit volunteer information. Features navigation, forms, and feedback mechanisms.",
      tags: ["Flutter", "Dart", "UI/UX", "Social Impact"],
      githubLink: "https://github.com/A-THIF/flutter_ngo_volunteer_app",
    ),
    ProjectItem(
      title: "Fundraising Intern Portal",
      year: "2024",
      type: "App",
      shortDescription: "Flutter, Dart, UI/UX",
      fullDescription:
          "A UI prototype for a fundraising intern portal, demonstrating screen flow, state management, and local mock storage in Flutter.",
      tags: ["Flutter", "Dart", "Prototype"],
      githubLink:
          "https://github.com/A-THIF/she_can_foundation_fundraising_portal",
    ),
    ProjectItem(
      title: "Space Snake",
      year: "2024",
      type: "Game",
      shortDescription:
          "Skills: Flutter, Dart, CustomPainter, Gesture Controls",
      fullDescription:
          "A modern, offline remake of the classic Snake game with gesture controls, dynamic graphics, and smooth Flutter animations. Focused on intuitive gameplay and visual design.",
      tags: ["Flutter", "Game Dev", "CustomPainter"],
      githubLink: "https://github.com/A-THIF/Snake_Game_Flutter",
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_flutter-gamedev-opensource-activity-7347347106250092545-RaLD",
    ),
    ProjectItem(
      title: "To Do App",
      year: "2024",
      type: "App",
      shortDescription: "Flutter, Dart, Firebase, Firestore",
      fullDescription:
          "A Flutter-based To-Do List application with Firebase Authentication and Firestore Database. Users can sign up, manage tasks, and store data securely per account.",
      tags: ["Flutter", "Firebase", "Cloud Firestore"],
      githubLink: "https://github.com/A-THIF/to_do_app",
    ),
    ProjectItem(
      title: "Terminal Snake Game",
      year: "2024",
      type: "Game",
      shortDescription: "Python, Game Development",
      fullDescription:
          "A classic Snake game implemented for Windows terminal with progressive difficulty, high score tracking, and dual controls (WASD/Arrow Keys).",
      tags: ["Python", "CLI", "Game Dev"],
      githubLink: "https://github.com/A-THIF/Snake-Game-Terminal",
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_warpai-terminal-coding-activity-7330598642526965762-gWL0",
    ),
    ProjectItem(
      title: "Peripheral Vision (Sports)",
      year: "2024",
      type: "IoT / Hardware",
      shortDescription: "Raspberry Pi, Python, Computer Vision, Hardware",
      fullDescription:
          "An automated peripheral vision testing system for athletes using Raspberry Pi, Pi Camera, and LED arrays for accurate and consistent assessment.",
      tags: ["Raspberry Pi", "Python", "Computer Vision"],
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_sportsvision-innovation-raspberrypi-activity-7362873953469546497-LLLr",
    ),
    ProjectItem(
      title: "EnvisionCAP Smart Hat",
      year: "2024",
      type: "IoT / Wearable",
      shortDescription: "Arduino, Bluetooth, IoT, Ultrasonic Sensor",
      fullDescription:
          "A wearable smart hat that detects obstacles using sensors and alerts users via Bluetooth-connected smartphone with text-to-speech. Focused on accessibility and assistive technology.",
      tags: ["Arduino", "IoT", "Bluetooth", "Assistive Tech"],
      linkedinLink:
          "https://www.linkedin.com/posts/n-mohamed-athif_throwback-envisioncap-innovationjourney-activity-7316201672433618945-fGys",
    ),
    ProjectItem(
      title: "Envision App",
      year: "2024",
      type: "App / IoT",
      shortDescription: "Flutter, Dart, Bluetooth, IoT",
      fullDescription:
          "A Flutter app for the Envision Cap project, receiving distance data from an ultrasonic sensor via Bluetooth and alerting the user via speech and vibration.",
      tags: ["Flutter", "Bluetooth", "IoT"],
      githubLink: "https://github.com/A-THIF/Envision_app",
    ),
    ProjectItem(
      title: "Acmegrade Projects Repo",
      year: "2024",
      type: "ML / AI",
      shortDescription: "Python, Machine Learning, OpenCV",
      fullDescription:
          "Contains Python and Machine Learning projects completed during a 6-month internship, including music selection and face recognition with OpenCV.",
      tags: ["Python", "ML", "OpenCV"],
      githubLink:
          "https://github.com/A-THIF/Acmedrage_Training_Internhips_Repo",
    ),
  ];

  // --- LEADERSHIP & VOLUNTEERING ---
  static const List<ExperienceItem> leadership = [
    ExperienceItem(
      role: "IEEE Coordinator",
      company: "College IEEE Branch",
      duration: "2023 – Present",
      description:
          "Supported the organization of workshops, seminars, and technical events. Contributed to student engagement and smooth event operations. Conducted 40+ technical and non-technical events successfully.",
    ),
    ExperienceItem(
      role: "YRC Volunteer",
      company: "Youth Red Cross",
      duration: "2023 – Present",
      description:
          "Participated in cyber rally and social initiatives. Engaged in community outreach programs promoting welfare across campus.",
    ),
    ExperienceItem(
      role: "Core Team Member",
      company: "AI Geeks Chennai",
      duration: "2025 – Present",
      description:
          "Assisted in organizing AI meetups and community-driven tech events. Handled coordination, planning, and on-ground execution.",
    ),
  ];
}
