class ChatModel {
  var name;
  var message;
  var time;
  var avaterurl;
  var Receiveremail;
  var sendermassge;
  bool state;
  ChatModel(
      {this.name, this.message, this.time, this.avaterurl, this.state = false});
}

List<ChatModel> Data = [];
