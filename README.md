# 📿 ish_lang_nghiem

Tụng Kinh / Chú Lăng Nghiêm trực tiếp trên Terminal.

Chạy được trên:

- 🖥 macOS
- 🖥 Windows Git Bash / WSL
- 📱 iPhone iSH

---

## 🚀 Lệnh dùng hằng ngày

### 1. Tụng 4 câu liên tiếp: `lnN`

```bash
ln4
ln9
ln100
```

Ý nghĩa:

```text
ln4    -> câu 4, 5, 6, 7
ln9    -> câu 9, 10, 11, 12
ln100  -> câu 100, 101, 102, 103
```

Có thể dùng từ:

```text
ln1 ... ln554
```

Ví dụ:

```bash
ln25
```

sẽ tụng:

```text
25 -> 28
```

> `ln4` và `ln 4` là **hai lệnh khác nhau**.

---

### 2. Tụng từ một câu đến hết block 12: `ln N`

```bash
ln 13
```

Kết quả:

```text
13 -> 24
```

Ví dụ:

```bash
ln 4
```

Kết quả:

```text
4 -> 12
```

---

### 3. Tụng đoạn tự chọn

```bash
ln 13 27
```

Kết quả:

```text
13 -> 27
```

---

### 4. Tụng theo block 12 câu

```bash
ln 0*
ln 1*
ln 2*
```

Tương ứng:

```text
ln 0* -> 1  -> 12
ln 1* -> 13 -> 24
ln 2* -> 25 -> 36
```

Có thể gộp nhiều block:

```bash
ln 0* 1* 2*
```

Hoặc dùng range:

```bash
ln 0*:2*
```

---

### 5. Shortcut block: `bN`

`bN` là cách viết ngắn của `ln N*`.

Ví dụ:

```bash
b0
b1
b3
```

Tương ứng:

```text
b0 -> câu 1  -> 12
b1 -> câu 13 -> 24
b3 -> câu 37 -> 48
```

---

### 6. Tụng theo 5 hội: `lnc1 ... lnc5`

```bash
lnc1
lnc2
lnc3
lnc4
lnc5
```

Các đoạn hiện dùng:

```text
lnc1 -> câu   1 -> 187
lnc2 -> câu 188 -> 232
lnc3 -> câu 233 -> 363
lnc4 -> câu 364 -> 434
lnc5 -> câu 435 -> 554
```

---

### 7. Tìm theo từ khóa

```bash
lnk "tát đát"
```

Chương trình sẽ:

- liệt kê các câu khớp
- cho chọn số câu
- tụng từ câu đó đến hết block 12

---

### 8. Hiển thị ngẫu nhiên bằng `c`

```bash
c
```

Ví dụ:

```text
 ______________________________
< 02. Tô già đa da
  # 善逝 | Sugata | सुगत | 蘇伽多耶
  The present moment holds the key to liberation... >
 ------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

`c` chạy script:

```text
scripts/cow_kinh_dien.sh
```

---

## ⏳ Điều khiển khi tụng

- Không bấm phím → tự động sang câu tiếp theo sau thời gian chờ.
- Bấm phím bất kỳ → sang câu kế ngay.
- Nhấn `q` hoặc `ESC` → thoát.

Đổi tốc độ:

```bash
LN_TIMEOUT=1 ln4
LN_TIMEOUT=5 ln 13
```

---

# 🧰 Cài đặt trên máy mới

## 🖥 Windows Git Bash — cách đang dùng

Ví dụ repo nằm tại:

```text
D:\github\ish_lang_nghiem
```

Trong Git Bash sẽ là:

```text
/d/github/ish_lang_nghiem
```

### Bước 1 — clone hoặc pull repo

Nếu đã clone:

```bash
cd /d/github/ish_lang_nghiem
git pull
```

### Bước 2 — chạy installer chính

```bash
chmod +x install.sh
./install.sh
source ~/.bashrc
```

Installer hiện cài các lệnh chính như:

```text
lng
lngk
db
```

và thêm `~/.local/bin` vào `PATH`.

### Bước 3 — nạp hàm `ln`

Thêm vào `~/.bashrc` nếu chưa có:

```bash
grep -q 'ish_lang_nghiem/ln_lang_nghiem.bash' ~/.bashrc || {
  echo '' >> ~/.bashrc
  echo '#==== ISH LANG NGHIEM ====' >> ~/.bashrc
  echo 'source /d/github/ish_lang_nghiem/ln_lang_nghiem.bash' >> ~/.bashrc
}
```

Sau đó:

```bash
source ~/.bashrc
hash -r
```

Kiểm tra:

```bash
type ln
```

Kết quả mong muốn:

```text
ln is a function
```

> Git Bash vốn có `/usr/bin/ln`. Repo này dùng `ln` dưới dạng Bash function, vì vậy `type ln` phải ưu tiên function của project.

### Bước 4 — cài `ln1 ... ln554`

```bash
cd /d/github/ish_lang_nghiem
bash ln_lang_nghiem.bash install-ln4
```

Kiểm tra:

```bash
type ln2
type ln3
ln2
```

`ln2` sẽ tụng 4 câu:

```text
2 -> 5
```

### Bước 5 — cài `b0 ...`

```bash
bash ln_lang_nghiem.bash install-b
```

Ví dụ:

```bash
b3
```

tương đương:

```bash
ln 3*
```

### Bước 6 — cài `lnc1 ... lnc5`

```bash
bash ln_lang_nghiem.bash install-lnc
```

Thử:

```bash
lnc1
```

### Bước 7 — cài lệnh `c`

Nếu `c` chưa có, thêm vào `~/.bashrc`:

```bash
cat >> ~/.bashrc <<'EOF'

