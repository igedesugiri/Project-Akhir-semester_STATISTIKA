# =================================================================
# SKRIP 3: UJI ASUMSI (UJI NORMALITAS)
# =================================================================
#
# TUJUAN:
# 1. Menguji apakah data (atau residu model) terdistribusi normal.
# 2. Normalitas adalah asumsi penting untuk banyak uji statistik parametrik.
#
# METODE:
# 1. Visual: Q-Q Plot (Quantile-Quantile Plot).
# 2. Statistik: Uji Shapiro-Wilk.
#
# INSTRUKSI:
# 1. Pastikan Anda sudah menjalankan skrip '01_data_preparation.R'.
# 2. Ganti 'nama_kolom_numerik' dengan nama kolom yang sama dengan yang Anda analisis di skrip 02.
# =================================================================

# -----------------------------------------------------------------
# Langkah 0: Persiapan
# -----------------------------------------------------------------
# Jika variabel 'data_bersih' belum ada, jalankan skrip 01 terlebih dahulu.
if (!exists("data_bersih")) {
  source("01_data_preparation.R")
  print("Menjalankan skrip 01_data_preparation.R...")
}

# Ganti dengan nama kolom numerik yang ingin Anda uji normalitasnya.
# Ini sebaiknya kolom yang sama dengan yang Anda gunakan di skrip sebelumnya.
"Biaya_Akuisisi_Pelanggan_Juta_IDR" <- "nama_kolom_numerik"

# Pastikan kolom yang dipilih ada di dalam data
if(!"Biaya_Akuisisi_Pelanggan_Juta_IDR" %in% names(data_bersih)) {
  stop(paste("Kolom '", "Biaya_Akuisisi_Pelanggan_Juta_IDR", "' tidak ditemukan dalam data. Silakan periksa kembali nama kolom pada file 03_uji_asumsi.R"))
}

# -----------------------------------------------------------------
# Langkah 1: Uji Normalitas dengan Metode Visual (Q-Q Plot)
# -----------------------------------------------------------------
# Q-Q Plot membandingkan distribusi data Anda dengan distribusi normal teoritis.
# Jika data terdistribusi normal, titik-titik akan berada di sekitar garis lurus.

# Membuat Q-Q Plot
qq_plot <- ggplot(data_bersih, aes_string(sample = "Biaya_Akuisisi_Pelanggan_Juta_IDR")) +
  stat_qq() +
  stat_qq_line(color = "red", linetype = "dashed") +
  labs(
    title = "Q-Q Plot untuk Uji Normalitas",
    subtitle = paste("Variabel:", "Biaya_Akuisisi_Pelanggan_Juta_IDR"),
    x = "Kuantil Teoritis (Normal)",
    y = "Kuantil Sampel"
  ) +
  theme_minimal()

print(qq_plot)

# Menyimpan Q-Q Plot ke folder 'results'
ggsave(
  filename = "results/qq_plot_.png",
  plot = qq_plot,
  width = 8,
  height = 6
)
print(paste("Q-Q Plot disimpan di folder 'results' dengan nama qqplot_", "Pendapatan_Tahunan_Miliar_IDR", ".png", sep=""))


# -----------------------------------------------------------------
# Langkah 2: Uji Normalitas dengan Metode Statistik (Shapiro-Wilk)
# -----------------------------------------------------------------
# Uji Shapiro-Wilk adalah salah satu uji statistik yang paling umum untuk normalitas.
#
# Hipotesis:
# H0 (Hipotesis Nol): Data terdistribusi normal.
# H1 (Hipotesis Alternatif): Data tidak terdistribusi normal.
#
# Kaidah Keputusan:
# - Jika p-value > 0.05, maka kita GAGAL MENOLAK H0 (data dianggap normal).
# - Jika p-value <= 0.05, maka kita TOLAK H0 (data dianggap tidak normal).

# Melakukan uji Shapiro-Wilk
# Uji ini bekerja baik untuk sampel di bawah 5000.
if(nrow(data_bersih) < 5000) {
  shapiro_test_result <- shapiro.test(data_bersih[["Biaya_Akuisisi_Pelanggan_Juta_IDR"]])
  
  print("--- Hasil Uji Normalitas Shapiro-Wilk ---")
  print(shapiro_test_result)
  
  # Interpretasi otomatis
  p_value <- shapiro_test_result$p.value
  if (p_value > 0.05) {
    print(paste("Interpretasi: p-value =", round(p_value, 4), "> 0.05. Data kemungkinan besar terdistribusi normal."))
  } else {
    print(paste("Interpretasi: p-value =", round(p_value, 4), "<= 0.05. Data kemungkinan besar TIDAK terdistribusi normal."))
  }
  
} else {
  print("Jumlah data lebih dari 5000, uji Shapiro-Wilk mungkin tidak akurat. Pertimbangkan uji lain seperti Kolmogorov-Smirnov atau andalkan inspeksi visual (Q-Q Plot).")
}

# Pesan akhir
print("Uji normalitas selesai. Gunakan hasil ini untuk menentukan apakah analisis parametrik (seperti korelasi Pearson) sesuai untuk data Anda.")

