import 'package:flutter/material.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';

import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {

  String termsAndConditions = '';

  void getTermsAndConditions() async {
    DioClient _dioClient = DioClient();
     final response = await _dioClient.get(path: Endpoints.termsAndConditionsEP);

     if (response.statusCode == 200) {
        setState(() {
          termsAndConditions = response.data['data']['Terms_And_Conditions'];
          print(termsAndConditions);
        });
     }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTermsAndConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Terms and Conditions',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
        ),
        //color back icon
        iconTheme: IconThemeData(
          color: Colors.black
        ),

      ),
      body: HtmlContentViewer(
        htmlContent: termsAndConditions.toString(),
      )
    );
  }
}
