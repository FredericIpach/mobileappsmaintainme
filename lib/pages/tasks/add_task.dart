import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/bloc_provider.dart';
import 'package:flutter_app/models/priority.dart';
import 'package:flutter_app/pages/labels/label.dart';
import 'package:flutter_app/pages/projects/project.dart';
import 'package:flutter_app/pages/tasks/bloc/add_task_bloc.dart';
import 'package:flutter_app/utils/app_util.dart';
import 'package:flutter_app/utils/color_utils.dart';
import 'package:flutter_app/utils/date_util.dart';

class AddTaskScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

//  Completer<GoogleMapController> _controller = Completer();
//
//  static final CameraPosition _kGooglePlex = CameraPosition(
//    target: LatLng(37.42796133580664, -122.085749655962),
//    zoom: 14.4746,
//  );
//
//  static final CameraPosition _kLake = CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(37.43296265331129, -122.08832357078792),
//      tilt: 59.440717697143555,
//      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text("Add Maintenance Activity"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  validator: (value) {
                    var msg = value.isEmpty ? "Title Cannot be Empty" : null;
                    return msg;
                  },
                  onSaved: (value) {
                    createTaskBloc.updateTitle = value;
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration:
                      InputDecoration(hintText: "Maintenance Activity")),
            ),
            key: _formState,
          ),

//          GoogleMap(
//            mapType: MapType.hybrid,
//            initialCameraPosition: _kGooglePlex,
//            myLocationEnabled: true,
//            myLocationButtonEnabled: true,
//            onMapCreated: (GoogleMapController controller) {
//              _controller.complete(controller);
//            },
//          ),

