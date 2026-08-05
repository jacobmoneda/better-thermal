import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _sourceUrl = 'https://github.com/simonwep/better-thermal';
const _sponsorsUrl = 'https://github.com/sponsors/simonwep';

class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  late final Future<PackageInfo> _packageInfo;
  late final TapGestureRecognizer _sponsorsRecognizer;
  late final TapGestureRecognizer _sourceRecognizer;

  @override
  void initState() {
    super.initState();
    _packageInfo = PackageInfo.fromPlatform();
    _sponsorsRecognizer = TapGestureRecognizer()
      ..onTap = () => _openUrl(_sponsorsUrl);
    _sourceRecognizer = TapGestureRecognizer()
      ..onTap = () => _openUrl(_sourceUrl);
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _sponsorsRecognizer.dispose();
    _sourceRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        spacing: 12,
        mainAxisAlignment: .end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(fontWeight: .bold),
                children: [
                  const TextSpan(text: 'Build by Simon with ❤️ - consider '),
                  TextSpan(
                    text: 'supporting me ',
                    style: TextStyle(color: colorScheme.primary),
                    recognizer: _sponsorsRecognizer,
                  ),
                  const TextSpan(text: ' if you like this app!'),
                ],
              ),
            ),
          ),
          Center(
            child: FutureBuilder<PackageInfo>(
              future: _packageInfo,
              builder: (context, snapshot) {
                final buildLabel = snapshot.hasData
                    ? 'Build ${snapshot.data!.version} '
                          '(${snapshot.data!.buildNumber}) · '
                    : 'Build · ';

                return Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(text: buildLabel),
                      TextSpan(
                        text: 'View on GitHub',
                        style: TextStyle(color: colorScheme.primary),
                        recognizer: _sourceRecognizer,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
