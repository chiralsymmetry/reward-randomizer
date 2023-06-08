import 'package:flutter/material.dart';
import 'package:reward_randomizer/utils/icons.dart';
import 'package:reward_randomizer/widgets/default_page.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const kWebsite = "https://github.com/chiralsymmetry/reward-randomizer";

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.pageAboutAppBarTitle),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: DefaultPage(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(AppLocalizations.of(context)!.pageAboutAppDescription),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!
                        .pageAboutIntermittentRewardsTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(AppLocalizations.of(context)!
                      .pageAboutIntermittentRewardsExplanation),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.pageAboutContactTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(AppLocalizations.of(context)!.pageAboutContactText),
                  TextButton.icon(
                    onPressed: () {
                      errorSnack() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .pageAboutContactError),
                          ),
                        );
                      }

                      final Uri url = Uri.parse(kWebsite);

                      canLaunchUrl(url).then((canLaunch) {
                        if (canLaunch) {
                          try {
                            launchUrl(url).then((launched) {
                              if (!launched) {
                                errorSnack();
                              }
                            });
                          } on PlatformException {
                            errorSnack();
                          }
                        } else {}
                      });
                    },
                    icon: AppIcons.aboutWebsite,
                    label: Text(
                      kWebsite,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontFamily: "monospace"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!
                        .pageAboutThirdPartyLicensesTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(AppLocalizations.of(context)!
                      .pageAboutThirdPartyLicensesExplanation),
                  const SizedBox(height: 16),
                  SizedBox(
                      width: double.infinity,
                      child: FutureBuilder(
                        future:
                            rootBundle.loadString('THIRD_PARTY_LICENSES.md'),
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _processLicenseFile(
                                  snapshot.data as String, ctx),
                            );
                          } else {
                            return Text(AppLocalizations.of(context)!
                                .pageAboutProcessingLoading);
                          }
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

List<Widget> _processLicenseFile(
    String licenseFileContents, BuildContext context) {
  final output = <Widget>[];
  licenseFileContents = licenseFileContents.replaceAll("\r\n", "\n");
  const licenseDivider =
      "\n\n--------------------------------------------------------------------------------\n";
  final softwares = licenseFileContents.split(licenseDivider);
  for (int i = 0; i < softwares.length; i++) {
    final software = softwares[i];
    final parts = software.split("\n\n");
    if (parts.length < 2) {
      output.clear();
      output.add(Text(AppLocalizations.of(context)!.pageAboutProcessingError));
      break;
    }
    final softwareNames = parts[0].trim().split("\n");
    final String softwareLicense;
    if (parts.length == 2) {
      softwareLicense = parts[1].trim();
    } else {
      softwareLicense = parts.sublist(1).join("\n\n").trim();
    }
    for (final softwareName in softwareNames) {
      output.add(Text(softwareName.trim(),
          style: Theme.of(context).textTheme.headlineSmall));
    }
    output.add(Text(
      softwareLicense.trim(),
      textAlign: TextAlign.left,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontFamily: "monospace"),
    ));
    if (i < softwares.length - 1) {
      output.add(const Divider());
    }
  }
  return output;
}
