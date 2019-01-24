library flutter_backdrop;

import 'package:flutter/material.dart';
import 'package:flutter_backdrop/backdrop_panel.dart';

const _flingVelocity = 2.0;

class Backdrop extends StatefulWidget {

  //----------------------Front and Back Panel properties-----------------------

  /// This is the front panel which will contain the main body.
  final Widget frontLayer;

  /// This is the back panel where you can put menu Items.
  final Widget backLayer;

  /// This widget should contain your title which will appear above [frontLayer].
  /// Remember to modify it properly if you are using [shape] or [borderRadius] mentioned below.
  final Widget frontHeader;

  /// This decides the height of [frontHeader].
  /// Provide 0.0 if you don't want it.
  final double frontHeaderHeight;

  /// Gives a Circular radius to the [frontLayer].
  /// Provide radius only for topLeft or/and topRight for best output.
  final BorderRadius borderRadius;

  /// Gives a shape to border like [BeveledRectangleBorder] to give an effect.
  /// Provide radius only for topLeft or/and topRight for best output.
  final ShapeBorder shape;

  /// [frontHeader] will be visible or not when [backLayer] is visible.
  /// If true [frontHeader] will be visible if [frontHeaderHeight] > 0.0.
  /// If false [frontHeader] will be invisible.
  final bool titleVisibleOnPanelClosed;

  /// Default [Padding] for [frontPanel].
  /// By default [Padding] is [EdgeInsets.zero].
  final EdgeInsets frontPanelPadding;

  /// Decides when app opens, should [frontPanel] be visible.
  /// If true [frontPanel] will be visible.
  /// If false [backPanel] will be visible.
  final bool panelVisibleInitially;

  //------------------------Appbar properties-----------------------------

  /// Non-animated Leading menu icon. Should be [IconData].
  /// If provided [appBarAnimatedLeadingMenuIcon] should be null.
  final IconData appBarLeadingMenuIcon;

  /// Animated Leading menu icon. Should be [AnimatedIconData].
  /// If provided [appBarLeadingMenuIcon] should be null.
  final AnimatedIconData appBarAnimatedLeadingMenuIcon;

  /// Controls whether we should try to imply the leading widget if null.
  ///
  /// If true and [leading] is null, automatically try to deduce what the leading
  /// widget should be. If false and [leading] is null, leading space is given to [title].
  /// If leading widget is not null, this parameter has no effect.
  final bool appBarAutomaticallyImplyLeading;

  /// The primary widget displayed in the appbar.
  ///
  /// Typically a [Text] widget containing a description of the current contents
  /// of the app.
  final Widget appBarTitle;

  /// Widgets to display after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  ///
  /// {@tool snippet --template=stateless_widget}
  ///
  /// This sample shows adding an action to an [AppBar] that opens a shopping cart.
  ///
  /// ```dart
  /// Scaffold(
  ///   appBar: AppBar(
  ///     title: Text('Hello World'),
  ///     actions: <Widget>[
  ///       IconButton(
  ///         icon: Icon(Icons.shopping_cart),
  ///         tooltip: 'Open shopping cart',
  ///         onPressed: () {
  ///           // ...
  ///         },
  ///       ),
  ///     ],
  ///   ),
  /// )
  /// ```
  /// {@end-tool}
  final List<Widget> appBarActions;

  /// The color to use for the app bar's material. Typically this should be set
  /// along with [brightness], [iconTheme], [textTheme].
  ///
  /// Defaults to [ThemeData.primaryColor].
  final Color appBarBackgroundColor;

  /// The color, opacity, and size to use for app bar icons. Typically this
  /// is set along with [backgroundColor], [brightness], [textTheme].
  ///
  /// Defaults to [ThemeData.primaryIconTheme].
  final IconThemeData appBarIconTheme;

  /// The typographic styles to use for text in the app bar. Typically this is
  /// set along with [brightness] [backgroundColor], [iconTheme].
  ///
  /// Defaults to [ThemeData.primaryTextTheme].
  final TextTheme appBarTextTheme;

  /// Whether the title should be centered.
  ///
  /// Defaults to being adapted to the current [TargetPlatform].
  final bool appBarCenterTitle;

  /// The spacing around [title] content on the horizontal axis. This spacing is
  /// applied even if there is no [leading] content or [actions]. If you want
  /// [title] to take all the space available, set this value to 0.0.
  ///
  /// Defaults to [NavigationToolbar.kMiddleSpacing].
  final double appBarTitleSpacing;

