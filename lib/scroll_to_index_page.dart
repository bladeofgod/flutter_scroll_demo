import 'package:flutter/material.dart';
import 'dart:math' as math;


/// scroll to index page demo 1
/// 效果不错，原地址是：https://github.com/CarGuo/gsy_flutter_demo/blob/master/lib/widget/scroll_to_index_demo_page2.dart

/*
* 第二种实现方式见：https://github.com/CarGuo/gsy_flutter_demo/blob/master/lib/widget/scroll_to_index_demo_page.dart
* 需要引入 外部AutoScrollController
* */

class ScrollToIndexPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return ScrollToIndexPageState();
  }

}

class ScrollToIndexPageState extends State<ScrollToIndexPage> {

  GlobalKey  scrollKey = GlobalKey();

  ScrollController controller = ScrollController();

  List<ItemModel> dataList = List();

  @override
  void initState() {

    dataList.clear();
    List.generate(100, (index){
      dataList.add(new ItemModel(index));
    });

    super.initState();
  }

  scrollToIndex(){
    var key = dataList[12];

    RenderBox renderBox = key.globalKey.currentContext.findRenderObject();

    ///获取位置偏移，基于 ancestor: SingleChildScrollView 的 RenderObject()
    ///计算点以Offset.zero 计算，坐标系则不以屏幕为准，而是以父类 SingleChildScrollView的
    ///renderBox为准 来进行计算。（要确保 ancestor必须是 子renderBox 的 父 widget才可以。）
    double dy = renderBox.localToGlobal(Offset.zero,ancestor: scrollKey.currentContext.findRenderObject()).dy;
    print("dy : $dy      controller offset : ${controller.offset}");

    //计算真实偏移量
    var offset = dy + controller.offset;
    
    controller.animateTo(offset, duration: Duration(milliseconds: 500), curve: Curves.linear);


  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          key: scrollKey,
          controller: controller,
          child: Column(
            children: dataList.map((item){
              return CardItem(item,key: dataList[item.index].globalKey,);
            }).toList(),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          child: Text("scroll to inddex"),
          onPressed: ()async{
            scrollToIndex();
          },
        ),
      ],
    );
  }
}



class CardItem extends StatelessWidget{

  final random = math.Random();

  final ItemModel data;

  CardItem(this.data,{key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Container(
        height: (300 * random.nextDouble()),
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.all(5),
          child: Text("item ${data.index}"),
        ),
      ),
    );
  }

}


class ItemModel{
  GlobalKey globalKey = GlobalKey();
  final int index;

  ItemModel(this.index);


}

















