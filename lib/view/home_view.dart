import 'package:cloudempowerment/util/const.dart';
import 'package:cloudempowerment/util/util.dart';
import 'package:flutter/material.dart';
import 'package:cloudempowerment/model/user_model.dart';
import '../model/session_model.dart';
import '../util/api.dart';
import '../util/auth.dart';
import '../util/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.session});

  final Session session;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  get session => widget.session;
  List<String> components = [
    COMPONENT_NAMES.PATIENT_LIST,
    COMPONENT_NAMES.REPORTS,
    COMPONENT_NAMES.DOCUMENTS
  ];
  late OverlayEntry _overlayEntry;

  final double iconSize = 40;
  final double textSize = 16;

  int updates = 0;

  Future<void> _getUpdates() async {
    List<Map<String, dynamic>> updateList = await widget.session.databaseHelper.getUpdates();
    setState(() {
      updates = updateList.length;
    });

  }

  void _sendUpdates(BuildContext context, ApiManager apiManager) async {
    _overlayEntry = createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry);

      if (await AppConnectivity.isConnected()){
        int successes = await apiManager.pushAllToServer(session);
        showToast("${successes} updates pushed successfully");
        List<Map<String, dynamic>> updateList = await widget.session.databaseHelper.getUpdates();
        setState(() {
          updates = updateList.length;
        });
      } else {
        showToast("No internet connection");
      }

    _overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    _getUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final User user = session.currentUser;
    final String firstName = user.first_name;
    final apiManager = ApiManager();
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            backgroundColor: COLORS.TRANSPARENT,
            elevation: 0,
            title: ButtonBar(
              alignment: MainAxisAlignment.end,
              buttonPadding: EdgeInsets.symmetric(horizontal: 50),
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    LoginController.logout(context, session);
                  },
                  child: const Text('Log out'),
                ),
              ],
            )),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 32, 8),
            child: Column(
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      //backgroundImage: Our.profilePicture(session),
                      radius: 50),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 50, 25),
                    child: Text("Hello $firstName!",
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                  ),
                ]),
            Row(children: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 15),
                ),
                onPressed: () async {
                  var updated = await Navigator.of(context)
                      .pushNamed(
                      ROUTES.EDIT_PROFILE, arguments: widget.session) as bool?;
                  if(updated == true) {
                    setState(() {});
                  }
                },
                child: const Text('Edit profile'),
              ),
            ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(
                                  ROUTES.PATIENT_LIST, arguments: widget.session).then((result) {
                                    _getUpdates();
                              });
                            },
                            icon: Icon(Icons.people),
                            color: Colors.brown,
                          ),
                          Text(
                            'PATIENTS',
                            style: TextStyle(color: Colors.brown, fontSize: textSize),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            onPressed: () async {

                            },
                            icon: Icon(Icons.assessment, color: Colors.red),
                          ),
                          Text(
                            'REPORTS',
                            style: TextStyle(color: Colors.orange, fontSize: textSize),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(
                                  ROUTES.DOCUMENTS, arguments: widget.session);
                            },
                            icon: Icon(Icons.description),
                            color: Colors.blue,
                          ),
                          Text(
                            'LIBRARY',
                            style: TextStyle(color: Colors.blue, fontSize: textSize),
                          ),
                        ],
                      ),
                    ],
                  ),
                SizedBox(height: 50),
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.update),
                        iconSize: iconSize,
                        onPressed: () {
                          _sendUpdates(context, apiManager);
                        }
                    ),
                    Text('SEND UPDATES', style: TextStyle( fontSize: textSize)),
                    Text('$updates updates pending', style: TextStyle( fontSize: textSize))
                  ]
                ),
                ],
            )
        )
    );
  }
}
