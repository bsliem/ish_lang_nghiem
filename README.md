# 📿 ish_lang_nghiem

Tụng Kinh / Chú Lăng Nghiêm trên Terminal.

Chạy được trên:

- 🖥 macOS
- 🖥 Windows Git Bash / WSL
- 📱 iPhone iSH

---

## 🚀 Lệnh dùng hằng ngày

### 1. Tụng 4 câu liên tiếp

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

Có thể dùng từ `ln1` đến `ln554`.

Ví dụ:

```bash
ln25
```

sẽ tụng:

```text
25 -> 28
```

---

### 2. Tụng từ một câu đến hết block 12

```bash
ln 13
```

Kết quả:

```text
13 -> 24
```

Ví dụ khác:

```bash
ln 4
```

Kết quả:

```text
4 -> 12
```

> Lưu ý: `ln4` và `ln 4` là hai lệnh khác nhau.

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

Gộp nhiều block:

```bash
ln 0* 1* 2*
```

Range block:

```bash
ln 0*:2*
```

---

### 5. Tìm theo từ khóa

```bash
lnk "tát đát"
```

Chương trình sẽ:

- liệt kê các câu khớp
- cho chọn số câu
- tụng từ câu đó đến hết block 12

---

## ⏳ Điều khiển khi tụng

- Không bấm phím -> tự động sang câu sau sau 3 giây
- Bấm phím bất kỳ -> sang câu kế ngay
- Nhấn `q` hoặc `ESC` -> thoát

Đổi tốc độ:

```bash
LN_TIMEOUT=1 ln4
LN_TIMEOUT=5 ln 13
```

---

## 🧰 Cài lệnh `ln1 ... ln554`

Sau khi clone hoặc pull repo trên một máy mới:

```bash
bash ln_lang_nghiem.bash install-ln4
```

Đảm bảo `~/.local/bin` nằm trong PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Sau đó có thể dùng:

```bash
ln4
ln9
ln100
```

---

## 🍎 macOS

Repo thường dùng:

```bash
cd ~/Documents/ish_lang_nghiem
```

Sau khi `git pull`:

```bash
bash ln_lang_nghiem.bash install-ln4
hash -r
```

Thử:

```bash
ln4
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
bash ln_lang_nghiem.bash install-ln4
export PATH="$HOME/.local/bin:$PATH"
```

Thử:

```bash
ln4
```

---

## 🖥 Windows Git Bash / WSL

Sau khi clone hoặc pull:

```bash
cd ~/Documents/ish_lang_nghiem
git pull
bash ln_lang_nghiem.bash install-ln4
export PATH="$HOME/.local/bin:$PATH"
```

Thử:

```bash
ln4
```

---

## 📂 File chính

```text
ish_lang_nghiem/
├── lang_nghiem.md
├── ln_lang_nghiem.bash
└── README.md
```

- `lang_nghiem.md` : nội dung Chú Lăng Nghiêm
- `ln_lang_nghiem.bash` : script chính
- `README.md` : hướng dẫn sử dụng

---

## 🔄 Git workflow

### Push từ máy đang sửa

```bash
git status
git add .
git commit -m "update all"
git push origin main
```

### Pull trên máy khác

```bash
git pull origin main
bash ln_lang_nghiem.bash install-ln4
```

---

## ⚡ Cheat sheet

```text
ln4             4 -> 7
ln9             9 -> 12
ln100           100 -> 103

ln 13           13 -> 24
ln 13 27        13 -> 27

ln 0*           1 -> 12
ln 1*           13 -> 24
ln 0* 1* 2*     1 -> 36
ln 0*:2*        1 -> 36

lnk "tát đát"   tìm câu
```

---

## 🙏 Nam Mô A Di Đà Phật

