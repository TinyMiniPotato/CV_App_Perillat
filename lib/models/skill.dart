class Skill {
  final String label;
  final double level;

  const Skill({required this.label, required this.level});
}

const List<Skill> cvSkills = [
  Skill(label: 'Flutter/Dart', level: 0.95),
  Skill(label: 'Java', level: 0.80),
  Skill(label: 'JavaScript/TypeScript', level: 0.80),
  Skill(label: 'GoLang', level: 0.60),
  Skill(label: 'iOS Swift', level: 0.70),
  Skill(label: 'Android Kotlin', level: 0.70),
  Skill(label: 'Git', level: 0.90),
  Skill(label: 'CI/CD', level: 0.85),
  Skill(label: 'AWS', level: 0.65),
  Skill(label: 'Azure DevOps', level: 0.70),
];
