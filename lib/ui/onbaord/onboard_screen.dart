import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_strengths/ui/custom/custom_ui.dart';
import 'package:my_strengths/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboard extends StatelessWidget {
  Onboard();

  final List<Widget> onBoardPages = [Welcome(), EnterName(), SwipeExplain()];

  @override
  Widget build(BuildContext context) {
    PageView pages = PageView.builder(
      controller: PageController(),
      itemCount: onBoardPages.length,
      itemBuilder: (context, position) => onBoardPages[position],
    );

    var gradient = AnnotatedRegion<SystemUiOverlayStyle>(
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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: OnboardAppBar(),
            body: pages,
          ),
        ));
    return gradient;
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
