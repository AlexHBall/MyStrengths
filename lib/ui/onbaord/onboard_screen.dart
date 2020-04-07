import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Widget> onBoardPages = [Welcome(), EnterName(), SwipeExplain()];

  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OnboardAppBar(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 600.0,
                  child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: onBoardPages),
                ),
                Expanded(child: Text(''),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.blue,
              child: GestureDetector(
                onTap: () => print('Get started'),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Get started',
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}

class EnterName extends StatelessWidget {
  EnterName();

  @override
  Widget build(BuildContext context) {
    final String namePreferenceKey = 'name';
    final TextEditingController eCtrl = TextEditingController();

    Future<void> _setName(String name) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(namePreferenceKey, name);
    }

    Column scaffoldChild = Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.all(25),
          child: Display1Text(
            AppLocalizations.of(context).translate('onboard_welcome_para'),
          ),
        ),
        Text(
          AppLocalizations.of(context).translate('onboard_enter_name'),
          style: Theme.of(context).textTheme.headline,
        ),
        TextField(
          autofocus: true,
          cursorColor: Colors.white,
          style: Theme.of(context).textTheme.display2,
          controller: eCtrl,
          onSubmitted: (String text) async {
            if (text != null) {
              _setName(text);
            }
          },
          textAlign: TextAlign.center,
        ),
      ],
    );

    return scaffoldChild;
  }
}

class Welcome extends StatelessWidget {
  Welcome();

  @override
  Widget build(BuildContext context) {
    Column welcome = Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          AppLocalizations.of(context).translate('onboard_welcome_title'),
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.all(25),
          child: Display1Text(
            AppLocalizations.of(context).translate('onboard_welcome_intro'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(25),
          child: Text(
            AppLocalizations.of(context).translate('onboard_welcome_intro2'),
          ),
        ),
      ],
    );

    return welcome;
  }
}

class SwipeExplain extends StatelessWidget {
  SwipeExplain();

  @override
  Widget build(BuildContext context) {
    Future<void> _skipOnboard(SharedPreferences prefs) async {
      prefs.setBool("welcome", true);
    }

    Column explain = Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Body1Text(
          AppLocalizations.of(context).translate('onboard_eplain_swipe'),
        ),
        //TODO: Add Swipe animations
        Dismissible(
          onDismissed: (DismissDirection direction) async {
            // _handleDirectionalSwipe(context, direction, entry);
          },
          background: EditContainer(),
          secondaryBackground: DeleteContainer(),
          child: EntryCard(
              AppLocalizations.of(context).translate("onboard_example_entry")),
          key: UniqueKey(),
        ),
        FlatButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            _skipOnboard(prefs);
            Navigator.pushNamedAndRemoveUntil(context, "/strengths",
                (Route<dynamic> route) {
              return false;
            });
          },
          child: Body1Text(
            AppLocalizations.of(context).translate('onbard_welcome_done'),
          ),
        )
      ],
    );
    return explain;
  }
}
