import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static String routeName = 'privacy_and_policy';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * (16 / 360)),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (35 / 360),
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8A56AC),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (10 / 800)),
                  Text(
                    '1. Proprietary (Closed Source) License:\n'
                        '- Closed source, users can\'t view or modify the code.\n'
                        '- Typically involves purchasing a license.\n\n'
                        '2. Open Source License:\n'
                        '- Source code is public, allowing users to view, modify, and distribute it.\n'
                        '- Examples include MIT License, GPL, Apache License.\n\n'
                        '3. Freeware:\n'
                        '- Free to use but may have usage restrictions.\n\n'
                        '4. Shareware:\n'
                        '- Trial software with an option to purchase for full use.\n\n'
                        '5. Commercial License:\n'
                        '- Purchased for commercial use, terms vary.\n\n'
                        '6. Creative Commons License:\n'
                        '- Used for creative works, specifies permissions for sharing, modification, and commercial use.\n',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (16 / 360),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * (10 / 800)),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8A56AC),
                      padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * (50 / 360),
                        vertical: MediaQuery.of(context).size.height * (15 / 800),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * (25 / 360)),
                      ),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * (18 / 360),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
