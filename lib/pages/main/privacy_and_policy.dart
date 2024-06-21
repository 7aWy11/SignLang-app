import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static String routName = 'privacy_and_policy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Privacy Policey',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8A56AC),
                  ),
                ),
                SizedBox(height: 70),
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
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A56AC),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
