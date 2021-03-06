import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:expandable_navbar/models/music_model.dart';

const _cardColor  = Color(0XFF5F40Fb);
const _maxHeight = 350.0;
const _minHeight = 70.0;

class MainExpandableNavBar extends StatefulWidget {

  @override
  _MainExpandableNavBarState createState() => _MainExpandableNavBarState();
}

class _MainExpandableNavBarState extends State<MainExpandableNavBar> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  bool _expanded = false;
  double _currentHeight = _minHeight;
  Music _currentMusic;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600)
    );
    super.initState();
  }

  @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

 @override
  Widget build(BuildContext context) {
    final size =  MediaQuery.of(context).size;
    final menuWidth = size.width * 0.5;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView.builder(
            padding: EdgeInsets.only(bottom: _minHeight + 20, left: 20, right: 20),
            itemCount: 4,
            itemBuilder: (context, index){
              final music = musics[index];
              return GestureDetector(
                onTap: (){
                  setState(() {
                      _currentMusic = music;         
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Column(
                          children: [
                            Image.asset(
                              music.backgroundImage,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(music.backgroundImage),
                                maxRadius: 20,
                              ),
                              SizedBox(height: 20,),
                              Text(music.singer),
                              Text(music.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
           ),
           GestureDetector(
              onVerticalDragUpdate: _expanded ? (details){
                setState(() {
                    final newHeight = _currentHeight - details.delta.dy; 
                    _controller.value = _currentHeight / _maxHeight;
                    _currentHeight = newHeight.clamp(_minHeight, _maxHeight);
                  });
              } : null,
              onVerticalDragEnd: _expanded ? (details) {
                if (_currentHeight < _maxHeight / 1.5){
                  _controller.reverse();
                  _expanded = false;
                } else {
                  _expanded = true;
                  _controller.forward(from: _currentHeight / _maxHeight );
                  _currentHeight = _maxHeight;
                }
              }: null,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, index){
                final value = const ElasticInOutCurve(0.7).transform(_controller.value);
                return Stack(
                  children: [
                    Positioned(
                      height: lerpDouble(_minHeight, _currentHeight, value),
                      left: lerpDouble(size.width / 2 - menuWidth / 2, 0 , value),
                      width: lerpDouble(menuWidth, size.width, value),
                      bottom: lerpDouble(40, 0, value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(lerpDouble(20, 20, value)),
                            bottom: Radius.circular(lerpDouble(20, 0, value)),
                          )
                        ),
                        child: _expanded 
                        ? Opacity(
                          opacity: _controller.value,
                          child: _buildExpandContent(),
                        )
                        : _builMenuContent(),
                      ),
                    ),
                   ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandContent(){

  return _currentMusic == null ? const SizedBox() :
  Padding(
    padding: const EdgeInsets.all(20),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)), 
              child: Image.asset(
                _currentMusic.backgroundImage,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15,),
            Text(
              _currentMusic.singer,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10,),
            Text(
              _currentMusic.name,
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.shuffle),
                Icon(Icons.pause),
                Icon(Icons.playlist_add)
              ],
            )

          ],
        ),
      ),
    ),
  );
}
 
  Widget _builMenuContent(){

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Icon(Icons.sd_card_alert_outlined),
      GestureDetector(
        onTap: (){
          setState(() {
            _expanded = true;
            _currentHeight = _maxHeight;
            _controller.forward(from: 0.0);          
          });
        },
        child:  CircleAvatar(
          backgroundImage: _currentMusic != null ? AssetImage(_currentMusic.backgroundImage) : null,
        ),
      ),
       CircleAvatar(
        // backgroundImage: AssetImage('assets/expandable_nav_bar/avatar.png'),
        radius: 15,
      ),
    ],
  );
}

}




