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
  final int _numPages = 4;
  int _currentPage = 0;

  TextEditingController eCtrl;
  PageController _pageController;
  List<Widget> onBoardPages;
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    eCtrl = new TextEditingController();
    onBoardPages = [
      Welcome(),
      EnterName(eCtrl, _pageController),
      NotificationExplain(_pageController),
      SwipeExplain()
    ];
    super.initState();
  }

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
      resizeToAvoidBottomPadding: false,
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
                          FocusScope.of(context).unfocus();
                          _currentPage = page;
                        });
                      },
                      children: onBoardPages),
                ),
                Expanded(
                  child: Text(''),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

class EnterName extends StatelessWidget {
  final TextEditingController eCtrl;
  final PageController pageController;
  EnterName(this.eCtrl, this.pageController);

  @override
  Widget build(BuildContext context) {
    final String namePreferenceKey = 'name';

    Future<void> _setName(String name) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(namePreferenceKey, name);
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    Column nameCol = Column(
      children: <Widget>[
        // SizedBox(
        //   height: 20,
        // ),
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
          // autofocus: true,
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

    return nameCol;
  }
}

class NotificationExplain extends StatelessWidget {
  final PageController pageController;
  NotificationExplain(this.pageController);

  @override
  Widget build(BuildContext context) {
    final String enabledPreferenceKey = 'enabled';

    Future<void> _setEnabledYes() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(enabledPreferenceKey, true);
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    Future<void> _setEnabledNo() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(enabledPreferenceKey, false);
      pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    Column notCol = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(25),
          child: Display1Text(
            AppLocalizations.of(context).translate('onboard_notfication'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            //TODO: Make chosen button highlighted
            OnBoardButton(
                AppLocalizations.of(context)
                    .translate('onboard_notification_yes'),
                _setEnabledYes),
            OnBoardButton(
                AppLocalizations.of(context)
                    .translate('onboard_notification_no'),
                _setEnabledNo)
          ],
        )
      ],
    );

    return notCol;
  }
}

class SwipeExplain extends StatelessWidget {
  SwipeExplain();

  @override
  Widget build(BuildContext context) {
    Future<void> _skipOnboard(SharedPreferences prefs) async {
      prefs.setBool("welcome", true);
    }

    void _onComplete() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _skipOnboard(prefs);
      Navigator.pushNamedAndRemoveUntil(context, "/strengths",
          (Route<dynamic> route) {
        return false;
      });
    }

    Stack explain = Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Display1Text(
                AppLocalizations.of(context).translate('onboard_eplain_swipe'),
              ),
            ),
            Dismissible(
              onDismissed: (DismissDirection direction) async {},
              background: EditContainer(),
              secondaryBackground: DeleteContainer(),
              child: EntryCard(AppLocalizations.of(context)
                  .translate("onboard_example_entry")),
              key: UniqueKey(),
            ),
          ],
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: OnBoardButton(
                AppLocalizations.of(context).translate('onbard_welcome_done'),
                _onComplete))
      ],
    );
    return explain;
  }
}
