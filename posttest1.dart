import 'dart:io';

// enum untuk jenis transaksi
enum JenisTransaksi { pemasukan, pengeluaran }

class CatatanKeuangan {
  // penerapan null safety
  String? judul;          // variabel dapat bernilai null
  double? jumlah;         // variabel dapat bernilai null
  JenisTransaksi? jenis;  // variabel dapat bernilai null

  CatatanKeuangan(this.judul, this.jumlah, this.jenis);
}

// fungsi untuk mencetak tabel dengan pembatas 
void printTableWithBorders(List<List<String>> rows) {
  // menghitung lebar kolom secara fleksibel
  List<int> columnWidths = [];
  for (var row in rows) {
    for (int i = 0; i < row.length; i++) {
      if (columnWidths.length <= i) {
        columnWidths.add(row[i].length);
      } else if (row[i].length > columnWidths[i]) {
        columnWidths[i] = row[i].length;
      }
    }
  }

  // fungsi untuk mencetak garis pembatas atas dan bawah '='
  void printTopOrBottomSeparator() {
    stdout.write('+');
    for (var width in columnWidths) {
      stdout.write('=' * (width + 2) + '+');
    }
    print('');
  }

  // fungsi untuk mencetak garis pembatas '-'
  void printMiddleSeparator() {
    stdout.write('+');
    for (var width in columnWidths) {
      stdout.write('-' * (width + 2) + '+');
    }
    print('');
  }

  // mencetak tabel dengan pembatas di setiap baris
  printTopOrBottomSeparator();
  for (var i = 0; i < rows.length; i++) {
    stdout.write('|');
    for (int j = 0; j < rows[i].length; j++) {
      stdout.write(' ' + rows[i][j].padRight(columnWidths[j]) + ' |');
    }
    print('');
    if (i == 0) {
      printMiddleSeparator(); // garis pemisah setelah header
    }
  }
  printTopOrBottomSeparator();
}

// fungsi untuk menambah catatan
void tambahCatatan(List<CatatanKeuangan> catatan) {
  print('+========================+');
  print('| Pilih Jenis Transaksi: |');
  print('+========================+');
  print('| 1. Pemasukan           |');
  print('| 2. Pengeluaran         |');
  print('+========================+');
  stdout.write('Pilih jenis transaksi: ');
  var jenisInput = stdin.readLineSync();
  // penerapan ternary operator
  JenisTransaksi? jenis = (jenisInput == '1')
      ? JenisTransaksi.pemasukan
      : (jenisInput == '2')
          ? JenisTransaksi.pengeluaran
          : null;

  if (jenis == null) {
    print('Jenis transaksi tidak valid. Mohon coba lagi.\n');
    return;
  }

  stdout.write('Masukkan judul catatan: ');
  var judul = stdin.readLineSync();
  stdout.write('Masukkan jumlah: ');
  var inputJumlah = stdin.readLineSync();
  // penerapan null conditional
  double? jumlah = inputJumlah != null ? double.tryParse(inputJumlah) : null;

  if (judul != null && jumlah != null) {
    catatan.add(CatatanKeuangan(judul, jumlah, jenis));
    print('Catatan berhasil ditambahkan!\n');
  } else {
    print('Input tidak valid. Mohon coba lagi.\n');
  }
}

// fungsi untuk menampilkan catatan 
void tampilkanCatatan(List<CatatanKeuangan> catatan) {
  print('=== Daftar Catatan ===');
  if (catatan.isNotEmpty) {
    double totalPemasukan = 0;
    double totalPengeluaran = 0;

    // daftar catatan dalam bentuk tabel
    List<List<String>> tableData = [
      ['No', 'Judul Catatan', 'Jenis', 'Jumlah (Rp)']
    ];

    int nomor = 1;
    for (var cat in catatan) {
      tableData.add([
        nomor.toString(),
        cat.judul ?? '',
        // penerapan ternary operator
        cat.jenis == JenisTransaksi.pemasukan ? 'Pemasukan' : 'Pengeluaran',
        'Rp ${cat.jumlah?.toStringAsFixed(2)}'
      ]);
      if (cat.jenis == JenisTransaksi.pemasukan) {
        totalPemasukan += cat.jumlah ?? 0;
      } else {
        totalPengeluaran += cat.jumlah ?? 0;
      }
      nomor++;
    }

    // menampilkan tabel catatan
    printTableWithBorders(tableData);

    // menampilkan total pemasukan, pengeluaran, dan saldo akhir
    double totalSaldo = totalPemasukan - totalPengeluaran;
    print('Total Pemasukan: Rp ${totalPemasukan.toStringAsFixed(2)}');
    print('Total Pengeluaran: Rp ${totalPengeluaran.toStringAsFixed(2)}');
    print('Total Saldo: Rp ${totalSaldo.toStringAsFixed(2)}\n');
  } else {
    print('Tidak ada catatan yang tersedia.');
  }
}

