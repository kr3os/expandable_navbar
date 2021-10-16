class Music {
  final String singer;
  final String name;
  final String backgroundImage;
  final String singerImage;

  Music({this.singer, this.name, this.backgroundImage, this.singerImage});
}


const _assetPath = 'assets/expandable_nav_bar/';

final musics = List.generate(
  4, (index) => Music(
    singer: 'Singer ${index + 1}', 
    name: 'Song Name ${index + 1}' , 
    backgroundImage: '${_assetPath}img${index + 1}.png', 
    singerImage: '${_assetPath}person${index + 1}.png'
  ),
);