  Backdrop({
    @required this.frontLayer,
    @required this.backLayer,
    this.frontHeader,
    this.borderRadius,
    this.shape,
    this.frontHeaderHeight = 48.0,
    this.titleVisibleOnPanelClosed = true,
    this.frontPanelPadding = EdgeInsets.zero,
    this.panelVisibleInitially,

    //--------Appbar properties------------
    this.appBarLeadingMenuIcon,
    this.appBarAnimatedLeadingMenuIcon,
    this.appBarAutomaticallyImplyLeading = true,
    this.appBarTitle,
    this.appBarActions,
    this.appBarBackgroundColor,
    this.appBarIconTheme,
    this.appBarTextTheme,
    this.appBarCenterTitle,
    this.appBarTitleSpacing = NavigationToolbar.kMiddleSpacing,
  })  : assert(frontLayer != null),
        assert(appBarLeadingMenuIcon == null ||
            appBarAnimatedLeadingMenuIcon == null),
        assert(frontHeaderHeight > 0.0 ||
            (appBarLeadingMenuIcon != null ||
                appBarAnimatedLeadingMenuIcon != null)),
        assert(backLayer != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  bool isPanelVisible;
  final _backDropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    isPanelVisible = widget.panelVisibleInitially;
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        value: (isPanelVisible ?? true) ? 1.0 : 0.0)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed)
          isPanelVisible = true;
        else if (status == AnimationStatus.dismissed) isPanelVisible = false;
      });
  }

  bool get _backdropPanelVisible =>
      _controller.status == AnimationStatus.completed ||
          _controller.status == AnimationStatus.forward;

  void _toggleBackdropPanelVisibility() => _controller.fling(
      velocity: _backdropPanelVisible ? -_flingVelocity : _flingVelocity);

  double get _backdropHeight {
    final RenderBox renderBox = _backDropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_controller.isAnimating)
      _controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double fVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (fVelocity < 0.0)
      _controller.fling(velocity: _flingVelocity);
    else if (fVelocity > 0.0)
      _controller.fling(velocity: -_flingVelocity);
    else
      _controller.fling(
          velocity: _controller.value < 0.5 ? -_flingVelocity : _flingVelocity);
  }

  IconButton appBarMenuButton() {
    if (widget.appBarAnimatedLeadingMenuIcon != null) {
      return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: AnimatedIcon(
            icon: widget.appBarAnimatedLeadingMenuIcon,
            progress: _controller.view),
        onPressed: () {
          _controller.fling(velocity: isPanelVisible ? -1 : 1);
        },
      );
    } else if (widget.appBarLeadingMenuIcon != null) {
      return IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(widget.appBarLeadingMenuIcon),
          onPressed: () {
            _controller.fling(velocity: isPanelVisible ? -1 : 1);
          });
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelSize = constraints.biggest;
        print(panelSize.height);
        final closedPercentage = widget.titleVisibleOnPanelClosed
            ? (panelSize.height - widget.frontHeaderHeight) / panelSize.height
            : 1.0;
        final panelDetailsPosition = Tween<Offset>(
            begin: Offset(0.0, closedPercentage), end: Offset(0.0, 0.0))
            .animate(_controller.view);

        return Scaffold(
          appBar: AppBar(
            leading: appBarMenuButton(),
            automaticallyImplyLeading: widget.appBarAutomaticallyImplyLeading,
            title: widget.appBarTitle,
            actions: widget.appBarActions,
            elevation: 0.0,
            backgroundColor: widget.appBarBackgroundColor,
            iconTheme: widget.appBarIconTheme,
            textTheme: widget.appBarTextTheme,
            centerTitle: widget.appBarCenterTitle,
            titleSpacing: widget.appBarTitleSpacing,
          ),
          body: Container(
            key: _backDropKey,
            child: Stack(
              children: <Widget>[
                widget.backLayer,
                SlideTransition(
                  position: panelDetailsPosition,
                  child: BackdropPanel(
                    onTap: _toggleBackdropPanelVisibility,
                    borderRadius: widget.borderRadius,
                    shape: widget.shape,
                    onVerticalDragUpdate: _handleDragUpdate,
                    onVerticalDragEnd: _handleDragEnd,
                    frontHeader: widget.frontHeader,
                    frontHeaderHeight: widget.frontHeaderHeight,
                    padding: widget.frontPanelPadding,
                    child: widget.frontLayer,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}