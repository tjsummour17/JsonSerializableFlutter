import 'package:flutter/material.dart';
import 'package:json_convert/res/strings.dart';
import 'package:json_convert/viewModel/get_users_view_model.dart';
import 'package:json_convert/views/widgets/user_card.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GetUsersViewModel _getUsersViewModel = GetUsersViewModel();
  ScrollController _listController;
  int limit = 5;
  bool firstTimeFlag = true;

  @override
  void initState() {
    _listController = ScrollController();
    _listController.addListener(_scrollListener);
    super.initState();
  }

  _scrollListener() {
    if  (_listController.offset >= _listController.position.maxScrollExtent &&
        !_listController.position.outOfRange) {
      setState(() {
        limit += 5;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Strings().applicationName),
      ),
      backgroundColor: Colors.blueGrey[200],
      body: FutureBuilder(
        future: _getUsersViewModel.getUsersFromApi(limit),
        builder: (BuildContext context, snapshot) {
          if (firstTimeFlag &&
              snapshot.connectionState == ConnectionState.waiting) {
            firstTimeFlag = false;
            return Container(
              width: width,
              height: height,
              color: Color(0xBBFFFFFF),
              child: Center(
                child: CircularProgressIndicator(backgroundColor: Colors.white),
              ),
            );
          } else {
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _listController,
                      padding: EdgeInsets.only(
                          right: 5, left: 5, bottom: 45, top: 5),
                      itemBuilder: (BuildContext context, int index) =>
                          UserCard(
                        user: _getUsersViewModel.users[index],
                      ),
                      itemCount: _getUsersViewModel.users.length,
                    ),
                  ),
                  snapshot.connectionState == ConnectionState.waiting
                      ? Container(
                          width: width,
                          height: 40,
                          color: Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          ),
                        )
                      : SizedBox()
                ],
              );
          }
        },
      ),
    );
  }
}
