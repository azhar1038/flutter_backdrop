import 'package:flutter/material.dart';
import 'package:flutter_backdrop/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';

main() => runApp(MyApp());

bool _toggleFrontLayer = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Backdrop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

/// Implementation of Backdrop Widget starts here.

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: FrontPanelModel(FrontPanels.panelOne),
      child: ScopedModelDescendant<FrontPanelModel>(
        builder: (context, _, model) => Backdrop(
              appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
              appBarTitle: Text('Backdrop'),
              backLayer: BackPanel(),
              toggleFrontLayer: _toggleFrontLayer,
              frontLayer: model.activePanel,
              frontHeader: model.panelTitle(context),
              frontHeaderHeight: 35.0,
              shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
              )),
            ),
      ),
    );
  }
}

/// Creation of Model Class to be used for changing frontLayer
/// as well as on clicking of any option on backLayer

enum FrontPanels { panelOne, panelTwo }

class FrontPanelModel extends Model {
  FrontPanels _activePanel;

  FrontPanelModel(this._activePanel);

  FrontPanels get activePanelType => _activePanel;

  Widget panelTitle(BuildContext context) {
    return Container(
      child: Center(
        child: _activePanel == FrontPanels.panelOne
            ? Text('Panel ONE')
            : Text('Panel TWO'),
      ),
    );
  }

  Widget get activePanel =>
      _activePanel == FrontPanels.panelOne ? PanelOne() : PanelTwo();

  void activate(FrontPanels panel) {
    _activePanel = panel;
    notifyListeners();
  }
}

/// Creation of front layers, both [PanelOne] and [PanelTwo] as well as
/// back layer, [BackPanel]

class PanelOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Panel ONE',
          style: TextStyle(fontSize: 42.0),
        ),
      ),
    );
  }
}

class PanelTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Panel TWO',
          style: TextStyle(fontSize: 42.0),
        ),
      ),
    );
  }
}

class BackPanel extends StatefulWidget {
  @override
  _BackPanelState createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        child: ListView(
          itemExtent: 70.0,
          children: <Widget>[
            ScopedModelDescendant<FrontPanelModel>(
              rebuildOnChange: false,
              builder: (context, _, model) {
                return FlatButton(
                  child: Text('First Panel', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  onPressed: () {
                    model.activate(FrontPanels.panelOne);
                    _toggleFrontLayer = true;
                  },
                );
              },
            ),

            ScopedModelDescendant<FrontPanelModel>(
              rebuildOnChange: false,
              builder: (context, _, model) {
                return FlatButton(
                  child: Text('Second Panel', style: TextStyle(color: Colors.white, fontSize: 20.0),),
                  onPressed: () {
                    model.activate(FrontPanels.panelTwo);
                    _toggleFrontLayer = true;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}