import 'dart:developer';

import 'package:advanced_to_do/TodoModal.dart';
import 'package:advanced_to_do/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdavanceToDoUI(),
    );
  }
}

class AdavanceToDoUI extends StatefulWidget {
  const AdavanceToDoUI({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AdvanceToDoUIState();
  }
}

class _AdvanceToDoUIState extends State {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<TodoModal> myList = [];

  @override
  void initState() {
    super.initState();
    loadDataFromDB();
  }

  Future<void> loadDataFromDB() async {
    final dataList = await DBHelper().readData();
    setState(() {
      myList = dataList
          .map<TodoModal>((item) => TodoModal(
                id: item['id'],
                title: item['title'],
                description: item['description'],
                date: item['date'],
              ))
          .toList();
    });
  }

  void showBottomSheet(bool isedit, [TodoModal? todoModal]) {
    if (isedit && todoModal != null) {
      titleController.text = todoModal.title;
      descriptionController.text = todoModal.description;
      dateController.text = todoModal.date;
    } else {
      titleController.clear();
      descriptionController.clear();
      dateController.clear();
    }
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        isDismissible: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Create To-Do",
                    style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 57, 241, 1),
                                )),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.purpleAccent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            )),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Description",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextField(
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(89, 57, 241, 1),
                                )),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.purpleAccent,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            )),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Date",
                        style: GoogleFonts.quicksand(
                          color: const Color.fromRGBO(89, 57, 241, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      TextField(
                        controller: dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.calendar_month_rounded),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(89, 57, 241, 1),
                              )),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.purpleAccent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onTap: () async {
                          DateTime? pickeddate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2026));
                          String formatedDate =
                              DateFormat.yMMMd().format(pickeddate!);
                          setState(() {
                            dateController.text = formatedDate;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromRGBO(89, 57, 241, 1)),

                      // onPressed: () async{
                      //   if (titleController.text.trim().isNotEmpty &&
                      //       descriptionController.text.trim().isNotEmpty &&
                      //       dateController.text.trim().isNotEmpty) {
                      //     if (isedit) {
                      //       todoModal?.date = dateController.text;
                      //       todoModal?.description = descriptionController.text;
                      //       todoModal?.title = titleController.text;
                      //     } else {
                      //       myList.add(TodoModal(
                      //         date: dateController.text,
                      //         description: descriptionController.text,
                      //         title: titleController.text,
                      //       ));
                      //     }
                      //   }
                      //   final data=await DBHelper().readData();

                      //  // services.saveTask(titleController.text, descriptionController.text, dateController.text);
                      //   Navigator.of(context).pop();
                      //   titleController.clear();
                      //   descriptionController.clear();
                      //   dateController.clear();
                      //   setState(() {});
                      // },
                      onPressed: () async {
                        if (titleController.text.trim().isNotEmpty &&
                            descriptionController.text.trim().isNotEmpty &&
                            dateController.text.trim().isNotEmpty) {
                          if (isedit && todoModal != null) {
                            await DBHelper().updateData(
                              TodoModal(
                                id: todoModal.id,
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                date: dateController.text.trim(),
                              ),
                            );
                          } else {
                            await DBHelper().insertData(
                              TodoModal(
                                title: titleController.text.trim(),
                                description: descriptionController.text.trim(),
                                date: dateController.text.trim(),
                              ),
                            );
                          }
                        }

                        await loadDataFromDB();

                        final data = await DBHelper().readData();
                        log(data.toString()); // optional debug

                        Navigator.of(context).pop();
                        titleController.clear();
                        descriptionController.clear();
                        dateController.clear();
                        setState(() {});
                      },

                      child: Text(
                        "Submit",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.deepPurple[800],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 40,
              top: 60,
            ),
            child: Text(
              "Good Morning",
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w400,
                fontSize: 22,
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 40,
              top: 2,
              bottom: 40,
            ),
            child: Text(
              "Harshal",
              style: GoogleFonts.quicksand(
                fontSize: 30,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(217, 217, 217, 1),
              ),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Create To Do List",
                        style: GoogleFonts.quicksand(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: myList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.3,
                                    motion: const ScrollMotion(),
                                    children: [
                                      const SizedBox(width: 12),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30, left: 13),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 54, 30, 170),
                                              radius: 20,
                                              child: IconButton(
                                                icon: const Icon(Icons.edit,
                                                    color: Colors.white,
                                                    size: 18),
                                                onPressed: () {
                                                  titleController.text =
                                                      myList[index].title;
                                                  descriptionController.text =
                                                      myList[index].description;
                                                  dateController.text =
                                                      myList[index].date;
                                                  showBottomSheet(
                                                    true,myList[index]
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 17),
                                            CircleAvatar(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 49, 20, 194),
                                              radius: 20,
                                              child: IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .delete_outline_rounded,
                                                    color: Colors.white,
                                                    size: 18),
                                                onPressed: () async{
                                                 await DBHelper().deleteData(myList[index].id!);
                                                 await loadDataFromDB();
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 84, 110, 218),
                                          Color.fromARGB(255, 122, 214, 211)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.15),
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      217, 217, 217, 1),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Image.asset(
                                                  "assets/Group 42.png",
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    myList[index].title,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF2C2C2C),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    myList[index].description,
                                                    style: GoogleFonts.inter(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            myList[index].date,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(false);
        },
        backgroundColor: const Color.fromRGBO(89, 57, 241, 1),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
