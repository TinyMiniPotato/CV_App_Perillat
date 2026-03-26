class Experience {
  final String titleKey;
  final String company;
  final String period;
  final String descriptionKey;
  final bool isEducation;

  const Experience({
    required this.titleKey,
    required this.company,
    required this.period,
    required this.descriptionKey,
    this.isEducation = false,
  });
}

const List<Experience> cvExperiences = [
  Experience(
    titleKey: 'gca_title',
    company: 'GCA - Lyon',
    period: 'gca_period',
    descriptionKey: 'gca_description',
  ),
  Experience(
    titleKey: 'myfit_title',
    company: 'MyFit Solutions - Lyon',
    period: '2021 - 2023',
    descriptionKey: 'myfit_description',
  ),
  Experience(
    titleKey: 'liberty_title',
    company: 'Liberty Médical - Paris',
    period: '2019 - 2021',
    descriptionKey: 'liberty_description',
  ),
  Experience(
    titleKey: 'mobile_devices_title',
    company: 'Mobile Devices - Paris',
    period: '2018',
    descriptionKey: 'mobile_devices_description',
  ),
];

const List<Experience> cvEducation = [
  Experience(
    titleKey: 'ecole42_title',
    company: 'ecole42_company',
    period: '2017 - 2019',
    descriptionKey: '',
    isEducation: true,
  ),
  Experience(
    titleKey: 'licence_title',
    company: 'licence_company',
    period: '2013 - 2015',
    descriptionKey: '',
    isEducation: true,
  ),
];
