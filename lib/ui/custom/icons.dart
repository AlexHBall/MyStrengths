import 'package:flutter/material.dart';

class InputIcon extends StatelessWidget {
  final Function() handlePress;

  InputIcon(this.handlePress);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.insert_emoticon),
      iconSize: 35,
      // color: Colors.white,
      onPressed: handlePress,
    );
  }
}

class NotificationIcon extends StatelessWidget {

  NotificationIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.alarm),
      iconSize: 35,
      color: Colors.white, //TODO: Why isn't this white?
      onPressed: null,
    );
  }
}

class EditIcon extends StatelessWidget{
  EditIcon();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      iconSize: 35,
      onPressed: null,);
  }
}

class DeleteIcon extends StatelessWidget{
  DeleteIcon();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      iconSize: 35,
      onPressed: null,);
  }
}