#==== ISH LANG NGHIEM CUSTOM COMMANDS ====

c() {
    bash /d/github/ish_lang_nghiem/scripts/cow_kinh_dien.sh "$@"
}

EOF
```

Sau đó:

```bash
source ~/.bashrc
hash -r
```

Kiểm tra:

```bash
type c
c
```

### Bước 8 — kiểm tra toàn bộ

```bash
type ln
type ln2
type b3
type lnc1
type c
```

Thử nhanh:

```bash
ln 2
ln2
b3
lnc1
c
```

---

## 🍎 macOS

Repo thường dùng:

```bash
cd ~/Documents/ish_lang_nghiem
git pull
```

Cài / cập nhật wrapper:

```bash
bash ln_lang_nghiem.bash install-ln4
bash ln_lang_nghiem.bash install-b
bash ln_lang_nghiem.bash install-lnc
hash -r
```

Đảm bảo file Bash được source trong shell startup nếu cần.

Ví dụ:

```bash
source ~/Documents/ish_lang_nghiem/ln_lang_nghiem.bash
```

Thử:

```bash
ln4
b3
lnc1
```

---

## 📱 iPhone iSH

Cài Bash và Git:

```bash
apk update
apk add bash git
```

Sau khi clone hoặc pull repo:

```bash
cd ~/GitHub/ish_lang_nghiem
git pull
```

Cài wrapper:

```bash
bash ln_lang_nghiem.bash install-ln4
bash ln_lang_nghiem.bash install-b
bash ln_lang_nghiem.bash install-lnc
```

Đảm bảo PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Nên thêm dòng trên vào `~/.bashrc` để tự động dùng sau khi mở lại iSH.

Thử:

```bash
ln4
b3
lnc1
```

---

## 🔧 Kiểm tra lỗi nhanh

### `ln2: command not found`

Chạy:

```bash
bash ln_lang_nghiem.bash install-ln4
export PATH="$HOME/.local/bin:$PATH"
hash -r
```

Sau đó:

```bash
type ln2
```

---

### `b3: command not found`

```bash
bash ln_lang_nghiem.bash install-b
hash -r
```

---

### `lnc1: command not found`

```bash
bash ln_lang_nghiem.bash install-lnc
hash -r
```

---

### `ln` chạy `/usr/bin/ln`

Kiểm tra:

```bash
type -a ln
```

Nếu Bash function chưa được nạp:

```bash
source /d/github/ish_lang_nghiem/ln_lang_nghiem.bash
```

Windows Git Bash:

```bash
echo 'source /d/github/ish_lang_nghiem/ln_lang_nghiem.bash' >> ~/.bashrc
source ~/.bashrc
```

---

### `c: command not found`

Kiểm tra file:

```bash
ls -l scripts/cow_kinh_dien.sh
```

Windows Git Bash có thể thêm:

```bash
c() {
    bash /d/github/ish_lang_nghiem/scripts/cow_kinh_dien.sh "$@"
}
```

vào:

```text
~/.bashrc
```

rồi:

```bash
source ~/.bashrc
```

---

## 📂 File chính

```text
ish_lang_nghiem/
├── lang_nghiem.md
├── ln_lang_nghiem.bash
├── install.sh
├── scripts/
│   └── cow_kinh_dien.sh
└── README.md
```

- `lang_nghiem.md` — nội dung Chú Lăng Nghiêm
- `ln_lang_nghiem.bash` — hàm `ln` và các installer liên quan
- `scripts/cow_kinh_dien.sh` — hiển thị nội dung bằng `cowsay`
- `install.sh` — installer chính
- `README.md` — hướng dẫn sử dụng

---

# 🔄 Git workflow

## Push từ máy đang sửa

```bash
git status
git add .
git commit -m "update README and terminal commands"
git push origin main
```

## Pull trên máy khác

```bash
git pull origin main
bash ln_lang_nghiem.bash install-ln4
bash ln_lang_nghiem.bash install-b
bash ln_lang_nghiem.bash install-lnc
hash -r
```

Nếu `ln` là function được source từ repo thì chỉ cần:

```bash
source ~/.bashrc
```

---

# ⚡ Cheat sheet

```text
ln4             câu 4 -> 7
ln9             câu 9 -> 12
ln100           câu 100 -> 103

ln 2            câu 2 -> 12
ln 13           câu 13 -> 24
ln 13 27        câu 13 -> 27

ln 0*           câu 1 -> 12
ln 1*           câu 13 -> 24
ln 2*           câu 25 -> 36
ln 0* 1* 2*     câu 1 -> 36
ln 0*:2*        câu 1 -> 36

b0              = ln 0*
b1              = ln 1*
b3              = ln 3*

lnc1            câu 1 -> 187
lnc2            câu 188 -> 232
lnc3            câu 233 -> 363
lnc4            câu 364 -> 434
lnc5            câu 435 -> 554

lnk "tát đát"   tìm câu theo từ khóa

c               hiển thị câu ngẫu nhiên bằng cowsay
```

---

## ✅ Sau khi cài máy mới

Test nhanh:

```bash
ln2
ln 2
b3
lnc1
c
```

Nếu cả 5 lệnh chạy được thì môi trường đã sẵn sàng.

---

## 🙏 Nam Mô A Di Đà Phật
