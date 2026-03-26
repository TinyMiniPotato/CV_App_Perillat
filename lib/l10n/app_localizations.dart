import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'fr': {
      'app_title': 'Mon Application',
      'cv_tab': 'CV',
      'widgets_tab': 'Widgets',
      'dark_mode': 'Mode Sombre',
      'language': 'Langue',
      'contact': 'Contact',
      'skills': 'Compétences',
      'experience': 'Expériences professionnelles',
      'education': 'Formations',
      'gca_title': 'Développeur Mobile / Full-Stack',
      'gca_period': 'Depuis octobre 2024',
      'gca_description':
          'Reprise et amélioration d\'applications Flutter • Mise en place de CI/CD et pratiques DevOps • Développement Front & Back • Collaboration avec les équipes produit et design',
      'myfit_title': 'Développeur Mobile / Service',
      'myfit_description':
          'Création, déploiement et maintien de multiples applications mobiles • Gestion des environnements clients sur AWS • Projet Mturk (application + backend)',
      'liberty_title': 'Développeur Mobile',
      'liberty_description':
          'Maintenance d\'application mobile sur les stores • Formation et accompagnement d\'un stagiaire • Support client technique (SAV)',
      'mobile_devices_title': 'Stagiaire Développeur Mobile',
      'mobile_devices_description':
          'Découverte et apprentissage de Flutter • Mise en place d\'un CI/CD avec GitLab • Travail en équipe internationale (anglais)',
      'ecole42_title': 'Formation Ingénieur (cursus abrégé après embauche)',
      'ecole42_company': 'Ecole 42 - Paris',
      'licence_title': 'Licence Math-Info (cursus interrompu)',
      'licence_company': 'Université Aix-Marseille',
      'widgets_title': 'Exemples de Widgets Flutter',
      'buttons': 'Boutons',
      'switches': 'Interrupteurs',
      'radio': 'Radio Buttons',
      'option': 'Option',
      'slider': 'Slider',
      'cards': 'Cards',
      'card_description': 'Ceci est un exemple de Card avec élévation',
      'list_tiles': 'List Tiles',
      'home': 'Accueil',
      'settings': 'Paramètres',
      'settings_subtitle': 'Configurer l\'application',
      'about': 'À propos',
      'chips': 'Chips',
      'job_title': 'Développeur Mobile & Full-Stack',
      'export_pdf': 'Exporter en PDF',
    },
    'en': {
      'app_title': 'My Application',
      'cv_tab': 'CV',
      'widgets_tab': 'Widgets',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'contact': 'Contact',
      'skills': 'Skills',
      'experience': 'Professional Experience',
      'education': 'Education',
      'gca_title': 'Mobile / Full-Stack Developer',
      'gca_period': 'Since October 2024',
      'gca_description':
          'Takeover and improvement of Flutter mobile apps • CI/CD and DevOps implementation • Front & Back development • Collaboration with product and design teams',
      'myfit_title': 'Mobile / Service Developer',
      'myfit_description':
          'Creation, deployment and maintenance of multiple mobile apps • AWS client environment management • Mturk project (app + backend)',
      'liberty_title': 'Mobile Developer',
      'liberty_description':
          'Maintenance of mobile app on stores • Intern training and mentoring • Technical customer support',
      'mobile_devices_title': 'Mobile Developer Intern',
      'mobile_devices_description':
          'Discovery and learning of Flutter • CI/CD setup with GitLab • International team work (English)',
      'ecole42_title': 'Engineering Degree (shortened after hiring)',
      'ecole42_company': 'School 42 - Paris',
      'licence_title': 'Bachelor Math-Info (interrupted)',
      'licence_company': 'Aix-Marseille University',
      'widgets_title': 'Flutter Widget Examples',
      'buttons': 'Buttons',
      'switches': 'Switches',
      'radio': 'Radio Buttons',
      'option': 'Option',
      'slider': 'Slider',
      'cards': 'Cards',
      'card_description': 'This is an example of a Card with elevation',
      'list_tiles': 'List Tiles',
      'home': 'Home',
      'settings': 'Settings',
      'settings_subtitle': 'Configure the application',
      'about': 'About',
      'chips': 'Chips',
      'job_title': 'Mobile & Full-Stack Developer',
      'export_pdf': 'Export as PDF',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['fr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
