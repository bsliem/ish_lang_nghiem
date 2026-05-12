# Setup ish_lang_nghiem

Thư mục `setup/` chứa các file cài lệnh tắt cho từng môi trường:

```text
setup/
├── setup_mac.sh
├── setup_ish.sh
└── setup_gitbash_windows.sh
```

## 1. Nguyên tắc chung

Repo `ish_lang_nghiem` dùng chung cho nhiều thiết bị:

- Mac
- iSH iPhone 1
- iSH iPhone 2
- Git Bash Windows

Các file source chính vẫn nằm trong repo và được đồng bộ qua GitHub:

```text
ln_lang_nghiem.bash
lang_nghiem.md
add_a_di_da.bash
README.md
```

Cấu hình riêng từng máy không nằm trong repo, mà nằm ở:

```text
~/.zshrc    # Mac
~/.bashrc   # iSH / Git Bash Windows
```

Vì vậy, khi `git pull` trên từng máy, source chung không bị ảnh hưởng bởi đường dẫn riêng của từng thiết bị.

---

## 2. Cài trên Mac

Repo mặc định trên Mac:

```bash
~/Documents/ish_lang_nghiem
```

Chạy:

```bash
cd ~/Documents/ish_lang_nghiem
bash setup/setup_mac.sh
source ~/.zshrc
```

Thử:

```bash
ln 3
ln 0*
ln 1*
lnk "tát đát"
```

---

## 3. Cài trên iSH iPhone

Repo mặc định trên iSH:

```bash
~/ish_lang_nghiem
```

Nếu chưa có repo:

```bash
apk add bash git
cd ~
git clone https://github.com/bsliem/ish_lang_nghiem.git
cd ish_lang_nghiem
```

Nếu đã có repo:

```bash
cd ~/ish_lang_nghiem
git pull
```

Cài lệnh tắt:

```bash
bash setup/setup_ish.sh
source ~/.bashrc
```

Thử:

```bash
ln 3
ln 0*
ln 1*
lnk "tát đát"
```

---

## 4. Cài trên Git Bash Windows

Repo mặc định trên Git Bash Windows:

```bash
~/Documents/ish_lang_nghiem
```

Chạy:

```bash
cd ~/Documents/ish_lang_nghiem
bash setup/setup_gitbash_windows.sh
source ~/.bashrc
```

Thử:

```bash
ln 3
ln 0*
ln 1*
lnk "tát đát"
```

Nếu repo nằm chỗ khác, mở file:

```text
setup/setup_gitbash_windows.sh
```

và sửa dòng:

```bash
REPO_DIR="$HOME/Documents/ish_lang_nghiem"
```

cho đúng đường dẫn trên máy Windows.

---

## 5. Cách cập nhật repo trên từng máy

Sau khi sửa trên Mac và push lên GitHub:

```bash
git add .
git commit -m "update ish lang nghiem"
git push
```

Trên iSH iPhone hoặc máy khác chỉ cần:

```bash
cd ~/ish_lang_nghiem
git pull
```

Rồi dùng ngay:

```bash
ln 3
```

Trên Mac:

```bash
cd ~/Documents/ish_lang_nghiem
git pull
ln 3
```

---

## 6. Lệnh thường dùng

```bash
ln 3
ln 13
ln 0*
ln 1*
ln 0* 1* 2*
ln 0*:2*
lnk "tát đát"
```

---

## 7. Kiểm tra lỗi thường gặp

### Lỗi không thấy file

Nếu thấy lỗi không thấy `lang_nghiem.md`, kiểm tra:

```bash
ls
```

Trong repo phải có:

```text
ln_lang_nghiem.bash
lang_nghiem.md
```

### Lỗi Mac gọi nhầm đường dẫn iSH

Nếu thấy:

```text
/root/ish_lang_nghiem/ln_lang_nghiem.bash: No such file or directory
```

nghĩa là Mac còn dùng cấu hình cũ trong `~/.zshrc`.

Chạy lại:

```bash
cd ~/Documents/ish_lang_nghiem
bash setup/setup_mac.sh
source ~/.zshrc
```

### Lỗi iSH chưa có bash

Chạy:

```bash
apk add bash
```

Sau đó chạy lại:

```bash
bash setup/setup_ish.sh
source ~/.bashrc
```

---

## 8. Ghi nhớ ngắn

```text
Source chung để trong GitHub.
Đường dẫn riêng để trong ~/.zshrc hoặc ~/.bashrc.
Mỗi máy setup một lần.
Sau đó chỉ cần git pull là dùng được.
```

Nam Mô A Di Đà Phật.
