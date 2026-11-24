// Données FICTIVES utilisées par l'application.

class Profil {
  static const nom = 'AKONKWA SIRINGI Joseph';
  static const titre = 'Étudiant en informatique – Développeur mobile Flutter';
  static const photo = 'assets/images/joseph.png';
  static const resume =
      'Étudiant passionné par le développement mobile et web, motivé, '
      'curieux et rigoureux. À la recherche d\'un stage pour mettre en '
      'pratique mes compétences et continuer à apprendre.';
}

class Formation {
  final String diplome, etablissement, periode;
  const Formation(this.diplome, this.etablissement, this.periode);
}

const formations = [
  Formation('Licence 3 en Informatique gestion appliqué à la gestion des entreprise',
      'Institut superieur d \'informatique et de gestion/ISIG-GOMA', '2024 – 2026'),
  Formation('Certificat Développement mobile Flutter et web avec PHP/Lqrqvel',
      'Centre de formation proffessionnel/CFPI-ISIG', '2025'),
  Formation('Diplôme d\'État – Option Pédagogie',
      'Institut technique de Kinshasa', '2018 – 2024'),
];

class Experience {
  final String titre, lieu, periode, description;
  const Experience(this.titre, this.lieu, this.periode, this.description);
}

const experiences = [
  Experience(
      'Stagiaire développeur mobile',
      'TechKin SARL, Kinshasa',
      'Juillet – Août 2025',
      'Développement de fonctionnalités d\'une application Flutter de suivi de livraisons.'),
  Experience(
      'Projet : Gestion de stock et ventes',
      'Projet universitaire',
      '2025 – 2026',
      'Application web de gestion de stock avec ventes, factures et export PDF/Excel.'),
  Experience(
      'Assistant informatique (job étudiant)',
      'Cybercafé Le Savoir, Kinshasa',
      '2023 – 2024',
      'Maintenance des postes, assistance aux clients et saisie de documents.'),
];

const competencesTechniques = {
  'Flutter / Dart': 0.8,
  'HTML / CSS / JavaScript': 0.75,
  'PHP / MySQL': 0.65,
  'Git / GitHub': 0.7,
  'Python': 0.55,
};

const langues = {
  'Français': 'Langue maternelle',
  'Lingala': 'Langue nationnale',
  'Anglais': 'Niveau avancé',
  'Swahili': 'Niveau très avancé',
};

const centresInteret = [
  'Programmation',
  'Football',
  'Musique',
  'Lecture',
  'Jeux d\'échecs',
  'Bénévolat',
];

class Contacts {
  static const telephone = '+243 813875830';
  static const email = 'Joseph@gmail.com';
  static const adresse = 'Avenue de la Paix 12, Commune de Goma, Goma, RDC';
  static const linkedin = 'https://www.linkedin.com/in/Joseph';
  static const github = 'https://github.com/josephsiringi';
  static const facebook = 'https://www.facebook.com/joseph';
}
