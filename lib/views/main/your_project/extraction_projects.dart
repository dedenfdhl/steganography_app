import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share_plus/share_plus.dart';
import 'package:steganography_app/data/firebase_storage_service.dart';

import '../../../constants/custom_colors.dart';
import '../../../constants/typo.dart';
import '../../../data/auth_service.dart';

class ExtractionProjects extends StatefulWidget {
  const ExtractionProjects({super.key});

  @override
  State<ExtractionProjects> createState() => _ExtractionProjectsState();
}

class _ExtractionProjectsState extends State<ExtractionProjects> {
  List<Map<String, dynamic>> waitingList = [];
  List<Map<String, dynamic>> doneList = [];
  bool isLoading = true;
  String choosed = 'waiting';

  @override
  void initState() {
    Future.wait([getExtractions()]).then((value) {
      isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  Future<void> getDone(DataSnapshot event) async {
    final instance = FirebaseDatabase.instance;

    if (event.exists) {
      // doneList.clear();
      Map result = event.value as Map;
      result.forEach((key, value) async {
        // '0U2cAeR4lJNK8I7Set3JE67RYD72'
        if (value['userid'] == AuthService.currentUser!.uid) {
          final watermarkEvent =
              await instance.ref('Extraction/WatermarkEx/$key').once();

          String watermarkNameFile = '';
          String watermarkPathFile = '';

          if (watermarkEvent.snapshot.exists) {
            watermarkNameFile =
                (watermarkEvent.snapshot.value as Map)['nama_file'];
            watermarkPathFile =
                (watermarkEvent.snapshot.value as Map)['path_file'];
          }

          Map<String, dynamic> each = {
            'key': key,
            'metode': value['metode'],
            'nama_file_mat': value['nama_file'],
            'path_file_mat': value['path_file'],
            'nama_file_watermark': watermarkNameFile,
            'path_file_watermark': watermarkPathFile,
            'userid': value['userid'],
            'embed_key': value['key'],
            'status': value['status'],
            'timestamp': value['timestamp'],
          };
          doneList.add(each);
        }
        setState(() {});
      });
    }
  }

  Future downloadImage(String ref) async {
    try {
      bool result = await FirebaseStorageService.downloadAndSaveMatFile(ref);
      if (result) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Save successfull!',
              style: AppTypography.regular12.copyWith(color: Colors.white),
            ),
          ),
        );
      }
      // final url = await FirebaseStorageService.downloadUrl(ref);

      // final tempDir = await getTemporaryDirectory();
      // final path = '${tempDir.path}/$ref';
      // await Dio().download(url, path);

      // print(path);

      // await GallerySaver.saveImage(path, albumName: 'SteganoApp');

      // // ignore: use_build_context_synchronously
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.green,
      //     content: Text(
      //       'Image successfully saved!',
      //       style: AppTypography.regular12.copyWith(color: Colors.black),
      //     ),
      //   ),
      // );
    } catch (e) {
      print('failed saveImage: $e');
    }
  }

  Future<void> getProcess(DataSnapshot event) async {}

  Future<void> getWaiting(DataSnapshot event) async {
    if (event.exists) {
      // waitingList.clear();
      Map result = event.value as Map;
      result.forEach((key, value) async {
        // '0U2cAeR4lJNK8I7Set3JE67RYD72'
        if (value['userid'] == AuthService.currentUser!.uid) {
          Map<String, dynamic> each = {
            'key': key,
            'metode': value['metode'],
            'nama_file_mat': value['nama_file'],
            'path_file_mat': value['path_file'],
            'nama_file_watermark': null,
            'path_file_watermark': null,
            'userid': value['userid'],
            'embed_key': value['key'],
            'status': value['status'],
            'timestamp': value['timestamp'],
          };
          waitingList.add(each);
        }
        setState(() {});
      });
    }
  }

  Future<void> getExtractions() async {
    final instance = FirebaseDatabase.instance;

    final DatabaseReference ref = instance.ref('Extraction/StegoEx');

    // final Query query =
    //     ref.orderByChild("userid").equalTo("0U2cAeR4lJNK8I7Set3JE67RYD72");
    // final Query queryWaiting = ref.orderByChild("status").equalTo(0);
    // final Query queryDone = ref.orderByChild("status").equalTo(2);
    final Query queryWaiting = ref.orderByChild("status").equalTo('0');
    final Query queryWaiting1 = ref.orderByChild("status").equalTo(1);
    final Query queryDone = ref.orderByChild("status").startAt(2).endAt(5);

    DataSnapshot eventWaiting = await queryWaiting.get();
    DataSnapshot eventWaiting1 = await queryWaiting1.get();
    DataSnapshot eventDone = await queryDone.get();

    waitingList.clear();
    doneList.clear();

    await getWaiting(eventWaiting);
    await getWaiting(eventWaiting1);
    await getDone(eventDone);

    // Query query = ref.orderByChild("age").limitToFirst(10);

    // DataSnapshot event = await query.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          onTap: () {
                            choosed = 'waiting';
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(12),
                                // color: Colors.blue,
                                border: choosed == 'waiting'
                                    ? const Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2))
                                    : null),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: const Text(
                              'Waiting Admin',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     choosed = 'process';
                        //     setState(() {});
                        //   },
                        //   child: Container(
                        //     margin: const EdgeInsets.only(right: 8),
                        //     decoration: BoxDecoration(
                        //         // borderRadius: BorderRadius.circular(12),
                        //         // color: Colors.blue,
                        //         border: choosed == 'process'
                        //             ? const Border(
                        //                 bottom: BorderSide(
                        //                     color: Colors.black, width: 2))
                        //             : null),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 8, vertical: 12),
                        //     child: const Text(
                        //       'In Process',
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontWeight: FontWeight.bold),
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            choosed = 'done';
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(12),
                                // color: Colors.blue,
                                border: choosed == 'done'
                                    ? const Border(
                                        bottom: BorderSide(
                                            color: Colors.black, width: 2))
                                    : null),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (choosed == 'waiting' && waitingList.isEmpty) ||
                                (choosed == 'done' && doneList.isEmpty)
                            ? const Center(
                                child: Text('Data tidak ditemukan'),
                              )
                            : ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: choosed == 'waiting'
                                    ? waitingList.length
                                    : doneList.length,
                                itemBuilder: (context, index) {
                                  final dataListViewBuilder =
                                      choosed == 'waiting'
                                          ? waitingList[index]
                                          : doneList[index];
                                  return Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            Border.all(color: Colors.black87)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Method',
                                          style: AppTypography.medium.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${dataListViewBuilder['metode']}'),
                                        // Text(
                                        //     '${embeddingsResult![key]['metode']}'),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Key',
                                          style: AppTypography.medium.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${dataListViewBuilder['embed_key']}'),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Status',
                                          style: AppTypography.medium.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(choosed == 'waiting'
                                            ? 'WAITING ADMIN'
                                            : 'DONE'),
                                        const SizedBox(height: 12),
                                        dataListViewBuilder['status'] == '0' ||
                                                dataListViewBuilder['status'] ==
                                                    1
                                            ? const SizedBox()
                                            : _buildImageAll(
                                                dataListViewBuilder),
                                        const SizedBox(height: 16),
                                        _buildAndShareAttackStego(
                                            dataListViewBuilder),
                                        const SizedBox(height: 20),
                                        dataListViewBuilder['status'] == '0' ||
                                                dataListViewBuilder['status'] ==
                                                    1
                                            ? _buildFileMat(
                                                dataListViewBuilder)
                                            : const SizedBox(),
                                        // dataListViewBuilder[
                                        //             'path_file_stego'] ==
                                        //         null
                                        //     ? const SizedBox()
                                        //     : _buildSaveAndShare(
                                        //         dataListViewBuilder)
                                      ],
                                    ),
                                  );
                                }),
                  ))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Center _buildFileMat(Map<String, dynamic> dataListViewBuilder) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: CustomColors.primaryPurple,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0),
        onPressed: () async {
          bool result = await FirebaseStorageService.downloadAndSaveMatFile(
              '${dataListViewBuilder['path_file_mat']}${dataListViewBuilder['nama_file_mat']}');
          if (result) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Download successfull! File location: Download/${dataListViewBuilder['nama_file_mat']}',
                  style: AppTypography.regular12.copyWith(color: Colors.white),
                ),
              ),
            );
          }
        },
        child:
        Icon(
          Icons.upload_file_sharp,
          color: Colors.black,
          size: 50,
        ), 
        // Text(
        //   'File.mat',
        //   style: AppTypography.regular12.copyWith(
        //     fontSize: 18,
        //     color: CustomColors.primaryPurple,
        //   ),
        // ),
      ),
    );
  }

  Row _buildAndShareAttackStego(Map<String, dynamic> dataListViewBuilder) {
    return Row(
      children: [
        Expanded(
          child: dataListViewBuilder['path_file_watermark'] == null
              ? const SizedBox()
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CustomColors.primaryPurple,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: () => downloadImage(
                          '${dataListViewBuilder['path_file_watermark']}'),
                      child: Text(
                        'Save',
                        style: AppTypography.regular12.copyWith(
                          fontSize: 14,
                          color: CustomColors.primaryPurple, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(
                              color: CustomColors.primaryPurple,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0),
                      onPressed: () async {
                        final String url =
                            await FirebaseStorageService.downloadUrl(
                                '${dataListViewBuilder['path_file_watermark']}');
                        var file =
                            await DefaultCacheManager().getSingleFile(url);
                        XFile result = XFile(file.path);
                        await Share.shareXFiles([result], text: 'Hidden Image');
                      },
                      child: Text(
                        'Share',
                        style: AppTypography.regular12.copyWith(
                          fontSize: 14,
                          color: CustomColors.primaryPurple, fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Row _buildImageAll(Map<String, dynamic> dataListViewBuilder) {
    return Row(
      children: [
        dataListViewBuilder['path_file_watermark'] == null
            ? const SizedBox()
            : Expanded(
                child: Column(
                children: [
                  Text(
                    'Hidden Image',
                    style: AppTypography.medium.copyWith(fontWeight: FontWeight.bold),
                  ),
                  FutureBuilder(
                    future: FirebaseStorageService.downloadUrl(
                        '${dataListViewBuilder['path_file_watermark']}'),
                    // future: FirebaseStorageService.downloadUrl(
                    //     '${dataListViewBuilder['path_file_watermark']}${dataListViewBuilder['nama_file_watermark']}'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit.fill,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                      );
                    },
                  ),
                ],
              ))
      ],
    );
  }

  // Row _buildSaveAndShare(Map<String, dynamic> dataListViewBuilder) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               side: const BorderSide(
  //                 color: CustomColors.primaryPurple,
  //               ),
  //             ),
  //             backgroundColor: Colors.transparent,
  //             elevation: 0),
  //         onPressed: () => downloadImage(
  //             '${dataListViewBuilder['path_file_stego']}${dataListViewBuilder['nama_file_stego']}'),
  //         child: Text(
  //           'Save',
  //           style: AppTypography.regular12.copyWith(
  //             fontSize: 14,
  //             color: CustomColors.primaryPurple,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 40),
  //       ElevatedButton(
  //         style: ElevatedButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10),
  //               side: const BorderSide(
  //                 color: CustomColors.primaryPurple,
  //               ),
  //             ),
  //             backgroundColor: Colors.transparent,
  //             elevation: 0),
  //         onPressed: () async {
  //           final String url = await FirebaseStorageService.downloadUrl(
  //               '${dataListViewBuilder['path_file_stego']}${dataListViewBuilder['nama_file_stego']}');
  //           var file = await DefaultCacheManager().getSingleFile(url);
  //           XFile result = XFile(file.path);
  //           await Share.shareXFiles([result], text: 'Stego Image');
  //         },
  //         child: Text(
  //           'Share',
  //           style: AppTypography.regular12.copyWith(
  //             fontSize: 14,
  //             color: CustomColors.primaryPurple,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