//
//          ListTile(
//            leading: Icon(Icons.build),
//            title: Text("Maintenance Activity"),
//            subtitle: StreamBuilder<Project>(
//              stream: createTaskBloc.selectedProject,
//              initialData: Project.getInbox(),
//              builder: (context, snapshot) => Text(snapshot.data.name),
//            ),
//            onTap: () {
//              _showProjectsDialog(createTaskBloc, context);
//            },
//          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text("Vehicle"),
            subtitle: StreamBuilder<Project>(
              stream: createTaskBloc.selectedProject,
              initialData: Project.getInbox(),
              builder: (context, snapshot) => Text(snapshot.data.name),
            ),
            onTap: () {
              _showProjectsDialog(createTaskBloc, context);
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Due Date"),
            subtitle: StreamBuilder(
              stream: createTaskBloc.dueDateSelected,
              initialData: DateTime.now().millisecondsSinceEpoch,
              builder: (context, snapshot) =>
                  Text(getFormattedDate(snapshot.data)),
            ),
            onTap: () {
              _selectDate(context);
            },
          ),
          /* ListTile(
            leading: Icon(Icons.flag),
            title: Text("Priority"),
            subtitle: StreamBuilder(
              stream: createTaskBloc.prioritySelected,
              initialData: Status.PRIORITY_4,
              builder: (context, snapshot) =>
                  Text(priorityText[snapshot.data.index]),
            ),
            onTap: () {
              _showPriorityDialog(createTaskBloc, context);
            },
          ), */
          ListTile(
              leading: Icon(Icons.label),
              title: Text("Lables"),
              subtitle: StreamBuilder(
                stream: createTaskBloc.labelSelection,
                initialData: "No Labels",
                builder: (context, snapshot) => Text(snapshot.data),
              ),
              onTap: () {
                _showLabelsDialog(context);
              }),

          ListTile(
            leading: Icon(Icons.map),
            title: Text("Location"),
            subtitle: Text("No Location Assigned Yet"),
            onTap: () {
              showSnackbar(_scaffoldState, "Comming Soon");
            },
          ),
          ListTile(
            leading: Icon(Icons.mode_comment),
            title: Text("Comments"),
            subtitle: Text("No Comments"),
            onTap: () {
//              _showCommentDialog(context);
              showSnackbar(_scaffoldState, "Comming Soon");
            },
          ),
          /*ListTile(
            leading: Icon(Icons.timer),
            title: Text("Reminder"),
            subtitle: Text("No Reminder"),
            onTap: () {
              showSnackbar(_scaffoldState, "Comming Soon");
            },

          )*/
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send, color: Colors.white),
          onPressed: () {
            if (_formState.currentState.validate()) {
              _formState.currentState.save();
              createTaskBloc.createTask().listen((value) {
                Navigator.pop(context, true);
              });
            }
          }),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      createTaskBloc.updateDueDate(picked.millisecondsSinceEpoch);
    }
  }

  Future<Status> _showPriorityDialog(
      AddTaskBloc createTaskBloc, BuildContext context) async {
    return await showDialog<Status>(
        context: context,
        builder: (BuildContext dialogContext) {
          return SimpleDialog(
            title: const Text('Select Priority'),
            children: <Widget>[
              buildContainer(context, Status.PRIORITY_1),
              buildContainer(context, Status.PRIORITY_2),
              buildContainer(context, Status.PRIORITY_3),
              buildContainer(context, Status.PRIORITY_4),
            ],
          );
        });
  }

  Future<Status> _showProjectsDialog(
      AddTaskBloc createTaskBloc, BuildContext context) async {
    return showDialog<Status>(
        context: context,
        builder: (BuildContext dialogContext) {
          return StreamBuilder(
              stream: createTaskBloc.projects,
              initialData: List<Project>(),
              builder: (context, snapshot) {
                return SimpleDialog(
                  title: const Text('Choose Vehicle'),
                  children:
                      buildProjects(createTaskBloc, context, snapshot.data),
                );
              });
        });
  }

  Future<Status> _showLabelsDialog(BuildContext context) async {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return showDialog<Status>(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder(
              stream: createTaskBloc.labels,
              initialData: List<Label>(),
              builder: (context, snapshot) {
                return SimpleDialog(
                  title: const Text('Select Labels'),
                  children: buildLabels(createTaskBloc, context, snapshot.data),
                );
              });
        });
  }

  Future<String> _showCommentDialog(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: TextField(),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, "");
                  },
                  child: Text("CANCEL",
                      style: TextStyle(color: Theme.of(context).accentColor))),
              FlatButton(
                  onPressed: () {},
                  child: Text("SAVE",
                      style: TextStyle(color: Theme.of(context).accentColor)))
            ],
          );
        });
  }

  List<Widget> buildProjects(
    AddTaskBloc createTaskBloc,
    BuildContext context,
    List<Project> projectList,
  ) {
    List<Widget> projects = List();
    projectList.forEach((project) {
      projects.add(ListTile(
        leading: Container(
          width: 12.0,
          height: 12.0,
          child: CircleAvatar(
            backgroundColor: Color(project.colorValue),
          ),
        ),
        title: Text(project.name),
        onTap: () {
          createTaskBloc.projectSelected(project);
          Navigator.pop(context);
        },
      ));
    });
    return projects;
  }

  List<Widget> buildLabels(
    AddTaskBloc createTaskBloc,
    BuildContext context,
    List<Label> labelList,
  ) {
    List<Widget> labels = List();
    labelList.forEach((label) {
      labels.add(ListTile(
        leading: Icon(Icons.label, color: Color(label.colorValue), size: 18.0),
        title: Text(label.name),
        trailing: createTaskBloc.selectedLabels.contains(label)
            ? Icon(Icons.close)
            : Container(width: 18.0, height: 18.0),
        onTap: () {
          createTaskBloc.labelAddOrRemove(label);
          Navigator.pop(context);
        },
      ));
    });
    return labels;
  }

  GestureDetector buildContainer(BuildContext context, Status status) {
    AddTaskBloc createTaskBloc = BlocProvider.of(context);
    return GestureDetector(
        onTap: () {
          createTaskBloc.updatePriority(status);
          Navigator.pop(context, status);
        },
        child: Container(
            color: status == createTaskBloc.lastPrioritySelection
                ? Colors.grey
                : Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2.0),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 6.0,
                    color: priorityColor[status.index],
                  ),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(12.0),
                child: Text(priorityText[status.index],
                    style: TextStyle(fontSize: 18.0)),
              ),
            )));
  }
}
