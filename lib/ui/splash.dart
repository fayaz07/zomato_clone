import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:zomato_clone/utils/constants.dart';

List<String> scrollingFoodItems = [
  'assets/images/food1.png',
  'assets/images/food2.png',
  'assets/images/food3.png',
  'assets/images/food4.png',
  'assets/images/food5.png',
  'assets/images/food6.png',
  'assets/images/food7.png',
  'assets/images/food8.png',
  'assets/images/food9.png',
];

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  Animation scrollingAnimation;
  AnimationController scrollAnimController;

  ScrollController controller = ScrollController();
  double height, width;

  @override
  void initState() {
    super.initState();
  }

  void startScrollAnimation(Duration dur){
        var duration = 2 * scrollingFoodItems.length;

    Future.delayed(Duration(milliseconds: 1000)).whenComplete(() {
      print(controller.position.maxScrollExtent);
      print(controller.position.minScrollExtent);

      scrollAnimController = AnimationController(
          vsync: this, duration: Duration(seconds: int.parse('$duration')));

      scrollingAnimation = Tween(
              begin: controller.position.minScrollExtent,
              end: controller.position.maxScrollExtent)
          .animate(CurvedAnimation(
              parent: scrollAnimController, curve: Curves.linear));
      scrollAnimController.forward();

      scrollingAnimation.addListener(() {
        controller.animateTo(scrollingAnimation.value,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    
    //After the widget is rendered, waiting for 1000 ms and starting the anim
    WidgetsBinding.instance.addPostFrameCallback(
      (Duration d){
        startScrollAnimation(d);
      }
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            getSkipButton(),
            SizedBox(height: 20.0),
            getZomatoText(),
            SizedBox(height: 30.0),
            Expanded(child: getScrollView()),
            SizedBox(height: 40.0),

            //Social Media buttons
            getSocialMediaButton(
                image: 'assets/icons/fblogo.png',
                text: 'Continue with Facebook'),
            SizedBox(height: 10.0),
            getSocialMediaButton(
                image: 'assets/icons/google.png', text: 'Continue with Google'),
            SizedBox(height: 10.0),
            getSocialMediaButton(
                image: 'assets/icons/email.png', text: 'Continue with Email'),
            SizedBox(height: 20.0),

            //Terms and conditions section
            Text('By continuing, you agree to our'),
            SizedBox(height: 3.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text('Terms of Service',
                      style: TextStyle(
                          fontSize: 12.0,
                          decoration: TextDecoration.underline)),
                  onTap: () {},
                ),
                SizedBox(width: 5.0),
                InkWell(
                  child: Text('Privacy Policy',
                      style: TextStyle(
                          fontSize: 12.0,
                          decoration: TextDecoration.underline)),
                ),
                SizedBox(width: 5.0),
                InkWell(
                  child: Text('Content Policy',
                      style: TextStyle(
                          fontSize: 12.0,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
            SizedBox(height: 20.0)
          ],
        ),
      ),
    );
  }

  Widget getSkipButton() => Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 10.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: MaterialButton(
            onPressed: () {},
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.black.withOpacity(0.75),
                fontFamily: 'source-sans-pro.light',
                fontSize: height * 0.23 / 10,
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Values.buttonRadius)),
          ),
        ),
      );

  Widget getZomatoText() => Text(
        'zomato',
        style: TextStyle(
          color: Colors.red,
          fontSize: height * 0.7 / 10,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w900,
          fontFamily: 'source-sans-pro.bold-italic',
        ),
      );

  Widget getScrollView() => SingleChildScrollView(
        controller: controller,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisSize: MainAxisSize.min,
            children:
                List<Widget>.generate(scrollingFoodItems.length, (int index) {
              return SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    scrollingFoodItems[index],
                    fit: BoxFit.fill,
                    scale: 0.5,
                  ),
                ),
              );
            })),
      );

  Widget getSocialMediaButton(
          {String image, String text, Function onPressed}) =>
      MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: Colors.white,
        onPressed: () {},
        elevation: 4.0,
        child: SizedBox(
          width: width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              children: <Widget>[
                SizedBox(width: 2.0),
                SizedBox(
                    height: height * 0.30 / 10,
                    child: Image.asset(
                      image,
                      fit: BoxFit.fill,
                    )),
                SizedBox(width: 10.0),
                Text(text,
                    style: TextStyle(
                        fontSize: height * 0.25 / 10,
                        fontFamily: 'source-sans-pro.semibold',
                        fontWeight: FontWeight.w400))
              ],
            ),
          ),
        ),
      );
}
