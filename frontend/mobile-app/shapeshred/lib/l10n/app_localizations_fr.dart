// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ShapeShred';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get orContinueWith => 'Ou continuez avec';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte ?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ?';

  @override
  String get continueAction => 'Continuer';

  @override
  String get skip => 'Passer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get onboardingTitle1 =>
      'Entraînez-vous n\'importe quand, n\'importe où';

  @override
  String get onboardingDesc1 =>
      'Accédez à des entraînements professionnels depuis chez vous avec un coaching en direct.';

  @override
  String get onboardingTitle2 => 'Progression alimentée par l\'IA';

  @override
  String get onboardingDesc2 =>
      'Obtenez des plans personnalisés et des retours instantanés grâce à la technologie intelligente.';

  @override
  String get onboardingTitle3 => 'Connexion directe avec votre coach';

  @override
  String get onboardingDesc3 =>
      'Connectez-vous avec votre coach via des appels vidéo et des tâches quotidiennes.';
}
