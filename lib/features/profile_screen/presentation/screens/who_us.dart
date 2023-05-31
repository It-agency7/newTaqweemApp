import 'package:flutter/material.dart';
import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';

import '../../../../core/client/dio_client.dart';
import '../../../../core/client/endpoints.dart';

class WhoUs extends StatefulWidget {
  const WhoUs({Key? key}) : super(key: key);

  @override
  State<WhoUs> createState() => _WhoUsState();
}

class _WhoUsState extends State<WhoUs> {

  String whoUs = '';

  void getWhoUs() async {
    DioClient _dioClient = DioClient();
    final response = await _dioClient.get(path: Endpoints.applicationData);

    if (response.statusCode == 200) {
      setState(() {
        whoUs = response.data['data']['who'];
        print(whoUs);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWhoUs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Who Us',
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
          htmlContent: whoUs.toString(),
        )
    );
  }
}
