import 'package:flutter/material.dart';
import 'dart:ui';
import 'globals.dart';
import 'alumni.dart';
import 'entri_alumni.dart';
import 'cetak_album.dart';

extension on String {
  String toIndonesianDate() {
    var nmBulan = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    try {
      var komponen = split("-");
      var thn = int.parse(komponen[0]);
      var bln = nmBulan[int.parse(komponen[1])];
      var tgl = int.parse(komponen[2]);
      return "$tgl $bln $thn";
    } catch (e) {
      return this;
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    scrollBehavior: MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      },
    ),
    home: Home(),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  final Alumni _alumniHelper = Alumni();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("E-Book Alumni ISB Atma Luhur"),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    final pesan = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EntriAlumni()),
                    );
                    if (context.mounted && pesan != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(pesan),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      setState(() {});
                    }
                  },
                  tooltip: "Tambah data alumni",
                  icon: const Icon(Icons.add),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() {}),
                  tooltip: "Refresh data alumni",
                  icon: const Icon(Icons.refresh),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CetakAlbum()),
                  ),
                  tooltip: "Cetak album alumni",
                  icon: const Icon(Icons.print),
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FutureBuilder(
          future: _alumniHelper.tampil(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Memuat data dan foto..."),
                ],
              );
            }

            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning, color: Colors.yellow, size: 200.0),
                  Text(
                    "Tidak dapat memuat data:\n${snapshot.error}",
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }

            if (daftarAlumni.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel, color: Colors.red, size: 200.0),
                  Text(
                    "Tidak ada data",
                    style: TextStyle(fontSize: 32.0, color: Colors.grey),
                  ),
                ],
              );
            }

            return InteractiveViewer(
              constrained: false,
              scaleEnabled: false,
              child: DataTable(
                showCheckboxColumn: false,
                dataRowMaxHeight: 80.0,
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                columns: const [
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Aksi", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("NIM", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Foto", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Nama Alumni", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Program Studi", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text(
                      "Tempat dan Tanggal Lahir",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Alamat", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Nomor HP", textAlign: TextAlign.center),
                  ),
                  DataColumn(
                    headingRowAlignment: MainAxisAlignment.center,
                    label: Text("Tahun Lulus", textAlign: TextAlign.center),
                    numeric: true,
                  ),
                ],
                rows: List<DataRow>.generate(daftarAlumni.length, (index) {
                  var alumniItem = daftarAlumni[index];
                  var bgBaris = switch (alumniItem.prodi) {
                    "Teknik Informatika" => const Color(0xffff7f00),
                    "Sistem Informasi" => const Color(0xff0000ff),
                    "Manajemen Informatika" => const Color(0xffffff00),
                    "Komputerisasi Akuntansi" => const Color(0xff4b3621),
                    "Bisnis Digital" => const Color(0xff800000),
                    _ => const Color(0xff8f00ff),
                  };
                  var fgSel = (alumniItem.prodi == "Manajemen Informatika")
                      ? Colors.black
                      : Colors.white;

                  return DataRow(
                    color: WidgetStatePropertyAll(bgBaris),
                    cells: [
                      DataCell(
                        Center(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final pesan = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EntriAlumni(nim: alumniItem.nim),
                                    ),
                                  );
                                  if (context.mounted && pesan != null) {
                                    setState(() {});
                                  }
                                },
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.orangeAccent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Icon(Icons.edit),
                                tooltip: "Ubah",
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                onPressed: () =>
                                    konfirmasiHapus(context, alumniItem.nim),
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.redAccent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Icon(Icons.delete),
                                tooltip: "Hapus",
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            alumniItem.nim,
                            style: TextStyle(color: fgSel),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white70,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),

                            child:
                                (index < daftarFoto.length &&
                                    daftarFoto[index].isNotEmpty)
                                ? Image.memory(
                                    daftarFoto[index],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              color: Colors.white,
                                            ),
                                  )
                                : const Icon(Icons.person, color: Colors.white),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          alumniItem.nmAlumni,
                          style: TextStyle(color: fgSel),
                        ),
                      ),
                      DataCell(
                        Text(alumniItem.prodi, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Text(
                          "${alumniItem.tmptLahir}, ${alumniItem.tglLahir.toIndonesianDate()}",
                          style: TextStyle(color: fgSel),
                        ),
                      ),
                      DataCell(
                        Text(alumniItem.alamat, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Text(alumniItem.noHp, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            "${alumniItem.thnLulus}",
                            style: TextStyle(color: fgSel),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }

  void konfirmasiHapus(BuildContext context, String nim) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text(
          "Apakah Anda yakin akan menghapus data alumni dengan NIM [$nim]?",
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            label: const Text("Tidak"),
            icon: const Icon(Icons.close),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              String pesan = await _alumniHelper.hapus(context, nim);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(pesan),
                    duration: const Duration(seconds: 1),
                  ),
                );
                setState(() {});
              }
            },
            label: const Text("Ya"),
            icon: const Icon(Icons.check),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initIp();
  runApp(const MainApp());
}