// fungsi untuk mengubah catatan
void ubahCatatan(List<CatatanKeuangan> catatan) {
  if (catatan.isNotEmpty) {
    tampilkanCatatan(catatan);

    stdout.write('Masukkan nomor catatan yang ingin diubah: ');
    var indexInput = stdin.readLineSync();
    int? index = indexInput != null ? int.tryParse(indexInput) : null;

    if (index != null && index > 0 && index <= catatan.length) {
      var catatanYangDipilih = catatan[index - 1];

      print('+=============================+');
      print('| Pilih Jenis Transaksi Baru: |');
      print('+=============================+');
      print('| 1. Pemasukan                |');
      print('| 2. Pengeluaran              |');
      print('+=============================+');
      stdout.write('Pilih jenis transaksi: ');
      var jenisInput = stdin.readLineSync();
      // penerapan ternary operator
      JenisTransaksi? jenis = (jenisInput == '1')
          ? JenisTransaksi.pemasukan
          : (jenisInput == '2')
              ? JenisTransaksi.pengeluaran
              : null;

      if (jenis == null) {
        print('Jenis transaksi tidak valid. Mohon coba lagi.\n');
        return;
      }

      stdout.write('Masukkan judul catatan baru: ');
      var judulBaru = stdin.readLineSync();
      stdout.write('Masukkan jumlah baru: ');
      var inputJumlahBaru = stdin.readLineSync();
      double? jumlahBaru = inputJumlahBaru != null ? double.tryParse(inputJumlahBaru) : null;

      if (judulBaru != null && jumlahBaru != null) {
        catatanYangDipilih.judul = judulBaru;
        catatanYangDipilih.jumlah = jumlahBaru;
        catatanYangDipilih.jenis = jenis;
        print('Catatan berhasil diubah!\n');
      } else {
        print('Input tidak valid. Mohon coba lagi.\n');
      }
    } else {
      print('Nomor catatan tidak valid.\n');
    }
  } else {
    print('Tidak ada catatan yang tersedia untuk diubah.');
  }
}

// Fungsi untuk menghapus catatan
void hapusCatatan(List<CatatanKeuangan> catatan) {
  if (catatan.isNotEmpty) {
    tampilkanCatatan(catatan);

    stdout.write('Masukkan nomor catatan yang ingin dihapus: ');
    var indexInput = stdin.readLineSync();
    int? index = indexInput != null ? int.tryParse(indexInput) : null;

    if (index != null && index > 0 && index <= catatan.length) {
      catatan.removeAt(index - 1);
      print('Catatan berhasil dihapus!\n');
    } else {
      print('Nomor catatan tidak valid.\n');
    }
  } else {
    print('Tidak ada catatan yang tersedia untuk dihapus.');
  }
}

// Fungsi menu utama
void tampilkanMenu(List<CatatanKeuangan> catatan) {
  while (true) {
    print('+=====================================+');
    print('|      Aplikasi Catatan Keuangan      |');
    print('+=====================================+');
    print('| 1. Tambah Catatan                   |');
    print('| 2. Tampilkan Catatan                |');
    print('| 3. Ubah Catatan                     |');
    print('| 4. Hapus Catatan                    |');
    print('| 5. Keluar                           |');
    print('+=====================================+');
    stdout.write('Pilih opsi: ');

    var pilihan = stdin.readLineSync();

    switch (pilihan) {
      case '1':
        tambahCatatan(catatan);
        break;
      case '2':
        tampilkanCatatan(catatan);
        break;
      case '3':
        ubahCatatan(catatan);
        break;
      case '4':
        hapusCatatan(catatan);
        break;
      case '5':
        print('+=====================================+');
        print('|    Terima Kasih Telah Menggunakan   |');
        print('|    Aplikasi Catatan Keuangan Dart   |');
        print('|            Sampai Jumpa!            |');
        print('+=====================================+');
        return;
      default:
        print('Pilihan tidak valid. Mohon coba lagi.\n');
    }
  }
}

void main() {
  List<CatatanKeuangan> catatan = [];
  tampilkanMenu(catatan);
}
