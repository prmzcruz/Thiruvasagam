import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thiruvasagam/UI/MainScree.dart';
import 'package:thiruvasagam/UI/contentPage.dart';
import 'package:thiruvasagam/model/modelclass.dart';
import 'package:path_provider/path_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<Location> locations = [];
  List<String> locationNames = [];

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  Future<void> loadJsonData() async {
    String data = await rootBundle.loadString('assets/locations.json');
    List<dynamic> jsonList = json.decode(data);

    if (jsonList.isNotEmpty) {
      setState(() {
        locations = jsonList.map((json) => Location.fromJson(json)).toList();

        locationNames = locations.map((location) => location.name).toList();
        print('Location Names: $locationNames');

        print('locations---$locations');
        String name =locations[0].name;
        print('name===$name');
      });
    }
  }

  Widget _buildStylishDrawer() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                //borderRadius: BorderRadius.circular(25.0,),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepOrangeAccent,
                      backgroundImage: AssetImage('assets/Sivavasagam.jpeg'),
                      radius: 50,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'திருவாசகம்',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
            Container(
              child: ListTile(
                leading: Icon(Icons.home,
                    color: Colors.deepOrangeAccent,),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading:
              Icon(Icons.details, color: Colors.deepOrangeAccent,),
              title: const Text(
                'About',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading:
              Icon(Icons.language, color: Colors.deepOrangeAccent,),
              title: const Text(
                'Language',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LanguagePickerDialog(),
                );

              },
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.phone,
                  color: Colors.deepOrangeAccent,),
              title: Text(
                'Contact',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // onTap: () {
              //   Navigator.pop(context); // Close drawer if opened
              //   _showNotificationsSheet(context); // Show notifications sheet
              // },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.calendar_month,
                  color: Colors.deepOrangeAccent,),
              title: const Text(
                'Calendar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () async{
                // Show date picker with customized theme
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Set the initial date to the current date
                  firstDate: DateTime(2000),   // Set the earliest date the user can pick
                  lastDate: DateTime(2101),    // Set the latest date the user can pick
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.deepOrange, // Header background color
                        colorScheme: ColorScheme.light(
                          primary: Colors.deepOrange,    // Selection color
                          onPrimary: Colors.white,       // Text color on selected date
                          surface: Colors.deepOrangeAccent, // Background for header
                        ),
                        buttonTheme: ButtonThemeData(
                          textTheme: ButtonTextTheme.primary, // Text color for buttons
                        ),
                      ),
                      child: child!,
                    );
                  },
                );

                // Handle the selected date (if a date was picked)
                if (selectedDate != null) {
                  print('Selected date: ${selectedDate.toLocal()}');
                }

                // Close the drawer (or whatever action you want after selecting the date)
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.share,
                  color: Colors.deepOrangeAccent,),
              title: const Text(
                'Share ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () async{
                // Application link
                String appLink = 'https://play.google.com/store/apps/details?id=com.sivavasakam.shivam';

                // Logo file path
                String logoPath = 'assets/Sivavasagam.jpeg'; // Assuming this is your asset file

                // First, copy the logo from the assets to a temporary directory so it can be shared
                final tempDir = await getTemporaryDirectory();
                final tempLogoFile = File('${tempDir.path}/Sivavasagam.jpeg');

                // Read the logo asset and write to the temporary directory
                final byteData = await DefaultAssetBundle.of(context).load(logoPath);
                await tempLogoFile.writeAsBytes(byteData.buffer.asUint8List());

                // Convert the file to XFile
                XFile logoFile = XFile(tempLogoFile.path);

                // Sharing content
                Share.shareXFiles([logoFile],
                    text: 'Check out this awesome app: $appLink');

                // Close the dialog after sharing
                Navigator.pop(context);
                //Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.policy,
                  color: Colors.deepOrangeAccent,),
              title: const Text(
                'Privacy policy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.book_rounded,
                  color: Colors.deepOrangeAccent,),
              title: const Text(
                'Uzhavar pani',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Notifications section
            const Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      child: Scaffold(
        drawer: _buildStylishDrawer(),
        backgroundColor: Colors.deepOrangeAccent,
        body: Column(
          children: [
            Container(
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'எட்டாம்-திருமுறை-திருவாசகம்',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            fontFamily: 'MeeraInimai-Regular'
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'திருவாசகத்துக்கு உருகார் ஒரு வாசகத்திற்கும் உருகார்',
                        style: TextStyle(
                            fontSize: 12,
                           fontWeight: FontWeight.bold,
                            fontFamily: 'MeeraInimai-Regular'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Card(
                    color: Colors.white70,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: locations.length,
                      itemBuilder: (context, index) {
                        final location = locations[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print('text');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContentPage(
                                      id:location.id,
                                      name:location.name,
                                      audioUrl: location.audioUrl,
                                      videoUrl: location.videoUrl,
                                      desc: location.desc,
                                      thumbline:location.thumbnailimg,
                                      videoId:location.videoid,
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Text(location.name,style: TextStyle(
                                  fontFamily: 'MeeraInimai-Regular',
                                    fontSize: 16,fontWeight: FontWeight.w600
                                ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            if (index < locations.length - 1)
                              const Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Divider(
                                    thickness: 0.5,
                                    color: Colors.black12,
                                  )), // Add Divider for all but the last item
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguagePickerDialog extends StatefulWidget {
  @override
  _LanguagePickerDialogState createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<LanguagePickerDialog> {
  String _selectedLanguage = 'Tamil';

  final List<String> _languages = ['Tamil', 'English',];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [Colors.redAccent, Colors.grey],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Language',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: _languages.map((language) {
                return RadioListTile<String>(
                  activeColor: Colors.deepOrange,
                  title: Text(
                    language,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white, // Background color
                    onPrimary: Colors.deepOrange, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_selectedLanguage);
                    // Add action to handle language selection
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
